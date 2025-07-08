//
//  FileListView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI
import SwiftUI

struct FileListView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var viewModel: FileListViewModel
    @Environment(\.dismiss) private var dismiss

    let path: String
    @Binding var isLoggedIn: Bool
    let logoutHandler: () -> Void

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                ForEach(viewModel.files) { file in
                    if file.isDir {
                        NavigationLink(
                            destination: FileListView(path: fullPath(for: file), isLoggedIn: $isLoggedIn, logoutHandler: logoutHandler)
                                .environmentObject(viewModel)
                        ) {
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
        .navigationTitle(path == "/" ? "Files" : path.components(separatedBy: "/").last ?? "Folder")
        .toolbar {
            // Left: Refresh button
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Refresh") {
                    viewModel.fetchFiles(at: path)
                }
            }

            // Center: Home button
            ToolbarItem(placement: .principal) {
                Button("Home") {
                    dismissToRoot()
                }
                .font(.headline)
            }

            // Right: Logout button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    auth.logout()
                    isLoggedIn = false
                    logoutHandler()
                }
            }
        }
        .onAppear {
            print("📂 FileListView appeared for path: \(path)")
            viewModel.fetchFiles(at: path)
        }
    }

    func dismissToRoot() {
        dismiss() // Pops one level; we can extend this if needed later
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
