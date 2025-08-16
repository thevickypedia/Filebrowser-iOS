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

    @State private var isSharing = false
    @State private var isShareInProgress = false
    @State private var durationDigit = ""
    @State private var shareDuration = "hours"
    @State private var sharePassword = ""
    let shareDurationOptions = ["seconds", "minutes", "hours", "days"]
    @State private var sharedObjects: [String: ShareLinks] = [:]
    @State private var shareMessage: StatusPayload?
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

    private var resourceSharingSheet: some View {
        NavigationView {
            Form {
                if isShareInProgress {
                    ProgressView("Generating link...")
                }
                // MARK: Generated Links
                if let shareLink = sharedObjects[file.path],
                   let unsigned = shareLink.unsigned,
                   let preSigned = shareLink.presigned {
                    Section(header: Text("Links")) {
                        ShareLinkRow(title: "Unsigned URL", url: unsigned) { payload in
                            shareMessage = payload
                        }
                        ShareLinkRow(title: "Pre-Signed URL", url: preSigned) { payload in
                            shareMessage = payload
                        }
                    }
                    Button("Delete") {
                        deleteShared(deleteHash: shareLink.hash)
                    }
                    .foregroundColor(.red)
                } else {
                    Section(header: Text("Share Duration")) {
                        HStack {
                            TextField("0", text: $durationDigit)
                                .keyboardType(.numbersAndPunctuation)
                                .frame(width: 80)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Picker(selection: $shareDuration, label: Text("")) {
                                ForEach(shareDurationOptions, id: \.self) { duration in
                                    Text(duration.capitalized).tag(duration)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    Section(header: Text("Password")) {
                        SecureField("Enter password", text: $sharePassword)
                        if sharePassword.trimmingCharacters(in: .whitespaces).isEmpty {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("You are about to generate a **public** share link. It is recommended to add a password for additional security.")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 4)
                        }
                    }
                    Section {
                        HStack {
                            Spacer()
                            Button("Cancel") {
                                isSharing = false
                            }
                            .foregroundColor(.red)
                            .disabled(isShareInProgress)
                            Spacer()
                            Button("Share") {
                                isSharing = true
                                if let time = Int(durationDigit), time > 0 {
                                    submitShare()
                                } else {
                                    shareMessage = StatusPayload(
                                        text: "Input time should be more than 0",
                                        color: .red,
                                        duration: 3
                                    )
                                }
                            }
                            .disabled(isShareInProgress)
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("Share", displayMode: .inline)
            // MARK: Messages within share sheet
            .modifier(StatusMessage(payload: $shareMessage))
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
            .modifier(ErrorAlert(title: $errorTitle, message: $errorMessage))
            .sheet(isPresented: $isSharing) {
                resourceSharingSheet
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

    func deleteShared(deleteHash: String?) {
        guard let hash = deleteHash else {
            self.errorTitle = "Internal Error"
            self.errorMessage = "❌ Hash missing for shared link."
            return
        }
        guard let deleteURL = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "share", hash]
        ) else {
            self.errorTitle = "Internal Error"
            self.errorMessage = "❌ Failed to construct shared link"
            return
        }
        Log.debug("Delete share URL: \(deleteURL)")
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                self.errorTitle = "Server Error"
                guard error == nil else {
                    Log.error("❌ Request failed: \(error?.localizedDescription ?? "Unknown error")")
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    self.errorMessage = "Response was not HTTPURLResponse"
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    Log.error("❌ Server error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                    self.errorMessage = "[\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                    return
                }
                sharedObjects.removeValue(forKey: file.path)
                shareMessage = StatusPayload(text: "🗑️ Share link for \(file.name) has been removed", color: .red)
            }
        }.resume()
    }

    func submitShare() {
        if let existing = sharedObjects[file.path],
           existing.unsigned != nil,
           existing.presigned != nil {
            shareMessage = StatusPayload(
                text: "⚠️ A share for \(file.name) already exists!",
                color: .yellow
            )
            return
        }
        isShareInProgress = true
        guard let expiryTime = Int(durationDigit), expiryTime > 0 else {
            shareMessage = StatusPayload(
                text: "Input time should be more than 0",
                color: .red
            )
            return
        }

        guard let shareURL = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "share", file.path],
            queryItems: [
                URLQueryItem(name: "expires", value: String(expiryTime)),
                URLQueryItem(name: "unit", value: shareDuration)
            ]
        ) else {
            self.errorTitle = "Internal Error"
            self.errorMessage = "❌ Failed to construct shared link"
            return
        }
        Log.debug("Share URL: \(shareURL)")

        var request = URLRequest(url: shareURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        let body: [String: String] = [
            "password": sharePassword,
            "expires": String(expiryTime),
            "unit": shareDuration
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            Log.error("❌ Failed to encode JSON body: \(error.localizedDescription)")
            self.errorTitle = "Internal Error"
            self.errorMessage = "❌ Failed to encode JSON body: \(error.localizedDescription)"
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                defer {
                    isShareInProgress = false  // ✅ re-enable buttons after response
                }
                self.errorTitle = "Server Error"
                guard error == nil, let data = data else {
                    Log.error("❌ Request failed: \(error?.localizedDescription ?? "Unknown error")")
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    self.errorMessage = "Response was not HTTPURLResponse"
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    Log.error("❌ Server error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                    self.errorMessage = "[\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        Log.info("✅ JSON Data: \(json)")
                        let sharedLink = try JSONDecoder().decode(ShareResponse.self, from: data)
                        let unsigned = buildAPIURL(
                            base: serverURL,
                            pathComponents: ["share", sharedLink.hash]
                        )
                        var preSigned: URL?
                        if let token = sharedLink.token {
                            preSigned = buildAPIURL(
                                base: serverURL,
                                pathComponents: ["api", "public", "dl", sharedLink.hash, file.path],
                                queryItems: [URLQueryItem(name: "token", value: token)]
                            )
                        } else {
                            preSigned = buildAPIURL(
                                base: serverURL,
                                pathComponents: ["api", "public", "dl", sharedLink.hash, file.path]
                            )
                        }
                        self.sharedObjects[file.path] = ShareLinks(
                            unsigned: unsigned,
                            presigned: preSigned,
                            hash: sharedLink.hash
                        )
                        let delay = Double(sharedLink.expire) - Date().timeIntervalSince1970
                        if delay > 0 {
                            Log.info("Shared link will be cleared after \(expiryTime) \(shareDuration) [\(delay)s]")
                            shareMessage = StatusPayload(
                                text: "🔗 Share link for \(file.name) has been created", color: .green
                            )
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                shareMessage = StatusPayload(
                                    text: "⚠️ Shared link for \(file.name) has expired",
                                    color: .yellow,
                                    duration: 3
                                )
                                self.sharedObjects.removeValue(forKey: file.path)
                            }
                        } else {
                            // If the expiration time is in the past, remove it immediately
                            self.sharedObjects.removeValue(forKey: file.path)
                        }
                    } else {
                        Log.error("❌ Malformed /api/share/ response")
                        self.errorTitle = "Internal Error"
                        self.errorMessage = "❌ Malformed /api/share/ response"
                    }
                } catch {
                    Log.error("❌ JSON parse error for share: \(error.localizedDescription)")
                    self.errorTitle = "Internal Error"
                    self.errorMessage = "❌ JSON parse error for share: \(error.localizedDescription)"
                }
            }
        }.resume()
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
