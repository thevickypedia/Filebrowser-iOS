//
//  FileDetailView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/7/25.
//


import SwiftUI

struct ResourceMetadata: Codable {
    let name: String
    let path: String
    let size: Int
    let modified: String
    let type: String
    let extension_: String?
    let resolution: Resolution?

    enum CodingKeys: String, CodingKey {
        case name, path, size, modified, type
        case extension_ = "extension"
        case resolution
    }
}

struct Resolution: Codable {
    let width: Int
    let height: Int
}

struct FileDetailView: View {
    let file: FileItem
    let serverURL: String
    let token: String

    @State private var content: Data? = nil
    @State private var error: String? = nil
    @State private var metadata: ResourceMetadata? = nil
    @State private var showInfo = false
    @State private var isRenaming = false
    @State private var newName = ""
    @State private var showingDeleteConfirm = false
    @State private var downloadMessage: String? = nil

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
                } else if fileName.hasSuffix(".pdf") {
                    PDFKitView(data: content)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        let metadataURL = URL(string: "\(serverURL)/api/resources/\(file.path)")!
        var metadataRequest = URLRequest(url: metadataURL)
        metadataRequest.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: metadataRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Metadata error: \(error.localizedDescription)"
                    return
                }

                guard let data = data,
                      let resource = try? JSONDecoder().decode(ResourceMetadata.self, from: data) else {
                    self.error = "Failed to decode metadata"
                    return
                }

                if resource.type == "image" {
                    downloadPreview()
                } else {
                    downloadRaw()
                }
            }
        }.resume()
    }

    func downloadPreview() {
        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let previewURL = URL(string: "\(serverURL)/api/preview/big/\(encodedPath)?auth=\(token)") else {
            self.error = "Invalid preview URL"
            return
        }

        URLSession.shared.dataTask(with: previewURL) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Preview error: \(error.localizedDescription)"
                    return
                }
                self.content = data
            }
        }.resume()
    }

    func downloadRaw() {
        guard let rawURL = URL(string: "\(serverURL)/api/raw/\(file.path)") else {
            self.error = "Invalid raw URL"
            return
        }

        var request = URLRequest(url: rawURL)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Download error: \(error.localizedDescription)"
                    return
                }
                self.content = data
            }
        }.resume()
    }
}
