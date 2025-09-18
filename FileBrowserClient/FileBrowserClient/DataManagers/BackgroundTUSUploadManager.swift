//
//  BackgroundTUSUploadManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/2/25.
//

import Foundation
import UIKit

/// Background TUS Upload Manager
/// - Uses a background URLSession to upload file chunks using PATCH requests (TUS-style).
/// - Persists upload records to disk so uploads can resume across restarts.
final class BackgroundTUSUploadManager: NSObject {
    static let shared = BackgroundTUSUploadManager()

    // MARK: - Public types
    struct UploadRecord: Codable {
        enum State: String, Codable {
            case queued, uploading, paused, completed, failed
        }

        let id: UUID
        let fileURL: URL       // local file (absolute)
        let tusURL: URL        // TUS upload resource URL on server
        var offset: Int64
        var chunkSize: Int64
        var totalSize: Int64
        var state: State
        var lastError: String?
    }

    // MARK: - Persistence
    private let storageURL: URL = {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("background_uploads.json")
    }()

    private(set) var records: [UUID: UploadRecord] = [:]
    private let recordsQueue = DispatchQueue(label: "BackgroundTUSUploadManager.records.q", attributes: .concurrent)

    // MARK: - URLSession
    private let sessionIdentifier = "com.yourapp.FileBrowserClient.tusBackgroundSession" // choose stable identifier
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        config.sessionSendsLaunchEvents = true
        config.isDiscretionary = false
        config.waitsForConnectivity = true
        config.httpMaximumConnectionsPerHost = 1
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    // Saved system completion handler (from AppDelegate) to call when session finishes events
    private var backgroundSessionCompletionHandler: (() -> Void)?

    /// Perform a HEAD request to get the latest Upload-Offset from server
    private func fetchServerOffset(for rec: UploadRecord, completion: @escaping (Int64?) -> Void) {
        var req = URLRequest(url: rec.tusURL)
        req.httpMethod = "HEAD"
        req.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        // include auth header if needed
        // req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: req) { _, response, _ in
            if let http = response as? HTTPURLResponse,
               let header = http.allHeaderFields["Upload-Offset"] as? String,
               let offset = Int64(header) {
                completion(offset)
                return
            }
            completion(nil)
        }
        task.resume()
    }

    // MARK: - Init
    private override init() {
        super.init()
        loadRecords()
        // Recreate session (this attaches delegate and will resume tasks the OS has)
        _ = session
        // If we have pending records, resume them
        resumePendingUploads()
    }

    // MARK: - Public API

    /// Enqueue an upload given a TUS upload resource URL (returned by your server) and a local file URL.
    /// chunkSize defaults to 5 MiB; adjust as needed.
    func enqueueUpload(tusUploadURL: URL, fileURL: URL, chunkSize: Int64 = 5 * 1024 * 1024) {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            let totalSize = (attr[.size] as? NSNumber)?.int64Value ?? 0
            let record = UploadRecord(
                id: UUID(),
                fileURL: fileURL,
                tusURL: tusUploadURL,
                offset: 0,
                chunkSize: chunkSize,
                totalSize: totalSize,
                state: .queued,
                lastError: nil
            )
            saveRecord(record)
            startOrContinueUpload(record.id)
        } catch {
            Log.error("Unable to get attributes for file \(fileURL): \(error)")
        }
    }

    /// Attempt to resume pending uploads on startup / when requested
    func resumePendingUploads() {
        recordsQueue.sync {
            let pending = records.values.filter { $0.state == .queued || $0.state == .uploading || $0.state == .paused || $0.state == .failed }
            for rec in pending {
                startOrContinueUpload(rec.id)
            }
        }
    }

    /// Called by AppDelegate when OS wakes app for background session events.
    func setBackgroundSessionCompletionHandler(_ handler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = handler
    }

    // MARK: - Private helpers
    private func startOrContinueUpload(_ id: UUID) {
        guard var rec = record(id: id) else { return }
        // Update state
        rec.state = .uploading
        saveRecord(rec)

        // Schedule next chunk
        scheduleUploadChunk(for: rec)
    }

    private func scheduleUploadChunk(for rec: UploadRecord) {
        // If already finished, do nothing
        if rec.offset >= rec.totalSize {
            markCompleted(rec.id)
            return
        }

        // Compute chunk range
        let remaining = rec.totalSize - rec.offset
        let thisChunkSize = min(rec.chunkSize, remaining)
        let rangeStart = rec.offset
        let rangeEnd = rec.offset + thisChunkSize - 1
        Log.debug("Uploading bytes \(rangeStart)-\(rangeEnd)")
        // Create a temp file containing the chunk bytes
        guard let chunkFileURL = try? createTempChunkFile(source: rec.fileURL, offset: rangeStart, length: thisChunkSize) else {
            updateRecordError(id: rec.id, message: "Failed to create chunk file")
            return
        }

        // Build the PATCH request
        var req = URLRequest(url: rec.tusURL)
        req.httpMethod = "PATCH"
        req.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        req.setValue(String(rec.offset), forHTTPHeaderField: "Upload-Offset")
        req.setValue("application/offset+octet-stream", forHTTPHeaderField: "Content-Type")
        // add auth header if needed — you should add token injection here if your server requires it.
        // e.g. req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Create uploadTask from the chunk file (background requires file-backed upload)
        let uploadTask = session.uploadTask(with: req, fromFile: chunkFileURL)
        // Tag task with our upload id using taskDescription
        uploadTask.taskDescription = rec.id.uuidString
        uploadTask.resume()
    }

    // Create a temporary file containing the byte range [offset, offset+length-1] from source file.
    private func createTempChunkFile(source: URL, offset: Int64, length: Int64) throws -> URL {
        let tmpDir = FileManager.default.temporaryDirectory
        let uuid = UUID().uuidString
        let chunkFile = tmpDir.appendingPathComponent("tus_chunk_\(uuid)")
        // Read range and write
        let fh = try FileHandle(forReadingFrom: source)
        defer { try? fh.close() }

        try fh.seek(toOffset: UInt64(offset))
        let data = try fh.read(upToCount: Int(length)) ?? Data()
        try data.write(to: chunkFile, options: .atomic)
        return chunkFile
    }

    // MARK: - Record persistence
    private func saveRecord(_ record: UploadRecord) {
        recordsQueue.async(flags: .barrier) {
            self.records[record.id] = record
            self.saveAllRecordsToDisk()
        }
    }

    private func updateRecord(_ id: UUID, update: @escaping (inout UploadRecord) -> Void) {
        recordsQueue.async(flags: .barrier) {
            guard var record = self.records[id] else { return }
            update(&record)
            self.records[id] = record
            self.saveAllRecordsToDisk()
        }
    }

    private func updateRecordError(id: UUID, message: String) {
        updateRecord(id) { rec in
            rec.lastError = message
            rec.state = .failed
        }
    }

    private func markCompleted(_ id: UUID) {
        updateRecord(id) { rec in
            rec.state = .completed
            rec.offset = rec.totalSize
        }
    }

    private func record(id: UUID) -> UploadRecord? {
        return recordsQueue.sync {
            return records[id]
        }
    }

    private func removeRecord(id: UUID) {
        recordsQueue.async(flags: .barrier) {
            self.records.removeValue(forKey: id)
            self.saveAllRecordsToDisk()
        }
    }

    private func loadRecords() {
        do {
            let data = try Data(contentsOf: storageURL)
            let decoder = JSONDecoder()
            let arr = try decoder.decode([UploadRecord].self, from: data)
            var dict: [UUID: UploadRecord] = [:]
            for record in arr { dict[record.id] = record }
            recordsQueue.async(flags: .barrier) { self.records = dict }
        } catch {
            // ignore if not exist
        }
    }

    private func saveAllRecordsToDisk() {
        let arr = Array(records.values)
        do {
            let data = try JSONEncoder().encode(arr)
            try data.write(to: storageURL, options: .atomic)
        } catch {
            Log.info("BackgroundTUS: failed to save uploads: \(error)")
        }
    }
}

// MARK: - URLSessionDelegate and Task Delegate
extension BackgroundTUSUploadManager: URLSessionDelegate, URLSessionTaskDelegate {
    // Called when upload tasks finish (with or without error)
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let uuidString = task.taskDescription, let id = UUID(uuidString: uuidString) else { return }

        if let err = error as? URLError, err.code == .networkConnectionLost {
            // Special handling for lost network
            Log.warn("⚠️ Network lost for upload \(id). Checking offset and retrying...")
            if let rec = record(id: id) {
                fetchServerOffset(for: rec) { [weak self] serverOffset in
                    guard let self = self else { return }
                    if let newOffset = serverOffset {
                        self.updateRecord(id) { record in record.offset = newOffset }
                        if let updated = self.record(id: id) {
                            self.scheduleUploadChunk(for: updated)
                        }
                    } else {
                        // fallback: retry same chunk
                        self.scheduleUploadChunk(for: rec)
                    }
                }
            }
            return
        }

        if let err = error {
            // All other errors — log + mark as failed
            Log.error("BackgroundTUS: task \(task.taskIdentifier) failed: \(err)")
            updateRecordError(id: id, message: err.localizedDescription)
            return
        }

        // No error — check server response for new offset
        if let httpResp = task.response as? HTTPURLResponse {
            // TUS PATCH should return 204 (or 200) and header Upload-Offset with new value
            let status = httpResp.statusCode
            if status == 204 || status == 200 || status == 201 {
                // parse header
                if let offsetHeader = httpResp.allHeaderFields["Upload-Offset"] as? String, let newOffset = Int64(offsetHeader) {
                    // update record and schedule next chunk
                    updateRecord(id) { rec in
                        rec.offset = newOffset
                        rec.state = .uploading
                        rec.lastError = nil
                    }
                    // fetch record and schedule next chunk
                    if let rec = record(id: id) {
                        // remove associated temp chunk file? We didn't keep track of it — background tasks created chunk files in /tmp, we should attempt to cleanup by scanning temp for "tus_chunk_*" maybe later.
                        // Schedule next chunk if any
                        if rec.offset >= rec.totalSize {
                            markCompleted(id)
                            // optionally notify success
                        } else {
                            scheduleUploadChunk(for: rec)
                        }
                    }
                } else {
                    // No Upload-Offset header — maybe server returns the full bytes accepted or 204 with no header
                    // Fallback: assume entire chunk uploaded: increment offset by last chunk size
                    if let rec = record(id: id) {
                        let step = rec.chunkSize
                        let nextOffset = min(rec.totalSize, rec.offset + step)
                        updateRecord(id) { record in record.offset = nextOffset }
                        if nextOffset >= rec.totalSize {
                            markCompleted(id)
                        } else {
                            if let updatedRec = record(id: id) { scheduleUploadChunk(for: updatedRec) }
                        }
                    }
                }
            } else {
                // server returned an error
                let msg = "Server error: \(status)"
                updateRecordError(id: id, message: msg)
            }
        } else {
            updateRecordError(id: id, message: "No HTTP response")
        }
    }

    // Progress updates (called frequently)
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        // Map task to upload record by taskDescription
        if let uuidString = task.taskDescription, let id = UUID(uuidString: uuidString), let rec = record(id: id) {
            // totalBytesSent/Expected correspond to the chunk file upload; compute global progress
            let chunkBytesSent = totalBytesSent
            let globalProgress = Double(rec.offset + chunkBytesSent) / Double(rec.totalSize)
            // Send progress notification (NotificationCenter) so UI can update
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .BackgroundTUSUploadProgress,
                                                object: nil,
                                                userInfo: ["id": id, "progress": globalProgress, "bytesSent": rec.offset + chunkBytesSent, "total": rec.totalSize])
            }
        }
    }

    // Called when all background events for this session are delivered
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        // call saved completion handler so system can snapshot UI
        DispatchQueue.main.async {
            if let handler = self.backgroundSessionCompletionHandler {
                handler()
                self.backgroundSessionCompletionHandler = nil
            }
        }
    }
}

// MARK: - Notifications
extension Notification.Name {
    static let BackgroundTUSUploadProgress = Notification.Name("BackgroundTUSUploadProgress")
}
