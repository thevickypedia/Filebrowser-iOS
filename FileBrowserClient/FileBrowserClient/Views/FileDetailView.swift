//
//  FileDetailView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/7/25.
//

import SwiftUI
import Photos
import UniformTypeIdentifiers
import MobileCoreServices

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
    @State private var metadata: ResourceMetadata?
    @State private var showInfo = false
    @State private var isRenaming = false
    @State private var newName = ""
    @State private var showingDeleteConfirm = false
    @State private var previewError: PreviewErrorPayload?
    @State private var toastMessage: ToastMessagePayload?
    @State private var isDownloading = false
    @State private var downloadedFileURL: URL?
    @State private var showShareSheet = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthManager

    @State private var isFullScreen = false
    @State private var isSharing = false
    // Display as alerts
    @State private var errorTitle: String?
    @State private var errorMessage: String?

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

        } else if let errorPayload = self.previewError {
            VStack(spacing: 8) {
                Text("Unable to load file")
                    .foregroundColor(.red)
                Text(errorPayload.text)
                    .font(.caption)
                    .foregroundColor(errorPayload.color)
                Button("Retry") {
                    reloadFilePreview(fileName: fileName)
                }
            }

        // MARK: Check if either of the share sheet is presented to avoid overlap
        } else if extensionTypes.mediaExtensions.contains(where: fileName.hasSuffix) && !(showShareSheet || isSharing) {
            MediaPlayerView(
                file: file,
                serverURL: serverURL,
                username: auth.username,
                token: token,
                displayFullScreen: extensionTypes.videoExtensions.contains(where: fileName.hasSuffix)
            )

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
                        },
                        isFullScreen: $isFullScreen
                    )
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: swipeDirection == .left ? .trailing : .leading),
                            removal: .move(edge: swipeDirection == .left ? .leading : .trailing)
                        )
                    )
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(isFullScreen) // <-- hide nav bar when full-screen
                    .statusBar(hidden: isFullScreen)   // <-- optional: hide status bar
                    .ignoresSafeArea(edges: isFullScreen ? .all : []) // optional full area
                    .background(Color.black) // optional for aesthetic fullscreen look
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
                PDFViewerScreen(content: content)
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

    var userPermissions: UserPermission? {
        return auth.tokenPayload?.user.perm
    }

    var hasAnyActionPermission: Bool {
        let permissions = userPermissions
        return permissions?.rename == true || permissions?.delete == true || permissions?.download == true || permissions?.share == true
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

                    if hasAnyActionPermission {
                        Menu {
                            if userPermissions?.rename == true {
                                Button("Rename", systemImage: "pencil", action: {
                                    newName = metadata?.name ?? file.name
                                    isRenaming = true
                                })
                            }

                            if userPermissions?.download == true {
                                Button("Download", systemImage: "arrow.down.circle", action: {
                                    downloadAndSave()
                                })
                            }

                            if userPermissions?.share == true {
                                Button(action: {
                                    isSharing = true
                                }) {
                                    HStack {
                                        Image("material_share_icon")
                                            .renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.blue)
                                        Text("Share")
                                    }
                                }
                            }

                            if userPermissions?.delete == true {
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
            .modifier(ErrorAlert(title: $errorTitle, message: $errorMessage))
            .modifier(ToastMessage(payload: $toastMessage))
            // File save/export sheet
            .sheet(isPresented: $showShareSheet) {
                guard let fileURL = downloadedFileURL else {
                    Log.error("Showing share sheet, but no download URL found.")
                    self.errorTitle = "Resource conflict"
                    self.errorMessage = "Showing share sheet, but no download URL found."
                    return AnyView(EmptyView())
                }
                return AnyView(
                    FileExporter(fileURL: fileURL) { success in
                        if success {
                            let msg = "✔️ Export [\(fileURL.lastPathComponent)] successful"
                            Log.debug(msg)
                            toastMessage = ToastMessagePayload(text: msg)
                        } else {
                            let msg = "✖️ Export [\(fileURL.lastPathComponent)] cancelled"
                            Log.debug(msg)
                            toastMessage = ToastMessagePayload(text: msg, color: .yellow)
                        }
                    }
                )
            }
            // Create sharable link
            .sheet(isPresented: $isSharing) {
                ShareSheetView(
                    serverURL: serverURL,
                    token: token,
                    file: file,
                    onDismiss: { isSharing = false }
                )
            }
            .sheet(isPresented: $showInfo) {
                let fileInfo = getFileInfo(metadata: metadata, file: file, auth: auth)
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "doc.text")
                                .imageScale(.medium)
                                .foregroundColor(.secondary)
                            SelectableTextView(text: "Name: \(fileInfo.name)")
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer(minLength: 0)
                        }

                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "folder")
                                .imageScale(.medium)
                                .foregroundColor(.secondary)
                            SelectableTextView(text: "Path: \(fileInfo.path)")
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer(minLength: 0)
                        }

                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "clock")
                                .imageScale(.medium)
                                .foregroundColor(.secondary)
                            SelectableTextView(text: "Modified: \(fileInfo.modified)")
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer(minLength: 0)
                        }

                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "shippingbox")
                                .imageScale(.medium)
                                .foregroundColor(.secondary)
                            SelectableTextView(text: "Size: \(fileInfo.size)")
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer(minLength: 0)
                        }

                        if !fileInfo.extension.isEmpty {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "shippingbox")
                                    .imageScale(.medium)
                                    .foregroundColor(.secondary)
                                SelectableTextView(text: "Type: \(fileInfo.extension)")
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer(minLength: 0)
                            }
                        }

                        if let res = metadata?.resolution {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "ruler")
                                    .imageScale(.medium)
                                    .foregroundColor(.secondary)
                                SelectableTextView(text: "Resolution: \(res.width)x\(res.height)")
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer(minLength: 0)
                            }
                        }

                        Spacer()
                    }
                    .padding()
                }
            }
            .task(id: currentIndex) {
                reloadFilePreview(fileName: fileName)
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 100
                        withAnimation(.interactiveSpring()) {
                            if value.translation.width < -threshold {
                                let nextIndex = currentIndex + 1
                                if nextIndex < files.count && !files[nextIndex].isDir {
                                    goToNext()
                                }
                            } else if value.translation.width > threshold {
                                let previousIndex = currentIndex - 1
                                if previousIndex >= 0 && !files[previousIndex].isDir {
                                    goToPrevious()
                                }
                            }
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

    func reloadFilePreview(
        fileName: String
    ) {
        self.content = nil
        self.previewError = nil
        if cacheExtensions.contains(where: fileName.hasSuffix),
           let cached = FileCache.shared.retrieve(
            for: serverURL, path: file.path, modified: file.modified, fileID: file.extension
           ) {
            self.content = cached
            // If cached data, return it without fetching metadata
            return
        }

        // Reset metadata if not cached
        self.metadata = nil
        fetchMetadata()

        if extensionTypes.previewExtensions.contains(where: fileName.hasSuffix) {
            if let warning = unsafeFileSize(byteSize: file.size ?? metadata?.size) {
                self.previewError = PreviewErrorPayload(text: warning)
                return
            }
            // Only load if preview is supported
            downloadFilePreview(fileName: fileName)
        } else if !extensionTypes.mediaExtensions.contains(where: fileName.hasSuffix) {
            Log.info("🚫 Skipping auto-download — no preview available for \(fileName)")
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
        let toPath = URL(fileURLWithPath: file.path)
            .deletingLastPathComponent()
            .appendingPathComponent(newName)
            .path

        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "resources", fromPath],
            queryItems: [
                URLQueryItem(name: "action", value: "rename"),
                URLQueryItem(name: "destination", value: "/" + toPath),
                URLQueryItem(name: "override", value: "false"),
                URLQueryItem(name: "rename", value: "false")
            ]
        ) else {
            self.errorMessage = "Invalid rename URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"  // ✅ Required by server
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Rename failed: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "No response"
                    return
                }

                if httpResponse.statusCode == 200 {
                    // Optional: Dismiss or reload
                    Log.info("✅ Rename successful")
                    dismiss() // ✅ Auto-go back to list
                } else {
                    self.errorMessage = "Rename failed: \(httpResponse.statusCode)"
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
        guard let url = FileDownloadHelper.makeDownloadURL(
            serverURL: serverURL,
            token: token,
            filePath: file.path
        ) else { return }

        isDownloading = true
        DownloadManager.shared.download(from: url, token: token,
            progress: { _, _, _ in },
            completion: { result in
                DispatchQueue.main.async {
                    self.isDownloading = false
                    switch result {
                    case .success(let localURL):
                        self.downloadedFileURL = localURL
                        self.showShareSheet = true
                    case .failure(let error):
                        self.errorMessage = "Download failed: \(error.localizedDescription)"
                    }
                }
            }
        )
    }

    func downloadFilePreview(fileName: String) {
        if extensionTypes.imageExtensions.contains(where: fileName.hasSuffix) {
            Log.debug("🖼️ Detected image file. Using preview API")
            downloadPreview()
        } else if extensionTypes.textExtensions.contains(where: fileName.hasSuffix) {
            Log.debug("📄 Detected text file. Using raw API")
            downloadRaw()
        } else if fileName.hasSuffix(".pdf") {
            Log.debug("📄 Detected PDF file. Using raw API")
            downloadRaw()
        }
    }

    func downloadPreview() {
        // Try to load preview from cache
        let fileName = file.name.lowercased()

        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "preview", "big", file.path],
            queryItems: [
                URLQueryItem(name: "auth", value: token)
            ]
        ) else {
            self.previewError = PreviewErrorPayload(text: "Invalid preview URL")
            return
        }

        Log.debug("🔗 Fetching preview from: \(urlPath(url))")

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.previewError = PreviewErrorPayload(text: "Preview download failed: \(error.localizedDescription)")
                    return
                }
                Log.debug("Fetch preview complete")
                self.content = data
                // Store cache-able extensions in FileCache
                if cacheExtensions.contains(where: fileName.hasSuffix),
                   let data = data {
                    FileCache.shared.store(
                        for: serverURL, data: data, path: file.path, modified: file.modified, fileID: file.extension
                    )
                    // Use callback trigger a refresh, since cached previews may change size after large uploads and deletions
                    // Alternate: Trigger a refresh in onDisappear of FileDetailView, but that’s less immediate and less precise
                    onFileCached?()
                }
            }
        }.resume()
    }

    func downloadRaw() {
        // Try to load raw file from cache
        let fileName = file.name.lowercased()

        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "raw", file.path],
            queryItems: [
                URLQueryItem(name: "auth", value: token)
            ]
        ) else {
            self.previewError = PreviewErrorPayload(text: "Invalid raw URL")
            isDownloading = false
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        Log.debug("🔗 Fetching raw content from: \(urlPath(url))")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isDownloading = false
                if let error = error {
                    self.previewError = PreviewErrorPayload(text: error.localizedDescription)
                    Log.error("❌ Raw download failed: \(error.localizedDescription)")
                    return
                }
                Log.debug("Fetch raw content complete")
                self.content = data

                // Store cache-able extensions in FileCache
                if cacheExtensions.contains(where: fileName.hasSuffix),
                   let data = data {
                    FileCache.shared.store(
                        for: serverURL, data: data, path: file.path, modified: file.modified, fileID: file.extension
                    )
                    // Use callback trigger a refresh, since cached previews may change size after large uploads and deletions
                    // Alternate: Trigger a refresh in onDisappear of FileDetailView, but that’s less immediate and less precise
                    onFileCached?()
                }
            }
        }.resume()
    }

    func fetchMetadata() {
        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "resources", file.path],
            queryItems: [
                URLQueryItem(name: "view", value: "info")
            ]
        ) else {
            self.errorMessage = "Invalid metadata URL"
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No metadata received"
                    return
                }

                do {
                    self.metadata = try JSONDecoder().decode(ResourceMetadata.self, from: data)
                    Log.debug("✅ Metadata loaded for \(file.name)")
                } catch {
                    self.errorMessage = error.localizedDescription
                    Log.error("❌ Metadata decode error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
