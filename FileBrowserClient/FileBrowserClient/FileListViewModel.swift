//
//  FileListViewModel.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/7/25.
//

import Foundation
import SwiftUI

class FileListViewModel: ObservableObject {
    @Published var files: [FileItem] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var searchResults: [FileItemSearch] = []
    private var currentTask: Task<Void, Never>?

    @Published var sheetItems: [FileItem] = []
    @Published var sheetIsLoading: Bool = false

    var token: String?
    var serverURL: String?

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
            performFetch(at: path)
        }
    }

    func performFetch(at path: String) {
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
            self.isLoading = true
            self.errorMessage = nil
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.isLoading = false
                    self.errorMessage = "Server error: Invalid response"
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    self.isLoading = false
                    self.errorMessage = "Server error: [\(httpResponse.statusCode)]: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                    Log.error("❌ Server error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                    return
                }

                self.isLoading = false

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
                    Log.info("Loaded \(fileItems.count) items at path: \(path)")
                    // for file in fileItems {
                    //    Log.debug(" - \(file.name) [\(file.isDir ? "folder" : "file")]")
                    // }
                    self.files = fileItems
                    self.isLoading = false
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

    func getFiles(at path: String) {
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
            self.sheetIsLoading = true
            self.errorMessage = nil
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.sheetIsLoading = false
                    self.errorMessage = "Server error: Invalid response"
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    self.sheetIsLoading = false
                    self.errorMessage = "Server error: [\(httpResponse.statusCode)]: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                    Log.error("❌ Server error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                    return
                }

                self.sheetIsLoading = false

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
                    Log.info("Loaded \(fileItems.count) items at path: \(path)")
                    // for file in fileItems {
                    //    Log.debug(" - \(file.name) [\(file.isDir ? "folder" : "file")]")
                    // }
                    self.sheetItems = fileItems
                    self.sheetIsLoading = false
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
