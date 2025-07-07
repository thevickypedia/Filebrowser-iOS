//
//  FileListView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI

struct FileListView: View {
    @Binding var pathStack: [String]
    let currentPath: String

    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var viewModel: FileListViewModel
    @State private var errorMessage: String?
    @State private var lastLoadedPath: String?

    var body: some View {
        VStack {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    ForEach(viewModel.files) { file in
                        if file.isDir {
                            HStack {
                                Image(systemName: "folder")
                                Text(file.name)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                pathStack.append(file.path)
                            }
                        } else {
                            HStack {
                                Image(systemName: "doc")
                                Text(file.name)
                            }
                        }
                    }

                    if viewModel.files.isEmpty && !viewModel.isLoading {
                        Text("No files found")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Files")
        .onAppear {
            print("📂 FileListView appeared for path: \(currentPath)")
            if lastLoadedPath != currentPath {
                lastLoadedPath = currentPath
                viewModel.fetchFiles(at: currentPath)
            }
        }
    }
}

// Wrapper for decoding FileBrowser's response
struct ResourceResponse: Codable {
    let items: [FileItem]
}
