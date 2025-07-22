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
    @State private var isDownloading = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthManager

    var body: some View {
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
        let mediaExtensions = videoExtensions + audioExtensions
        let previewExtensions = textExtensions + imageExtensions + [".pdf"]
        Group {
            if isDownloading {
                VStack {
                    ProgressView("Downloading...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.2))
            } else if let error = error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else if mediaExtensions.contains(where: fileName.hasSuffix) {
                MediaPlayerView(file: file, serverURL: serverURL, token: token)
            } else if let content = content {
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
                if previewExtensions.contains(where: fileName.hasSuffix) {
                    ProgressView("Loading file...")
                } else {
                    Text("File preview not supported for this type.")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle(file.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { showInfo = true }) {
                    Image(systemName: "info.circle")
                }
                var hasAnyActionPermission: Bool {
                    let p = auth.permissions
                    return p?.rename == true || p?.delete == true || p?.download == true || p?.share == true || p?.create == true
                }
                // Actions menu (only if any permission is true)
                if hasAnyActionPermission {
                    Menu {
                        if auth.permissions?.rename == true {
                            Button("Rename", systemImage: "pencil", action: {
                                newName = metadata?.name ?? file.name
                                isRenaming = true
                            })
                        }

                        if auth.permissions?.delete == true {
                            Button("Delete", systemImage: "trash", role: .destructive, action: {
                                showingDeleteConfirm = true
                            })
                        }

                        if auth.permissions?.download == true {
                            Button("Download", systemImage: "arrow.down.circle", action: {
                                downloadAndSave()
                            })
                        }

                        if auth.permissions?.share == true {
                            Button("Share", systemImage: "square.and.arrow.up", action: {
                                downloadAndSave()
                            })
                        }

                        if auth.permissions?.create == true {
                            Button("Create File", systemImage: "doc.badge.plus", action: {
                                // reminder: Implement file creation
                                // todo: File creation option should be in FileListView
                                Log.info("Create tapped")
                            })
                        }
                    } label: {
                        Label("Actions", systemImage: "person.circle")
                            .padding()
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(8)
                    }
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
                // Text("📄 Name: \(metadata?.name ?? file.name)")
                // Text("📁 Path: \(metadata?.path ?? file.path)")
                // Text("🕒 Modified: \(metadata?.modified ?? file.modified ?? "Unknown")")
                // Text("📦 Size: \((metadata?.size ?? file.size).map { "\($0) bytes" } ?? "Unknown")")
                HStack {
                    Image(systemName: "doc.text")
                        .imageScale(.medium)
                    Text("Name: \(metadata?.name ?? file.name)")
                    // Text(metadata?.name ?? file.name)
                }

                HStack {
                    Image(systemName: "folder")
                        .imageScale(.medium)
                    Text("Path: \(metadata?.path ?? file.path)")
                    // Text(metadata?.path ?? file.path)
                }
                HStack {
                    Image(systemName: "clock")
                    let modified = metadata?.modified ?? file.modified
                    let diff = calculateTimeDifference(dateString: modified)
                    Text("Modified: \(timeAgoString(from: diff))")
                    // Text(metadata?.modified ?? file.modified ?? "Unknown")
                }
                HStack {
                    Image(systemName: "shippingbox")
                    Text("Size: \((metadata?.size ?? file.size).map { "\($0) bytes" } ?? "Unknown")")
                    // Text((metadata?.size ?? file.size).map { "\($0) bytes" } ?? "Unknown")
                }
                if let res = metadata?.resolution {
                    // Text("📐 Resolution: \(res.width)x\(res.height)")
                    HStack {
                        Image(systemName: "ruler")
                            .imageScale(.medium)
                        Text("Resolution: \(res.width)x\(res.height)")
                        // Text("\(res.width)x\(res.height)")
                    }
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            if !mediaExtensions.contains(where: fileName.hasSuffix)
                && (previewExtensions.contains(where: fileName.hasSuffix)) {
                // ✅ Only load if preview is supported
                downloadFile(
                    fileName: fileName,
                    imageExtensions: imageExtensions,
                    textExtensions: textExtensions
                )
            } else {
                Log.info("🚫 Skipping auto-download — no preview for this type")
            }
        }
    }

    func timeAgoString(from diff: [String: Double]) -> String {
        let seconds = Int(diff["seconds"] ?? 0)
        let minutes = Int(diff["minutes"] ?? 0)
        let hours = Int(diff["hours"] ?? 0)
        let days = Int(diff["days"] ?? 0)
        let weeks = Int(diff["weeks"] ?? 0)
        //let months = Int(diff["months"] ?? 0)
        //let years = Int(diff["years"] ?? 0)

        switch true {
        //case years >= 1:
        //    return "\(years) year\(years == 1 ? "" : "s") ago"
        //case months >= 1:
        //    return "\(months) month\(months == 1 ? "" : "s") ago"
        case weeks >= 1:
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        case days >= 1:
            return "\(days) day\(days == 1 ? "" : "s") ago"
        case hours >= 1:
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        case minutes >= 1:
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        case seconds >= 10:
            return "\(seconds) seconds ago"
        case seconds >= 1:
            return "Just now"
        default:
            return "Unknown"
        }
    }

    func calculateTimeDifference(dateString: String?) -> [String: Double] {
        let defaultResult: [String: Double] = [
            "seconds": 0.0,
            "minutes": 0.0,
            "hours": 0.0,
            "days": 0.0,
            "weeks": 0.0,
            "months": 0.0,
            "years": 0.0
        ]

        guard let dateString = dateString else {
            Log.warn("Input dateString is nil.")
            return defaultResult
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Update if your date format is different
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: dateString) else {
            Log.error("Invalid date format: \(dateString)")
            return defaultResult
        }

        let now = Date()
        let timeInterval = abs(now.timeIntervalSince(date)) // in seconds

        return [
            "seconds": timeInterval,
            "minutes": timeInterval / 60,
            "hours": timeInterval / 3600,
            "days": timeInterval / (24 * 3600),
            "weeks": timeInterval / (7 * 24 * 3600),
            "months": timeInterval / (30 * 24 * 3600), // Approximate
            "years": timeInterval / (365 * 24 * 3600) // Approximate
        ]
    }

    func makeEncodedURL(base: String, path: String, query: String? = nil) -> URL? {
        guard !base.isEmpty, !path.isEmpty else { return nil }

        let trimmedBase = base.hasSuffix("/") ? String(base.dropLast()) : base
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? path
        let urlString = "\(trimmedBase)/\(encodedPath)" + (query.map { "?\($0)" } ?? "")
        return URL(string: urlString)
    }

    func renameFile() {
        let fromPath = file.path
        let toPath = URL(fileURLWithPath: file.path).deletingLastPathComponent().appendingPathComponent(newName).path

        guard let encodedFrom = fromPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let encodedTo = toPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {

        // guard let encodedTo = toPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {

            error = "Failed to encode rename paths"
            return
        }

        let urlString = "\(serverURL)/api/resources\(encodedFrom.hasPrefix("/") ? "" : "/")\(encodedFrom)?action=rename&destination=\(encodedTo)&override=false&rename=false"
        guard let url = URL(string: urlString) else {

        // guard let url = makeEncodedURL(
        //    base: serverURL,
        //    path: fromPath,
        //    query: "action=rename&destination=\(encodedTo)&override=false&rename=false"
        // ) else {

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
                    Log.info("✅ Rename successful")
                    dismiss() // ✅ Auto-go back to list
                } else {
                    self.error = "Rename failed: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }

    func deleteFile() {
        guard let url = makeEncodedURL(base: serverURL, path: "api/resources/\(file.path)") else { return }
        // guard let serverURL = URL(string: "\(serverURL)/api/resources/\(file.path)") else { return }
        // var request = URLRequest(url: serverURL)

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                dismiss()
            }
        }.resume()
    }

    func downloadAndSave() {
        if content?.isEmpty ?? true {
            Log.info("Content wasn't downloaded already, downloading now...")
            isDownloading = true
            downloadRaw(showSave: true)
        } else {
            saveFile()
        }
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

    func downloadFile(fileName: String, imageExtensions: [String], textExtensions: [String]) {
        if imageExtensions.contains(where: fileName.hasSuffix) {
            Log.debug("🖼️ Detected image file. Using preview API")
            downloadPreview()
        } else if textExtensions.contains(where: fileName.hasSuffix) {
            Log.debug("📄 Detected text file. Using raw API")
            downloadRaw()
        } else if fileName.hasSuffix(".pdf") {
            Log.debug("📄 Detected PDF file. Using raw API")
            downloadRaw()
        } else {
            Log.debug("📥 Defaulting to raw download for: \(fileName)")
            downloadRaw()
        }
    }

    func downloadPreview() {
        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            self.error = "Failed to encode path for preview"
            return
        }

        let urlString = "\(serverURL)/api/preview/big/\(encodedPath)?auth=\(token)"
        guard let url = URL(string: urlString) else {
            self.error = "Invalid preview URL"
            return
        }

        Log.debug("🔗 Fetching preview from: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Preview download failed: \(error.localizedDescription)"
                    return
                }
                Log.debug("Fetch preview complete")
                self.content = data
            }
        }.resume()
    }

    func downloadRaw(showSave: Bool = false) {
        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            self.error = "Failed to encode path for raw download"
            isDownloading = false
            return
        }

        let urlString = "\(serverURL)/api/raw/\(encodedPath)?auth=\(token)"
        guard let url = URL(string: urlString) else {
            self.error = "Invalid raw URL"
            isDownloading = false
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        Log.debug("🔗 Fetching raw content from: \(url.absoluteString)")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isDownloading = false
                if let error = error {
                    self.error = "Raw download failed: \(error.localizedDescription)"
                    return
                }
                Log.debug("Fetch raw content complete")
                self.content = data
                if showSave {
                    self.saveFile()
                }
            }
        }.resume()
    }
}
