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

enum TransferAction: String {
    case upload = "Upload"
    case download = "Download"
}

enum TransferState: String {
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

    func reconcilePendingUploads() {
        // get snapshot of manager records
        let records = BackgroundTUSUploadManager.shared.records.values
        for rec in records {
            let progress = Double(rec.offset) / Double(max(1, rec.totalSize))
            _uploadProgress[rec.fileURL.path] = progress
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

    func fetchFiles(at path: String) {
        currentTask?.cancel()
        currentTask = Task {
            getFiles(at: path, modifySheet: false)
        }
    }

    func getFiles(at path: String, modifySheet: Bool) {
        let setLoading: (Bool) -> Void = { isLoading in
            if modifySheet {
                self.sheetIsLoading = isLoading
            } else {
                self.isLoading = isLoading
            }
        }
        Log.debug("📡 Fetching files at path: \(path)")
        guard let token = token, let serverURL = serverURL else {
            DispatchQueue.main.async {
                self.errorMessage = "Missing auth"
            }
            return
        }

        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "resources", path],
            queryItems: []
        ) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        DispatchQueue.main.async {
            self.errorMessage = nil
            setLoading(true)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    setLoading(false)
                    self.errorMessage = "Server error: Invalid response"
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    setLoading(false)
                    self.errorMessage = "Server error: [\(httpResponse.statusCode)]: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                    Log.error("❌ Server error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
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
