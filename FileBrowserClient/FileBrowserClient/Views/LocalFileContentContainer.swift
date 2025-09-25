//
//  LocalFileContentContainer.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/25/25.
//

import SwiftUI

func localFileContentView(for localFile: URL) -> some View {
    LocalFileContentContainer(localFile: localFile)
}

struct LocalFileContentContainer: View {
    let localFile: URL
    @State private var content: String?
    @State private var isLoaded = false
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let content = content {
                ScrollView {
                    CopyableTextContainer(text: content)
                }
            } else if let error = errorMessage {
                VStack(spacing: 8) {
                    Text("Unable to load file")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Button("Retry") {
                        loadContent()
                    }
                }
            } else {
                ProgressView("Loading file...")
            }
        }
        .navigationTitle(localFile.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !isLoaded {
                loadContent()
            }
        }
    }

    private func loadContent() {
        isLoaded = true
        errorMessage = nil

        do {
            print("🔍 Loading file: \(localFile.lastPathComponent)")
            content = try String(contentsOf: localFile, encoding: .utf8)
            print("✅ Successfully loaded file, length: \(content?.count ?? 0)")
        } catch {
            print("❌ Error reading file: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}
