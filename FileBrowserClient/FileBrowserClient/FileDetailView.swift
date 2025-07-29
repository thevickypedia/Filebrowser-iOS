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

enum ValidationError: Error {
    case invalidDateFormat
}

struct Resolution: Codable {
    let width: Int
    let height: Int
}

struct FileDetailView: View {
    @State var currentIndex: Int
    let files: [FileItem]
    let serverURL: String
    let token: String

    var file: FileItem { files[currentIndex] }

    let extensionTypes: ExtensionTypes = ExtensionTypes()
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
            } else if extensionTypes.mediaExtensions.contains(where: fileName.hasSuffix) {
                MediaPlayerView(file: file, serverURL: serverURL, token: token)
            } else if let content = content {
                if extensionTypes.imageExtensions.contains(where: fileName.hasSuffix) {
                    if let image = UIImage(data: content) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } else {
                        Text("Failed to load image")
                    }
                } else if extensionTypes.textExtensions.contains(where: fileName.hasSuffix) {
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
                if extensionTypes.previewExtensions.contains(where: fileName.hasSuffix) {
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
                    return p?.rename == true || p?.delete == true || p?.download == true || p?.share == true
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
                    } label: {
                        Label("Actions", systemImage: "person.circle")
                            .padding()
                            .background(Color.blue.opacity(0.1))
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
                HStack {
                    Image(systemName: "doc.text")
                        .imageScale(.medium)
                    Text("Name: \(metadata?.name ?? file.name)")
                }
                HStack {
                    Image(systemName: "folder")
                        .imageScale(.medium)
                    Text("Path: \(metadata?.path ?? file.path)")
                }
                HStack {
                    Image(systemName: "clock")
                    let modified = metadata?.modified ?? file.modified
                    let dateFormatExact = auth.userAccount?.dateFormat ?? false
                    if dateFormatExact {
                        Text("Modified: \(modified ?? "Unknown")")
                    } else {
                        let diff = calculateTimeDifference(dateString: modified)
                        Text("Modified: \(timeAgoString(from: diff))")
                    }
                }
                HStack {
                    Image(systemName: "shippingbox")
                    Text("Size: \(sizeConverter(metadata?.size ?? file.size))")
                }
                if let res = metadata?.resolution {
                    HStack {
                        Image(systemName: "ruler")
                            .imageScale(.medium)
                        Text("Resolution: \(res.width)x\(res.height)")
                    }
                }
                Spacer()
            }
            .padding()
        }
        .onChange(of: currentIndex) { _ in
            reloadFile(
                fileName: fileName,
                extensionTypes: extensionTypes
            )
        }
        .onAppear {
            reloadFile(
                fileName: fileName,
                extensionTypes: extensionTypes
            )
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        goToNext()
                    } else if value.translation.width > 50 {
                        goToPrevious()
                    }
                }
        )
    }

    func goToNext() {
        guard currentIndex < files.count - 1 else { return }
        currentIndex += 1
    }

    func goToPrevious() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    func reloadFile(
        fileName: String,
        extensionTypes: ExtensionTypes
    ) {
        content = nil
        error = nil
        // todo: Implement a hoverable arrow for navigation
        //       Wrap all extensions in a class/struct
        if !extensionTypes.mediaExtensions.contains(where: fileName.hasSuffix)
            && (extensionTypes.previewExtensions.contains(where: fileName.hasSuffix)) {
            // ✅ Only load if preview is supported
            downloadFile(
                fileName: fileName,
                extensionTypes: extensionTypes
            )
        } else {
            Log.info("🚫 Skipping auto-download — no preview available for \(fileName)")
        }
        fetchMetadata()
    }

    func sizeConverter(_ byteSize: Int?) -> String {
        guard let byteSize = byteSize, byteSize >= 0 else {
            return "Unknown"
        }

        let sizeNames = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        var index = 0
        var size = Double(byteSize)

        while size >= 1024.0 && index < sizeNames.count - 1 {
            size /= 1024.0
            index += 1
        }

        return String(format: "%.2f %@", size, sizeNames[index])
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

    func parseDate(from dateString: String, defaultResult: Date? = nil) throws -> Date {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX",  // SSSSSS → 6 digits of fractional seconds
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",         // ISO 8601 with timezone
            "yyyy-MM-dd'T'HH:mm:ssZ",             // ISO 8601 with Z
            "yyyy-MM-dd HH:mm:ss",                // Common DB format
            "yyyy/MM/dd HH:mm:ss",
            "MM/dd/yyyy HH:mm:ss",
            "dd-MM-yyyy HH:mm:ss",
            "yyyy-MM-dd",
            "MM/dd/yyyy",
            "dd-MM-yyyy"
        ]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        guard let date = defaultResult else {
            throw ValidationError.invalidDateFormat
        }
        return date
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

        do {
            let date = try parseDate(from: dateString)
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
        } catch {
            Log.error("Invalid date format: \(dateString)")
            return defaultResult
        }
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

    func downloadFile(fileName: String, extensionTypes: ExtensionTypes) {
        if extensionTypes.imageExtensions.contains(where: fileName.hasSuffix) {
            Log.debug("🖼️ Detected image file. Using preview API")
            downloadPreview()
        } else if extensionTypes.textExtensions.contains(where: fileName.hasSuffix) {
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

    func fetchMetadata() {
        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            self.error = "Failed to encode path for metadata"
            return
        }

        let urlString = "\(serverURL)/api/resources/\(encodedPath)?view=info"
        guard let url = URL(string: urlString) else {
            self.error = "Invalid metadata URL"
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Metadata fetch failed: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.error = "No metadata received"
                    return
                }

                do {
                    self.metadata = try JSONDecoder().decode(ResourceMetadata.self, from: data)
                    Log.info("✅ Metadata loaded for \(file.name)")
                } catch {
                    self.error = "Failed to parse metadata"
                    Log.error("❌ Metadata decode error: \(error.localizedDescription)")
                }
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
