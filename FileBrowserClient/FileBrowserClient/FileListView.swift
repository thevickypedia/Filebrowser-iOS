//
//  FileListView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI

struct FileListView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var errorMessage: String?
    @EnvironmentObject var viewModel: FileListViewModel
    @State private var selectedPath: String?
    @State private var navigateToSubfolder = false
    @State private var lastLoadedPath: String?

    let path: String

    var body: some View {
        NavigationView {
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
                                    selectedPath = file.path
                                    navigateToSubfolder = true
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
                NavigationLink(
                    destination: Group {
                        if let path = selectedPath {
                            FileListView(path: path)
                                .environmentObject(viewModel)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $navigateToSubfolder
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("Files")
            .onAppear {
                if lastLoadedPath != path {
                    lastLoadedPath = path
                    viewModel.fetchFiles(at: path)
                }
            }
        }
    }
}

// Wrapper for decoding FileBrowser's response
struct ResourceResponse: Codable {
    let items: [FileItem]
}
