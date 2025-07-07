//
//  DebugFolderNavTestView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//


import SwiftUI

struct DebugFolderNavTestView: View {
    @State private var selectedPath: String?
    @State private var isActive = false

    let mockFolders = [
        ("Documents", "/documents"),
        ("Photos", "/photos"),
        ("Music", "/music")
    ]

    var body: some View {
        NavigationView {
            VStack {
                List(mockFolders, id: \.1) { folder in
                    HStack {
                        Image(systemName: "folder")
                        Text(folder.0)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedPath = folder.1
                        isActive = true
                    }
                }

                NavigationLink(
                    destination: Text("Opened: \(selectedPath ?? "nil")"),
                    isActive: $isActive
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("Test Nav")
        }
    }
}
