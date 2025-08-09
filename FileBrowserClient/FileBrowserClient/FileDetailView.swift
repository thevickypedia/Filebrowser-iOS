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
    let fileExtension: String?
    let resolution: Resolution?

    enum CodingKeys: String, CodingKey {
        case name, path, size, modified, type
        case fileExtension = "extension"
        case resolution
    }
}

struct Resolution: Codable {
    let width: Int
    let height: Int
}

enum SwipeDirection {
    case left, right
}

struct FileDetailView: View {
    @State var currentIndex: Int
    @GestureState private var dragOffset: CGFloat = 0
    @Namespace private var animation

    @State private var swipeDirection: SwipeDirection = .left

    let files: [FileItem]
    let serverURL: String
    let token: String

    var file: FileItem { files[currentIndex] }

    // Use a closure callback to pass as argument in FileListView
    let onFileCached: (() -> Void)?

    let extensionTypes: ExtensionTypes
    let cacheExtensions: [String]
    let animateGIF: Bool

    @State private var content: Data?
    @State private var error: String?
    @State private var metadata: ResourceMetadata?
    @State private var showInfo = false
    @State private var isRenaming = false
    @State private var newName = ""
    @State private var showingDeleteConfirm = false
    @State private var downloadMessage: String?
    @State private var isDownloading = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthManager

    @ViewBuilder
    private var fileContentView: some View {
        let fileName = file.name.lowercased()

        if isDownloading {
            VStack {
                ProgressView("Downloading...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.2))

        } else if let error = self.error {
            Text("Error: \(error)").foregroundColor(.red)

        } else if extensionTypes.mediaExtensions.contains(where: fileName.hasSuffix) {
            MediaPlayerView(file: file, serverURL: serverURL, token: token)

        } else if let content = self.content {
            if extensionTypes.imageExtensions.contains(where: fileName.hasSuffix) {
                if animateGIF && fileName.hasSuffix(".gif") {
                    AnimatedImageView(data: content)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let image = UIImage(data: content) {
                    ZoomableImageView(
                        image: image,
                        onSwipeLeft: {
                            swipeDirection = .left
                            withAnimation(.easeInOut(duration: 0.25)) {
                                if currentIndex < files.count - 1 && !files[currentIndex + 1].isDir {
                                    currentIndex += 1
                                }
                            }
                        },
                        onSwipeRight: {
                            swipeDirection = .right
                            withAnimation(.easeInOut(duration: 0.25)) {
                                if currentIndex > 0 && !files[currentIndex - 1].isDir {
                                    currentIndex -= 1
                                }
                            }
                        }
                    )
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: swipeDirection == .left ? .trailing : .leading),
                            removal: .move(edge: swipeDirection == .left ? .leading : .trailing)
                        )
                    )
                    .id(currentIndex) // force re-render for transition to work
                } else {
                    Text("Failed to load image")
                }

            } else if extensionTypes.textExtensions.contains(where: fileName.hasSuffix) {
                if let text = String(data: content, encoding: .utf8) {
                    ScrollView {
                        CopyableTextContainer(text: text)
                    }
                } else {
                    Text("Failed to decode text")
                }

            } else if fileName.hasSuffix(".pdf") {
                PDFKitView(data: content)
            } else {
                Text("File preview not supported for this type.").foregroundColor(.gray)
            }

        } else {
            if extensionTypes.previewExtensions.contains(where: fileName.hasSuffix) {
                ProgressView("Loading file...")
            } else {
                Text("File preview not supported for this type.").foregroundColor(.gray)
            }
        }
    }

    var body: some View {
        let fileName = file.name.lowercased()

        fileContentView
            .id(file.path)
            .offset(x: dragOffset) // <-- Drag follows finger
            // .animation(.interactiveSpring(), value: dragOffset == 0)
            .animation(.interactiveSpring(), value: dragOffset)
            // .animation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.25), value: dragOffset)
            .navigationTitle(file.name)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showInfo = true }) {
                        Image(systemName: "info.circle")
                    }

                    var hasAnyActionPermission: Bool {
                        let permissions = auth.permissions
                        return permissions?.rename == true || permissions?.delete == true || permissions?.download == true || permissions?.share == true
                    }

                    if hasAnyActionPermission {
                        Menu {
                            if auth.permissions?.rename == true {
                                Button("Rename", systemImage: "pencil", action: {
                                    newName = metadata?.name ?? file.name
                                    isRenaming = true
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

                            if auth.permissions?.delete == true {
                                Button("Delete", systemImage: "trash", role: .destructive, action: {
                                    showingDeleteConfirm = true
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
                let fileInfo = getFileInfo(metadata: metadata, file: file, auth: auth)
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "doc.text")
                            .imageScale(.medium)
                        SelectableTextView(text: "Name: \(fileInfo.name)")
                    }
                    HStack {
                        Image(systemName: "folder")
                            .imageScale(.medium)
                        SelectableTextView(text: "Path: \(fileInfo.path)")
                    }
                    HStack {
                        Image(systemName: "clock")
                        SelectableTextView(text: "Modified: \(fileInfo.modified)")
                    }
                    HStack {
                        Image(systemName: "shippingbox")
                        SelectableTextView(text: "Size: \(fileInfo.size)")
                    }
                    HStack {
                        Image(systemName: "shippingbox")
                        SelectableTextView(text: "Extension: \(fileInfo.extension)")
                    }
                    if let res = metadata?.resolution {
                        HStack {
                            Image(systemName: "ruler")
                                .imageScale(.medium)
                            SelectableTextView(text: "Resolution: \(res.width)x\(res.height)")
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .task(id: currentIndex) {
                checkContentAndReload(fileName: fileName)
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 100
                        withAnimation(.interactiveSpring()) {
                            if value.translation.width < -threshold && !files[currentIndex + 1].isDir {
                                goToNext()
                            } else if value.translation.width > threshold && !files[currentIndex - 1].isDir {
                                goToPrevious()
                            }
                        }
                    }
            )
    }

    func checkContentAndReload(fileName: String) {
        self.content = nil
        self.error = nil
        if cacheExtensions.contains(where: fileName.hasSuffix),
           let cached = FileCache.shared.data(for: file.path, modified: file.modified, fileID: file.extension) {
            self.content = cached
        } else {
            reloadFile(
                fileName: fileName,
                extensionTypes: extensionTypes
            )
        }
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
        self.content = nil
        self.error = nil
        if extensionTypes.previewExtensions.contains(where: fileName.hasSuffix) {
            // ✅ Only load if preview is supported
            downloadFile(
                fileName: fileName,
                extensionTypes: extensionTypes
            )
        } else if !extensionTypes.mediaExtensions.contains(where: fileName.hasSuffix) {
            Log.info("🚫 Skipping auto-download — no preview available for \(fileName)")
        }
        fetchMetadata()
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
            self.error = "Failed to encode rename paths"
            return
        }

        let urlString = "\(serverURL)/api/resources/\(removePrefix(urlPath: encodedFrom))?action=rename&destination=/\(removePrefix(urlPath: encodedTo))&override=false&rename=false"
        guard let url = URL(string: urlString) else {
            self.error = "Invalid rename URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"  // ✅ Required by server
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
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
        guard let content = self.content else { return }

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
        // Try to load preview from cache
        if let cached = FileCache.shared.data(for: file.path, modified: file.modified, fileID: file.extension) {
            self.content = cached
            return
        }

        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            self.error = "Failed to encode path for preview"
            return
        }

        let urlString = "\(serverURL)/api/preview/big/\(removePrefix(urlPath: encodedPath))?auth=\(token)"
        guard let url = URL(string: urlString) else {
            self.error = "Invalid preview URL"
            return
        }

        Log.debug("🔗 Fetching preview from: \(url.relativePath)")

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Preview download failed: \(error.localizedDescription)"
                    return
                }
                Log.debug("Fetch preview complete")
                self.content = data
                // Store cache-able extensions in FileCache
                if cacheExtensions.contains(where: file.name.lowercased().hasSuffix),
                   let data = data {
                    FileCache.shared.store(data: data, for: file.path, modified: file.modified, fileID: file.extension)
                    // Use callback trigger a refresh, since cached previews may change size after large uploads and deletions
                    // Alternate: Trigger a refresh in onDisappear of FileDetailView, but that’s less immediate and less precise
                    onFileCached?()
                }
            }
        }.resume()
    }

    func fetchMetadata() {
        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            self.error = "Failed to encode path for metadata"
            return
        }

        let urlString = "\(serverURL)/api/resources/\(removePrefix(urlPath: encodedPath))?view=info"
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
                    Log.debug("✅ Metadata loaded for \(file.name)")
                } catch {
                    self.error = "Failed to parse metadata"
                    Log.error("❌ Metadata decode error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func downloadRaw(showSave: Bool = false) {
        // Try to load raw file from cache
        if let cached = FileCache.shared.data(for: file.path, modified: file.modified, fileID: file.extension) {
            self.content = cached
            if showSave {
                self.saveFile()
            }
            return
        }

        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            self.error = "Failed to encode path for raw download"
            isDownloading = false
            return
        }

        let urlString = "\(serverURL)/api/raw/\(removePrefix(urlPath: encodedPath))?auth=\(token)"
        guard let url = URL(string: urlString) else {
            self.error = "Invalid raw URL"
            isDownloading = false
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        Log.debug("🔗 Fetching raw content from: \(url.relativePath)")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isDownloading = false
                if let error = error {
                    self.error = "Raw download failed: \(error.localizedDescription)"
                    return
                }
                Log.debug("Fetch raw content complete")
                self.content = data

                // Store cache-able extensions in FileCache
                if cacheExtensions.contains(where: file.name.lowercased().hasSuffix),
                   let data = data {
                    FileCache.shared.store(data: data, for: file.path, modified: file.modified, fileID: file.extension)
                    // Use callback trigger a refresh, since cached previews may change size after large uploads and deletions
                    // Alternate: Trigger a refresh in onDisappear of FileDetailView, but that’s less immediate and less precise
                    onFileCached?()
                }

                if showSave {
                    self.saveFile()
                }
            }
        }.resume()
    }
}
