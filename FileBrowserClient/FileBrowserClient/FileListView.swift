//
//  FileListView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//


import SwiftUI

struct FileListView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var files: [FileItem] = []
    @State private var errorMessage: String?
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    ForEach(files) { file in
                        HStack {
                            Image(systemName: file.type == "dir" ? "folder" : "doc.text")
                            Text(file.name)
                        }
                    }
                }
            }
            .navigationTitle("Files")
            .onAppear {
                loadFiles()
            }
        }
    }

    func loadFiles() {
        guard let token = auth.token,
              let serverURL = auth.serverURL,
              let url = URL(string: "\(serverURL)/api/resources") else {
            self.errorMessage = "Missing token or server URL"
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }

                do {
                    let result = try JSONDecoder().decode(ResourceResponse.self, from: data)
                    self.files = result.items
                } catch {
                    errorMessage = "Failed to parse file list"
                    print(String(data: data, encoding: .utf8) ?? "")
                }
            }
        }.resume()
    }
}

// Wrapper for decoding FileBrowser's response
struct ResourceResponse: Codable {
    let items: [FileItem]
}
