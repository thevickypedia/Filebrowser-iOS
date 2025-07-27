//
//  FileListView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI

struct FileListView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var viewModel: FileListViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) private var dismiss

    @State private var showingCreateFileAlert = false
    @State private var showingCreateFolderAlert = false
    @State private var newResourceName = ""

    @State private var selectionMode = false
    @State private var selectedItems: Set<FileItem> = []
    @State private var showingDeleteConfirm = false

    @State private var isRenaming = false
    @State private var renameInput = ""

    @State private var hideDotfiles = false
    @State private var showingSettings = false
    @State private var dateFormatExact = false

    @State private var showFileImporter = false

    let path: String
    @Binding var isLoggedIn: Bool
    @Binding var pathStack: [String]
    let logoutHandler: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)").foregroundColor(.red)
                } else {
                    ForEach(viewModel.files) { file in
                        if selectionMode {
                            HStack {
                                Image(systemName: selectedItems.contains(file) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedItems.contains(file) ? .blue : .gray)
                                Image(systemName: file.isDir ? "folder" : "doc")
                                Text(file.name)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(for: file)
                            }
                        } else {
                            if file.isDir {
                                NavigationLink(value: fullPath(for: file)) {
                                    HStack {
                                        Image(systemName: "folder")
                                        Text(file.name)
                                    }
                                }
                            } else {
                                NavigationLink(
                                    destination: FileDetailView(
                                        file: file,
                                        serverURL: auth.serverURL ?? "",
                                        token: auth.token ?? ""
                                    )
                                ) {
                                    HStack {
                                        Image(systemName: "doc")
                                        Text(file.name)
                                    }
                                }
                            }
                        }
                    }

                    if viewModel.files.isEmpty && !viewModel.isLoading {
                        Text("No files found").foregroundColor(.gray)
                    }
                }
            }

            // 🌗 Floating Theme Toggle
            Button(action: {
                themeManager.colorScheme = themeManager.colorScheme == .dark ? .light : .dark
            }) {
                Image(systemName: themeManager.colorScheme == .dark ? "sun.max.fill" : "moon.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 30)
        }
        .navigationTitle(pathStack.last?.components(separatedBy: "/").last ?? "Home")
        .toolbar {
            // Left: Refresh button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { refreshFolder() }) {
                    Image(systemName: "arrow.clockwise")
                }
            }

            // Center: Home button
            ToolbarItem(placement: .principal) {
                Button(action: { 
                    pathStack = []
                    viewModel.fetchFiles(at: "/")
                    Log.info("🔙 Dismissing to root directory")
                 }) {
                    Image(systemName: "house")
                }
            }

            // Right: Create and Logout buttons
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    if auth.permissions?.create == true {
                        Button("Create File", systemImage: "doc.badge.plus", action: {
                            showingCreateFileAlert = true
                        })
                        Button("Create Folder", systemImage: "folder.badge.plus", action: {
                            showingCreateFolderAlert = true
                        })
                    }
                    // ⚙️ Gear icon to open Settings
                    Button("Settings", systemImage: "gearshape", action: {
                        showingSettings = true
                    })
                    Button("Upload File", systemImage: "square.and.arrow.up", action: {
                        showFileImporter = true
                    })
                } label: {
                    Label("Actions", systemImage: "person.circle")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if selectionMode {
                    // 🗑️ Delete
                    Button(action: {
                        if selectedItems.isEmpty { return }
                        showingDeleteConfirm = true
                    }) {
                        Image(systemName: "trash")
                    }

                    // 📝 Rename — only when exactly 1 item is selected
                    if selectedItems.count == 1 {
                        Button(action: {
                            if let item = selectedItems.first {
                                renameInput = item.name
                                isRenaming = true
                            }
                        }) {
                            Image(systemName: "pencil")
                        }
                    }

                    // ✅ Select All / Deselect All
                    Button(action: toggleSelectAll) {
                        Image(systemName:
                            selectedItems.count == viewModel.files.count
                            ? "square.dashed"
                            : "checkmark.square"
                        )
                    }

                    // ❌ Cancel
                    Button(action: {
                        selectedItems.removeAll()
                        selectionMode = false
                    }) {
                        Image(systemName: "xmark.circle")
                    }

                } else {
                    Button(action: {
                        selectionMode = true
                    }) {
                        Image(systemName: "checkmark.circle")
                    }
                }
                Button(action: {
                    Log.info("Logged out!")
                    auth.logout()
                    logoutHandler()
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .alert("Create New File", isPresented: $showingCreateFileAlert) {
            TextField("Filename", text: $newResourceName)
            Button("Create", action: {
                createResource(isDirectory: false)
            })
            Button("Cancel", role: .cancel) { }
        }
        .alert("Create New Folder", isPresented: $showingCreateFolderAlert) {
            TextField("Folder Name", text: $newResourceName)
            Button("Create", action: {
                createResource(isDirectory: true)
            })
            Button("Cancel", role: .cancel) { }
        }
        .alert("Delete Selected?", isPresented: $showingDeleteConfirm) {
            Button("Delete", role: .destructive) {
                deleteSelectedItems()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete \(selectedItems.count) items?")
        }
        .alert("Rename", isPresented: $isRenaming) {
            TextField("New name", text: $renameInput)
            Button("Rename", action: renameSelectedItem)
            Button("Cancel", role: .cancel) {}
        }
        .onAppear {
            Log.debug("📂 FileListView appeared for path: \(path)")
            viewModel.fetchFiles(at: path)
        }
        .sheet(isPresented: $showingSettings) {
            Form {
                Toggle("Hide dotfiles", isOn: $hideDotfiles)
                Toggle("Set exact date format", isOn: $dateFormatExact)
                Button("Save", action: saveSettings)
            }
            .onAppear {
                hideDotfiles = auth.userAccount?.hideDotfiles ?? false
                dateFormatExact = auth.userAccount?.dateFormat ?? false
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.item], // use more specific UTTypes if desired
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let fileURL = urls.first {
                    initiateTusUpload(for: fileURL)
                }
            case .failure(let error):
                Log.error("❌ File selection failed: \(error.localizedDescription)")
            }
        }
    }

    func getUploadURL(serverURL: String, encodedName: String) -> URL? {
        if path == "/" {
            return URL(string: "\(serverURL)/api/tus/\(encodedName)?override=false")
        }
        return URL(string: "\(serverURL)/api/tus\(path)/\(encodedName)?override=false")
    }

    func initiateTusUpload(for fileURL: URL) {
        guard let token = auth.token, let serverURL = auth.serverURL else {
            Log.error("❌ Missing auth info")
            return
        }

        let fileName = fileURL.lastPathComponent
        guard let encodedName = fileName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let uploadURL = getUploadURL(serverURL: serverURL, encodedName: encodedName) else {
            Log.error("❌ Invalid upload URL")
            return
        }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ POST failed: \(error.localizedDescription)")
                    return
                }

                Log.info("✅ Upload session initiated at: \(uploadURL.relativePath)")
                getUploadOffset(fileURL: fileURL, uploadURL: uploadURL)
            }
        }.resume()
    }

    func getUploadOffset(fileURL: URL, uploadURL: URL) {
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "HEAD"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue(auth.token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ HEAD failed: \(error.localizedDescription)")
                    return
                }

                guard let http = response as? HTTPURLResponse,
                      let offsetStr = http.value(forHTTPHeaderField: "Upload-Offset"),
                      let offset = Int(offsetStr) else {
                    Log.error("❌ HEAD missing Upload-Offset")
                    return
                }

                Log.info("📍 Upload starting from offset: \(offset)")
                uploadFileInChunks(fileURL: fileURL, to: uploadURL, startingAt: offset)
            }
        }.resume()
    }

    func uploadFileInChunks(fileURL: URL, to uploadURL: URL, startingAt offset: Int) {
        let chunkSize = 1 * 1024 * 1024 // 1MB
        guard let fileHandle = try? FileHandle(forReadingFrom: fileURL) else {
            Log.error("❌ Cannot open file for reading")
            return
        }

        let fileSize = (try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? Int) ?? 0
        var currentOffset = offset

        func uploadNext() {
            guard currentOffset < fileSize else {
                fileHandle.closeFile()
                Log.info("✅ Upload complete: \(fileURL.lastPathComponent)")
                viewModel.fetchFiles(at: path)
                return
            }

            fileHandle.seek(toFileOffset: UInt64(currentOffset))
            let data = fileHandle.readData(ofLength: chunkSize)

            var request = URLRequest(url: uploadURL)
            request.httpMethod = "PATCH"
            request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
            request.setValue("\(currentOffset)", forHTTPHeaderField: "Upload-Offset")
            request.setValue("application/offset+octet-stream", forHTTPHeaderField: "Content-Type")
            request.setValue(auth.token, forHTTPHeaderField: "X-Auth")

            URLSession.shared.uploadTask(with: request, from: data) { _, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        Log.error("❌ PATCH failed: \(error.localizedDescription)")
                        return
                    }

                    guard let http = response as? HTTPURLResponse, http.statusCode == 204 else {
                        Log.error("❌ Unexpected PATCH response: \(response.debugDescription)")
                        return
                    }

                    currentOffset += data.count
                    Log.debug("📤 Uploaded chunk — new offset: \(currentOffset)")
                    uploadNext()
                }
            }.resume()
        }
        uploadNext()
    }

    @discardableResult
    func makeRequest(
        endpoint: String,
        method: String = "GET",
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil,
        contentType: String = "application/json",
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask? {
        // todo: Ensure user is aware of failed requests to the server and the reason for failure
        guard let token = auth.token,
              let serverURL = auth.serverURL,
              var components = URLComponents(string: serverURL + endpoint) else {
            Log.error("❌ Invalid auth or URL for request")
            return nil
        }

        components.queryItems = queryItems
        guard let url = components.url else {
            Log.error("❌ Failed to build URL with query parameters")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(token, forHTTPHeaderField: "X-Auth")
        if method != "GET" && method != "DELETE" {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let responseCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            if let error = error {
                Log.error("❌ Request failed: \(error.localizedDescription)")
            } else if responseCode != 200 {
                let bodyString = data.flatMap { String(data: $0, encoding: .utf8) } ?? "(no body)"
                Log.error("❌ Request failed with status \(responseCode): \(bodyString)")
            } else {
                Log.info("✅ Request successful: \(responseCode)")
            }
            completion(data, response, error)
        }
        
        task.resume()
        return task
    }

    func makePayload<T: Encodable>(
        what: String,
        which: [String],
        data: T
    ) -> Data? {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let jsonData = try JSONSerialization.jsonObject(with: encodedData, options: [])
            let payload: [String: Any] = [
                "what": what,
                "which": which,
                "data": jsonData
            ]
            return try JSONSerialization.data(withJSONObject: payload)
        } catch {
            Log.error("❌ Failed to encode payload: \(error.localizedDescription)")
            return nil
        }
    }

    func saveSettings() {
        guard let user = auth.userAccount,
            let token = auth.token,
            let serverURL = auth.serverURL else {
            Log.error("❌ Missing auth or user info")
            return
        }

        let url = URL(string: "\(serverURL)/api/users/\(user.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        var updated = user
        updated.hideDotfiles = hideDotfiles
        updated.dateFormat = dateFormatExact

        let dataDict = (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(updated))) ?? [:]

        let payload: [String: Any] = [
            "what": "user",
            "which": ["locale", "hideDotfiles", "dateFormat"],
            "data": dataDict
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? "(no body)"
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    Log.info("✅ Settings saved")
                    auth.userAccount?.hideDotfiles = hideDotfiles
                    auth.userAccount?.dateFormat = dateFormatExact
                    showingSettings = false
                    viewModel.fetchFiles(at: path)
                } else {
                    Log.error("❌ Settings save failed: \(body)")
                }
            }
        }.resume()
    }

    func toggleSelectAll() {
        if selectedItems.count == viewModel.files.count {
            selectedItems.removeAll()
        } else {
            selectedItems = Set(viewModel.files)
        }
    }

    func deleteSelectedItems() {
        guard let token = auth.token, let baseURL = auth.serverURL else { return }

        let group = DispatchGroup()
        for item in selectedItems {
            guard let encodedPath = item.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                let url = URL(string: "\(baseURL)/api/resources/\(encodedPath)") else {
                Log.error("❌ Invalid path for \(item.name)")
                continue
            }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue(token, forHTTPHeaderField: "X-Auth")

            group.enter()
            URLSession.shared.dataTask(with: request) { _, _, _ in
                group.leave()
            }.resume()
        }

        group.notify(queue: .main) {
            Log.info("✅ Deleted \(selectedItems.count) items")
            selectedItems.removeAll()
            selectionMode = false
            viewModel.fetchFiles(at: path)
        }
    }

    func encodedPath(_ path: String, allowed: CharacterSet = .urlPathAllowed) -> String? {
        return path.addingPercentEncoding(withAllowedCharacters: allowed)
    }

    func renameSelectedItem() {
        guard let item = selectedItems.first else { return }
        let fromPath = item.path
        let toPath = URL(fileURLWithPath: item.path)
            .deletingLastPathComponent()
            .appendingPathComponent(renameInput)
            .path

        guard let encodedFrom = fromPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let encodedTo = toPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            Log.error("❌ Failed to encode paths")
            return
        }

        let endpoint = "/api/resources/\(encodedFrom)"
        let query: [URLQueryItem] = [
            URLQueryItem(name: "action", value: "rename"),
            URLQueryItem(name: "destination", value: encodedTo),
            URLQueryItem(name: "override", value: "false"),
            URLQueryItem(name: "rename", value: "false")
        ]

        makeRequest(endpoint: endpoint, method: "PATCH", queryItems: query) { _, response, _ in
            DispatchQueue.main.async {
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    Log.info("✅ Rename successful")
                    selectedItems.removeAll()
                    isRenaming = false
                    selectionMode = false
                    viewModel.fetchFiles(at: path)
                }
            }
        }
    }

    func toggleSelection(for item: FileItem) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }

    func createResource(isDirectory: Bool) {
        guard let _ = auth.serverURL, let _ = auth.token else { return }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTimeZone]
        let isoString = formatter.string(from: Date())

        let fileItem = FileItem(
            name: newResourceName,
            path: newResourceName,
            isDir: isDirectory,
            modified: isoString,
            size: 0
        )
        let fullPath = self.fullPath(for: fileItem)

        guard let encodedPath = encodedPath(fullPath) else {
            Log.error("❌ Failed to encode path")
            return
        }

        let separator = isDirectory ? "/?" : "?"
        let endpoint = "/api/resources\(encodedPath)\(separator)"
        let query: [URLQueryItem] = [
            URLQueryItem(name: "override", value: "false")
        ]

        let resourceType = isDirectory ? "Folder" : "File"
        Log.info("🔄 Creating \(resourceType) at path: \(fullPath)")

        makeRequest(endpoint: endpoint, method: "POST", queryItems: query) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ \(resourceType) creation failed: \(error.localizedDescription)")
                    return
                }

                guard let http = response as? HTTPURLResponse else {
                    Log.error("❌ No HTTP response received")
                    return
                }

                if http.statusCode == 200 {
                    Log.info("✅ \(resourceType) created successfully")
                    viewModel.fetchFiles(at: path)
                } else {
                    Log.error("❌ \(resourceType) creation failed with status code: \(http.statusCode)")
                }
            }
        }
    }

    func refreshFolder() {
        viewModel.fetchFiles(at: path)
    }

    private func fullPath(for file: FileItem) -> String {
        if path == "/" {
            return "/\(file.name)"
        } else {
            return "\(path)/\(file.name)"
        }
    }
}

// Wrapper for decoding FileBrowser's response
struct ResourceResponse: Codable {
    let items: [FileItem]
}
