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

    @State private var showingSettings = false
    @State private var hideDotfiles = false

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
                Button("Save", action: saveHideDotfiles)
            }
            .onAppear {
                hideDotfiles = auth.userAccount?.hideDotfiles ?? false
            }
        }
    }

    func saveHideDotfiles() {
        guard let user = auth.userAccount,
              let token = auth.token,
              let serverURL = auth.serverURL else {
            Log.error("❌ Missing auth or user")
            return
        }

        let url = URL(string: "\(serverURL)/api/users/\(user.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        // Update settings
        var updatedUser = user
        updatedUser.hideDotfiles = hideDotfiles

        let payload: [String: Any] = [
            "what": "user",
            "which": ["locale", "hideDotfiles", "dateFormat"],
            "data": try! JSONSerialization.jsonObject(with: JSONEncoder().encode(updatedUser))
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                let bodyString = data.flatMap { String(data: $0, encoding: .utf8) } ?? "(no body)"
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    Log.info("✅ Hide dotfiles saved")
                    auth.userAccount?.hideDotfiles = hideDotfiles
                    showingSettings = false
                    viewModel.fetchFiles(at: path)
                } else {
                    Log.error("❌ Failed to save: \(bodyString)")
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

    func renameSelectedItem() {
        guard let item = selectedItems.first,
            let serverURL = auth.serverURL,
            let token = auth.token else {
            return
        }

        let fromPath = item.path
        let toPath = URL(fileURLWithPath: item.path)
            .deletingLastPathComponent()
            .appendingPathComponent(renameInput)
            .path

        guard let encodedFrom = fromPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let encodedTo = toPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "\(serverURL)/api/resources/\(encodedFrom)?action=rename&destination=\(encodedTo)&override=false&rename=false")
        else {
            Log.error("❌ Failed to build rename URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ Rename failed: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    Log.info("✅ Rename successful")
                    selectedItems.removeAll()
                    isRenaming = false
                    selectionMode = false
                    viewModel.fetchFiles(at: path)
                } else {
                    Log.error("❌ Rename failed with status code")
                }
            }
        }.resume()
    }

    func toggleSelection(for item: FileItem) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }

    func createResource(isDirectory: Bool) {
        guard let serverURL = auth.serverURL,
              let token = auth.token else { return }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTimeZone]

        let isoString = formatter.string(from: Date())
        let fullPath = self.fullPath(for: FileItem(
            name: newResourceName,
            path: newResourceName,
            isDir: isDirectory,
            modified: isoString,
            size: 0  // New file/folder start with 0 bytes
        ))

        let separator = isDirectory ? "/?" : "?"
        guard let encodedPath = fullPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed),
              let url = URL(string: "\(serverURL)/api/resources\(encodedPath)\(separator)override=false") else {
            Log.error("❌ Failed to construct create file URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        let resourceType = isDirectory ? "Folder" : "File"
        Log.info("🔄 Creating \(resourceType) at path: \(fullPath)")
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ \(resourceType) creation failed: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Log.error("❌ No HTTP response received")
                    return
                }

                if httpResponse.statusCode == 200 {
                    Log.info("✅ \(resourceType) created successfully")
                    viewModel.fetchFiles(at: path)
                } else {
                    Log.error("❌ \(resourceType) creation failed with status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
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
