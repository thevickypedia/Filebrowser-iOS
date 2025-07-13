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
    @Environment(\.dismiss) private var dismiss

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
                let videoExtensions: [String] = [
                    ".mp4", ".mov", ".avi", ".webm", ".mkv"
                ]
                let audioExtensions: [String] = [
                    ".mp3", ".wav", ".aac", ".ogg"
                ]
                if audioExtensions.contains(where: fileName.hasSuffix) {
                    NavigationLink(
                        destination: MediaPlayerView(file: file, serverURL: serverURL, token: token)
                    ) {
                        HStack {
                            Image(systemName: "music.note")
                            Text(file.name)
                        }
                    }
                } else if videoExtensions.contains(where: fileName.hasSuffix) {
                    NavigationLink(
                        destination: MediaPlayerView(file: file, serverURL: serverURL, token: token)
                    ) {
                        HStack {
                            Image(systemName: "play.rectangle")
                            Text(file.name)
                        }
                    }
                } else if imageExtensions.contains(where: fileName.hasSuffix) {
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
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { showInfo = true }) {
                    Image(systemName: "info.circle")
                }
                Button(action: { isRenaming = true; newName = metadata?.name ?? file.name }) {
                    Image(systemName: "pencil")
                }
                Button(action: { showingDeleteConfirm = true }) {
                    Image(systemName: "trash")
                }
            }
        }
        .alert("Rename File", isPresented: $isRenaming, actions: {
            TextField("New name", text: $newName)
            Button("Rename", action: renameFile)
            Button("Cancel", role: .cancel) { }
        })

        .alert("Delete File?", isPresented: $showingDeleteConfirm) {
            Button("Delete", role: .destructive, action: deleteFile)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete \(file.name)?")
        }

        .sheet(isPresented: $showInfo) {
            VStack(alignment: .leading, spacing: 12) {
                Text("📄 Name: \(metadata?.name ?? "-")")
                Text("📁 Path: \(metadata?.path ?? "-")")
                Text("🕒 Modified: \(metadata?.modified ?? "-")")
                Text("📦 Size: \(metadata?.size ?? 0) bytes")
                if let res = metadata?.resolution {
                    Text("📐 Resolution: \(res.width)x\(res.height)")
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            downloadFile()
        }
    }

    func renameFile() {
        let fromPath = file.path
        let toPath = URL(fileURLWithPath: file.path).deletingLastPathComponent().appendingPathComponent(newName).path

        guard let encodedFrom = fromPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let encodedTo = toPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            error = "Failed to encode rename paths"
            return
        }

        let urlString = "\(serverURL)/api/resources\(encodedFrom.hasPrefix("/") ? "" : "/")\(encodedFrom)?action=rename&destination=\(encodedTo)&override=false&rename=false"

        guard let url = URL(string: urlString) else {
            error = "Invalid rename URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"  // ✅ Required by server
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Rename failed: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.error = "No response"
                    return
                }

                if httpResponse.statusCode == 200 {
                    // Optional: Dismiss or reload
                    print("✅ Rename successful")
                    dismiss() // ✅ Auto-go back to list
                } else {
                    self.error = "Rename failed: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }

    func deleteFile() {
        guard let serverURL = URL(string: "\(serverURL)/api/resources/\(file.path)") else { return }

        var request = URLRequest(url: serverURL)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                dismiss()
            }
        }.resume()
    }

    func saveFile() {
        guard let content = content else { return }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(file.name)
        try? content.write(to: tempURL)

        // Present share sheet
        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
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
