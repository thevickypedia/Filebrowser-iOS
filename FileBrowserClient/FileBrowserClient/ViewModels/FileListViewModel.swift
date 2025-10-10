//
//  FileListViewModel.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/7/25.
//

import Foundation
import SwiftUI

enum ModifyItem: String {
    case copy = "Copy"
    case move = "Move"
}

enum TransferType: String {
    case upload = "Upload"
    case download = "Download"
}

enum TransferStatus: String {
    case paused, resumed, cancelled

    var emoji: String {
        switch self {
        case .paused: return "⏸️"
        case .resumed: return "▶️"
        case .cancelled: return "❌"
        }
    }

    var color: Color {
        switch self {
        case .paused: return .yellow
        case .resumed: return .green
        case .cancelled: return .red
        }
    }

    var prefix: String {
        self == .resumed ? "from" : "at"
    }
}

enum TransferResult: String {
    case success, failed
}

struct TransferProgressStore {
    var files: [FileItem: TransferResult] = [:]
    var type: TransferType?
}

struct TransferState {
    var transferType: TransferType?
    var currentTransferIndex = 0
    var transferProgress: Double = 0.0
    var transferProgressPct: Int = 0
    var currentTransferFile: String?
    var currentTransferFileSize: String?
    var currentTransferedFileSize: String?
    var isTransferCancelled = false
    var isTransferPaused = false
    var currentTransferSpeed: Double = 0.0
    var currentTransferFileIcon: String?
}

struct DownloadQueueItem: Identifiable {
    let id = UUID()
    let file: FileItem
}

class FileListViewModel: ObservableObject {
    @Published var files: [FileItem] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var searchResults: [FileItemSearch] = []
    private var currentTask: Task<Void, Never>?
    @Published var items: [FileItem] = []
    private var _uploadProgress: [String: Double] = [:] // [filePath: progress]

    @Published var sheetItems: [FileItem] = []
    @Published var sheetIsLoading: Bool = false

    var token: String?
    var serverURL: String?

    func uploadProgressForFile(path: String) -> Double? {
        return _uploadProgress[path]
    }

    func setUploadProgress(forPath path: String, progress: Double) {
        _uploadProgress[path] = progress
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    func cancelCurrentFetch() {
        currentTask?.cancel()
    }

    func configure(token: String, serverURL: String) {
        self.token = token
        self.serverURL = serverURL
    }

    func sortedFiles(by sortOption: SortOption) -> [FileItem] {
        files.sorted { firstFile, secondFile in
            if firstFile.isDir && !secondFile.isDir { return true }
            if !firstFile.isDir && secondFile.isDir { return false }

            switch sortOption {
            case .nameAsc: return firstFile.name.localizedStandardCompare(secondFile.name) == .orderedAscending
            case .nameDesc: return firstFile.name.localizedStandardCompare(secondFile.name) == .orderedDescending
            case .sizeAsc: return (firstFile.size ?? 0) < (secondFile.size ?? 0)
            case .sizeDesc: return (firstFile.size ?? 0) > (secondFile.size ?? 0)
            case .modifiedAsc: return (firstFile.modified ?? "") < (secondFile.modified ?? "")
            case .modifiedDesc: return (firstFile.modified ?? "") > (secondFile.modified ?? "")
            }
        }
    }

    func fetchFiles(baseRequest: Request, at path: String) {
        currentTask?.cancel()
        currentTask = Task {
            getFiles(baseRequest: baseRequest, at: path, modifySheet: false)
        }
    }

    func getFiles(baseRequest: Request, at path: String, modifySheet: Bool) {
        let setLoading: (Bool) -> Void = { isLoading in
            if modifySheet {
                self.sheetIsLoading = isLoading
            } else {
                self.isLoading = isLoading
            }
        }
        Log.debug("📡 Fetching files at path: \(path)")
        guard let preparedRequest = baseRequest.prepare(pathComponents: ["api", "resources", path]) else {
            let msg = "Failed to prepare request for: /api/resources/\(path)"
            Log.error("❌ \(msg)")
            errorMessage = msg
            return
        }

        DispatchQueue.main.async {
            self.errorMessage = nil
            setLoading(true)
        }

        preparedRequest.session.dataTask(with: preparedRequest.request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    setLoading(false)
                    self.errorMessage = "Server error: Invalid response"
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    return
                }

                let responseText = formatHttpResponse(httpResponse)
                guard httpResponse.statusCode == 200 else {
                    setLoading(false)
                    self.errorMessage = "Server error: \(responseText)"
                    Log.error("❌ Server error: \(responseText)")
                    return
                }

                setLoading(false)
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let result = try JSONDecoder().decode(ResourceResponse.self, from: data)
                    let fileItems = result.items
                    Log.debug("Loaded \(fileItems.count) items at path: \(path)")
                    // for file in fileItems {
                    //    Log.debug(" - \(file.name) [\(file.isDir ? "folder" : "file")]")
                    // }
                    if modifySheet {
                        self.sheetItems = fileItems
                    } else {
                        self.files = fileItems
                    }
                } catch {
                    self.errorMessage = "Failed to parse files"
                    Log.error("Failed to decode JSON: \(error.localizedDescription)")
                    if let raw = String(data: data, encoding: .utf8) {
                        Log.error("❌ Raw response: \(raw)")
                    }
                }
            }
        }.resume()
    }
}
