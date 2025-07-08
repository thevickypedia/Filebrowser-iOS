//
//  FileDetailView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/7/25.
//


import SwiftUI

struct FileDetailView: View {
    let file: FileItem
    let serverURL: String
    let token: String

    @State private var content: Data? = nil
    @State private var error: String? = nil

    var body: some View {
        Group {
            if let content = content {
                let fileName = file.name.lowercased();
                if fileName.hasSuffix(".png") ||
                    fileName.hasSuffix(".jpg") ||
                    fileName.hasSuffix(".jpeg") ||
                    fileName.hasSuffix(".webp") ||
                    fileName.hasSuffix(".avif") ||
                    fileName.hasSuffix(".heif") ||
                    fileName.hasSuffix(".heic") ||
                    fileName.hasSuffix(".pdf") {
                    if let image = UIImage(data: content) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } else {
                        Text("Failed to load image")
                    }
                } else if fileName.hasSuffix(".txt") || fileName.hasSuffix(".log") {
                    if let text = String(data: content, encoding: .utf8) {
                        ScrollView {
                            Text(text)
                                .padding()
                        }
                    } else {
                        Text("Failed to decode text")
                    }
                } else {
                    Text("File preview not supported for this type.")
                        .foregroundColor(.gray)
                }
            } else if let error = error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Loading file...")
            }
        }
        .navigationTitle(file.name)
        .onAppear {
            downloadFile()
        }
    }

    func downloadFile() {
        guard let url = URL(string: "\(serverURL)/api/raw/\(file.path)") else {
            error = "Invalid file URL"
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, response, err in
            DispatchQueue.main.async {
                if let err = err {
                    error = err.localizedDescription
                    return
                }

                guard let data = data else {
                    error = "No data received"
                    return
                }

                self.content = data
            }
        }.resume()
    }
}
