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

    var token: String?
    var serverURL: String?

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
        Log.debug("📡 Fetching files at path: \(path)")
        guard let token = token, let serverURL = serverURL else {
            errorMessage = "Missing auth"
            return
        }

        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(serverURL)/api/resources/\(removePrefix(urlPath: encodedPath))") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
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
}
