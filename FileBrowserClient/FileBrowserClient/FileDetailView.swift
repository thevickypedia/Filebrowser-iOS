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
                let imageExtensions: [String] = [
                    ".png", ".jpg", ".jpeg", ".webp", ".avif", ".heif", ".heic"
                ]
                let textExtensions: [String] = [
                    ".txt", ".log", ".json", ".yaml", ".xml", ".yml", ".csv", ".tsv", ".ini", ".properties", ".sh",
                    ".bat", ".ps1", ".psd", ".psb", ".text", ".rtf", ".doc", ".docx", ".xls", ".xlsx", ".ppt",
                    ".py", ".scala", ".rb", ".swift", ".go", ".java", ".c", ".cpp", ".h", ".hpp", ".m", ".mm",
                    ".java", ".css", ".rs", ".ts"
                ]
                if imageExtensions.contains(where: fileName.hasSuffix) {
                    if let image = UIImage(data: content) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } else {
                        Text("Failed to load image")
                    }
                } else if textExtensions.contains(where: fileName.hasSuffix) {
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
