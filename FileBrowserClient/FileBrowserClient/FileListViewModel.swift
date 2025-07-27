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
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    var token: String?
    var serverURL: String?

    func configure(token: String, serverURL: String) {
        self.token = token
        self.serverURL = serverURL
    }

    func fetchFiles(at path: String) {
        Log.debug("📡 Fetching files at path: \(path)")
        guard let token = token, let serverURL = serverURL else {
            errorMessage = "Missing auth"
            return
        }

        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(serverURL)/api/resources/\(encodedPath)") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: request) { data, response, error in
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
                    Log.info("Loaded \(result.items.count) items at path: \(path)")
                    for file in result.items {
                        Log.debug(" - \(file.name) [\(file.isDir ? "folder" : "file")]")
                    }
                    self.files = result.items
                    self.isLoading = false
                } catch {
                    self.errorMessage = "Failed to parse files"
                    Log.error("Raw response: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
            }
        }.resume()
    }
}
