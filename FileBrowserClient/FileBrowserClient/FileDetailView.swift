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
    @State private var error: String?
    @State private var metadata: ResourceMetadata?
    @State private var showInfo = false
    @State private var isRenaming = false
    @State private var newName = ""
    @State private var showingDeleteConfirm = false
    @State private var statusMessage: StatusPayload?
    @State private var isDownloading = false
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

        } else if let error = self.error {
            Text("Error: \(error)").foregroundColor(.red)

        } else if extensionTypes.mediaExtensions.contains(where: fileName.hasSuffix) {
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
                                        Text("Sharable Links")
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
            .modifier(StatusMessage(payload: $statusMessage))
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

    func checkContentAndReload(fileName: String) {
        self.content = nil
        self.error = nil
        if cacheExtensions.contains(where: fileName.hasSuffix),
           let cached = FileCache.shared.retrieve(
            for: serverURL, path: file.path, modified: file.modified, fileID: file.extension
           ) {
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
            // downloadRaw will call saveFile(showSave: true) once done
            downloadRaw(showSave: true)
        } else {
            // content already present; request direct save
            saveFile(showSave: true)
        }
    }

    // MARK: - Unified save (shows share sheet OR saves directly if showSave true)
    func saveFile(showSave: Bool = false) {
        guard let content = self.content else { return }

        // write temp file off the main thread to avoid blocking UI for big files
        DispatchQueue.global(qos: .userInitiated).async {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(file.name)

            do {
                try content.write(to: tempURL, options: .atomic)

                // Determine type using UTType (TODO: may be just use ExtensionTypes?)
                let ext = tempURL.pathExtension
                let utType = UTType(filenameExtension: ext) ?? UTType.data

                // If caller specifically requested direct save -> try Photos API for image/video
                if showSave {
                    if utType.conforms(to: .image) || utType.identifier == "com.compuserve.gif" || utType.conforms(to: .movie) {
                        // save images (including GIF path)
                        saveDirectToPhotos(tempURL)
                        return
                    }
                }

                // Otherwise present share sheet (or fallback)
                DispatchQueue.main.async {
                    presentActivityController(with: tempURL)
                }

            } catch {
                DispatchQueue.main.async {
                    self.isDownloading = false
                    self.error = "Failed to write temp file: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: - Direct save to Photos (handles images and videos). Uses modern API when available.
    func saveDirectToPhotos(_ fileURL: URL) {
        // Request add-only authorization when available (iOS 14+), fallback otherwise
        let handler: (PHAuthorizationStatus) -> Void = { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    self.isDownloading = false
                    self.error = "Photos access not granted"
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let ext = fileURL.pathExtension.lowercased()
                if ["mp4", "mov", "m4v"].contains(ext) {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                } else {
                    // For images (and GIFs) create asset from file URL — this retains GIF data
                    if #available(iOS 9.0, *) {
                        let req = PHAssetCreationRequest.forAsset()
                        let options = PHAssetResourceCreationOptions()
                        // let the system detect the mime/uti from fileURL
                        req.addResource(with: .photo, fileURL: fileURL, options: options)
                    } else {
                        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                    }
                }
            }) { success, err in
                DispatchQueue.main.async {
                    self.isDownloading = false
                    if success {
                        statusMessage = StatusPayload(
                            text: "📥 Saved to Photos: \(file.name)",
                            color: .green,
                            duration: 2
                        )
                    } else {
                        self.error = "Save failed: \(err?.localizedDescription ?? "unknown")"
                    }
                    // cleanup temp file
                    try? FileManager.default.removeItem(at: fileURL)
                }
            }
        }

        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                handler(status)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                handler(status)
            }
        }
    }

    // MARK: - Present Activity Controller with proper completion and cleanup
    func presentActivityController(with fileURL: URL) {
        // Choose appropriate activity items so "Save to Photos" appears where possible
        var activityItems: [Any] = [fileURL]

        if let ut = UTType(filenameExtension: fileURL.pathExtension), ut.conforms(to: .image) {
            if let image = UIImage(data: (try? Data(contentsOf: fileURL)) ?? Data()) {
                activityItems = [image]
            } else {
                activityItems = [fileURL]
            }
        } else if let ut = UTType(filenameExtension: fileURL.pathExtension), ut.conforms(to: .movie) {
            activityItems = [fileURL]
        } else if fileURL.pathExtension.lowercased() == "gif" {
            // pass URL for GIFs so Share Sheet can often present Save option (and animation preserved)
            activityItems = [fileURL]
        }

        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // iPad popover safe setup
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            activityVC.completionWithItemsHandler = { _, completed, _, error in
                // Remove temp file regardless
                try? FileManager.default.removeItem(at: fileURL)
                if completed {
                    statusMessage = StatusPayload(
                        text: "📤 Shared/Saved: \(file.name)",
                        color: .green,
                        duration: 2
                    )
                } else if let err = error {
                    self.error = err.localizedDescription
                }
                self.isDownloading = false
            }

            // popover anchor on iPad
            if let pop = activityVC.popoverPresentationController {
                pop.sourceView = rootVC.view
                pop.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 1, height: 1)
                pop.permittedArrowDirections = []
            }
            rootVC.present(activityVC, animated: true, completion: nil)
        } else {
            // fallback: present on main window root VC if available
            DispatchQueue.main.async {
                if let root = UIApplication.shared.windows.first?.rootViewController {
                    root.present(activityVC, animated: true, completion: nil)
                } else {
                    // final fallback: show error
                    self.error = "Unable to present share sheet"
                    try? FileManager.default.removeItem(at: fileURL)
                    self.isDownloading = false
                }
            }
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
        let fileName = file.name.lowercased()
        if cacheExtensions.contains(where: fileName.hasSuffix),
           let cached = FileCache.shared.retrieve(
            for: serverURL, path: file.path, modified: file.modified, fileID: file.extension
        ) {
            self.content = cached
            return
        }

        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "preview", "big", file.path],
            queryItems: [
                URLQueryItem(name: "auth", value: token)
            ]
        ) else {
            self.error = "Invalid preview URL"
            return
        }

        Log.debug("🔗 Fetching preview from: \(urlPath(url))")

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = "Preview download failed: \(error.localizedDescription)"
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

    func fetchMetadata() {
        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "resources", file.path],
            queryItems: [
                URLQueryItem(name: "view", value: "info")
            ]
        ) else {
            self.error = "Invalid metadata URL"
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error.localizedDescription
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
                    self.error = error.localizedDescription
                    Log.error("❌ Metadata decode error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func downloadRaw(showSave: Bool = false) {
        // Try to load raw file from cache
        let fileName = file.name.lowercased()
        if cacheExtensions.contains(where: fileName.hasSuffix),
           let cached = FileCache.shared.retrieve(
            for: serverURL, path: file.path, modified: file.modified, fileID: file.extension
        ) {
            self.content = cached
            if showSave {
                self.saveFile()
            }
            return
        }

        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "raw", file.path],
            queryItems: [
                URLQueryItem(name: "auth", value: token)
            ]
        ) else {
            self.error = "Invalid raw URL"
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
                    self.error = error.localizedDescription
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

                if showSave {
                    self.saveFile()
                }
            }
        }.resume()
    }
}
