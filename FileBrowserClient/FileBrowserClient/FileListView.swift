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
    @State private var showingCreateAlert = false
    @State private var newFileName = ""

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
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    ForEach(viewModel.files) { file in
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

                    if viewModel.files.isEmpty && !viewModel.isLoading {
                        Text("No files found")
                            .foregroundColor(.gray)
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
                if auth.permissions?.create == true {
                    Button(action: { showingCreateAlert = true }) {
                        Image(systemName: "doc.badge.plus")
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
        .alert("Create New File", isPresented: $showingCreateAlert) {
            TextField("Filename", text: $newFileName)
            Button("Create", action: createFile)
            Button("Cancel", role: .cancel) { }
        }
        .onAppear {
            Log.debug("📂 FileListView appeared for path: \(path)")
            viewModel.fetchFiles(at: path)
        }
    }

    func createFile() {
        guard let serverURL = auth.serverURL,
              let token = auth.token else { return }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTimeZone]

        let isoString = formatter.string(from: Date())
        let fullPath = self.fullPath(for: FileItem(
            name: newFileName,
            path: newFileName,
            isDir: false,
            modified: isoString,
            size:0  // New files start with 0 bytes
        ))

        guard let encodedPath = fullPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed),
              let url = URL(string: "\(serverURL)/api/resources/\(encodedPath)?action=create") else {
            Log.error("❌ Failed to construct create file URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ File creation failed: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Log.error("❌ No HTTP response received")
                    return
                }

                if httpResponse.statusCode == 200 {
                    Log.info("✅ File created successfully")
                    viewModel.fetchFiles(at: path)
                } else {
                    Log.error("❌ File creation failed with status code: \(httpResponse.statusCode)")
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
