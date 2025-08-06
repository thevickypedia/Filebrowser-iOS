//
//  UploadManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/6/25.
//


import Foundation

final class UploadManager: NSObject, ObservableObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    static let shared = UploadManager()

    // MAJOR BUGS
    // 1. Upload works in the background but truncates midway through
    // 2. Uploads to root directory instead of sub-folders

    @Published var isUploading = false
    @Published var uploadProgress: Double = 0.0

    private var uploadQueue: [URL] = []
    private var currentUploadIndex = 0
    private var uploadTask: URLSessionUploadTask?
    private var isUploadCancelled = false

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "com.yourapp.upload.bg")
        config.isDiscretionary = false
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: .main)
    }()

    private var auth: AuthManager!
    private var path: String = "/"

    private var serverURL: String? { auth.serverURL }
    private var token: String? { auth.token }

    private struct TaskContext {
        enum TaskType {
            case create
            case head
            case patch
        }
        let fileURL: URL
        let uploadURL: URL
        let type: TaskType
        var offset: Int = 0
        var fileSize: Int = 0
        var fileHandle: FileHandle? = nil
    }

    private var taskContextMap: [Int: TaskContext] = [:]

    func startQueue(_ files: [URL], auth: AuthManager, path: String) {
        self.auth = auth
        self.path = path
        uploadQueue = files
        currentUploadIndex = 0
        isUploadCancelled = false
        isUploading = true
        uploadProgress = 0.0
        uploadNextInQueue()
    }

    func cancel() {
        isUploadCancelled = true
        uploadTask?.cancel()
        uploadTask = nil
        isUploading = false
        uploadQueue = []
        currentUploadIndex = 0
        uploadProgress = 0.0
        taskContextMap.removeAll()
    }

    private func uploadNextInQueue() {
        guard currentUploadIndex < uploadQueue.count else {
            isUploading = false
            return
        }
        initiateTusUpload(for: uploadQueue[currentUploadIndex])
    }

    private func getUploadURL(path: String, encodedName: String) -> URL? {
        guard let serverURL else { return nil }
        if path == "/" {
            return URL(string: "\(serverURL)/api/tus/\(encodedName)?override=false")
        }
        return URL(string: "\(serverURL)/api/tus/\(path)/\(encodedName)?override=false")
    }

    private func initiateTusUpload(for fileURL: URL) {
        guard let token, let serverURL else {
            Log.error("❌ Missing auth info")
            return
        }

        let fileName = fileURL.lastPathComponent
        guard let encodedName = fileName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let uploadURL = getUploadURL(path: "/", encodedName: encodedName) else {
            Log.error("❌ Invalid upload URL")
            return
        }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        let task = session.dataTask(with: request)
        taskContextMap[task.taskIdentifier] = TaskContext(fileURL: fileURL, uploadURL: uploadURL, type: .create)
        task.resume()
    }

    private func getUploadOffset(fileURL: URL, uploadURL: URL) {
        guard let token else { return }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "HEAD"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        let task = session.dataTask(with: request)
        taskContextMap[task.taskIdentifier] = TaskContext(fileURL: fileURL, uploadURL: uploadURL, type: .head)
        task.resume()
    }

    private func uploadChunk(_ context: TaskContext) {
        guard let token else { return }

        var context = context // mutable copy

        if isUploadCancelled {
            context.fileHandle?.closeFile()
            Log.info("⏹️ Upload cancelled")
            isUploading = false
            return
        }

        if context.offset >= context.fileSize {
            context.fileHandle?.closeFile()
            Log.info("✅ Upload complete: \(context.fileURL.lastPathComponent)")
            currentUploadIndex += 1
            uploadNextInQueue()
            return
        }

        context.fileHandle?.seek(toFileOffset: UInt64(context.offset))
        let data = context.fileHandle?.readData(ofLength: chunkSize * 1024 * 1024) ?? Data()

        // ✅ Save data chunk to temporary file
        let tempFileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)

        do {
            try data.write(to: tempFileURL)
        } catch {
            Log.error("❌ Failed to write temp file: \(error.localizedDescription)")
            return
        }

        var request = URLRequest(url: context.uploadURL)
        request.httpMethod = "PATCH"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue("\(context.offset)", forHTTPHeaderField: "Upload-Offset")
        request.setValue("application/offset+octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        // ✅ Use uploadTask(with:fromFile:) instead of from: Data
        let task = session.uploadTask(with: request, fromFile: tempFileURL)

        // Update context
        context.offset += data.count
        taskContextMap[task.taskIdentifier] = context
        uploadTask = task
        task.resume()
    }

    // MARK: - URLSessionTaskDelegate

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let context = taskContextMap[task.taskIdentifier] else { return }
        defer { taskContextMap.removeValue(forKey: task.taskIdentifier) }

        if let error {
            Log.error("❌ \(context.type) task failed: \(error.localizedDescription)")
            return
        }

        switch context.type {
        case .create:
            getUploadOffset(fileURL: context.fileURL, uploadURL: context.uploadURL)

        case .head:
            if let http = task.response as? HTTPURLResponse,
               let offsetStr = http.value(forHTTPHeaderField: "Upload-Offset"),
               let offset = Int(offsetStr),
               let fileHandle = try? FileHandle(forReadingFrom: context.fileURL) {
                
                let fileSize = (try? FileManager.default.attributesOfItem(atPath: context.fileURL.path)[.size] as? Int) ?? 0

                var newContext = context
                newContext.offset = offset
                newContext.fileSize = fileSize
                newContext.fileHandle = fileHandle

                uploadChunk(newContext)
            } else {
                Log.error("❌ HEAD response missing Upload-Offset")
            }

        case .patch:
            uploadProgress = Double(context.offset) / Double(context.fileSize)
            uploadChunk(context)
        }
    }
}
