//
//  LocalFileContentContainer.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/25/25.
//

import SwiftUI

func localFileContentView(for localFile: URL, with extensionTypes: ExtensionTypes) -> some View {
    LocalFileContentContainer(localFile: localFile, extensionTypes: extensionTypes)
}

// FIXME: File keeps closing automatically
struct LocalFileContentContainer: View {
    let localFile: URL
    let extensionTypes: ExtensionTypes
    @State private var loadedView: AnyView?
    @State private var isLoaded = false
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let error = errorMessage {
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
            } else if let loadedView = loadedView {
                loadedView
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
        loadedView = nil

        do {
            let fileName = localFile.lastPathComponent.lowercased()
            let content = try Data(contentsOf: localFile)

            if extensionTypes.textExtensions.contains(where: fileName.hasSuffix) {
                if let text = String(data: content, encoding: .utf8) {
                    loadedView = AnyView(
                        ScrollView {
                            CopyableTextContainer(text: text)
                        }
                    )
                } else {
                    throw NSError(domain: "DecodeError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not decode text"])
                }
            } else if fileName.hasSuffix(".pdf") {
                loadedView = AnyView(PDFViewerScreen(content: content))
            } else {
                loadedView = AnyView(
                    Text("⚠️ File preview not supported for this type.")
                        .foregroundColor(.gray)
                )
            }
        } catch {
            Log.warn("❌ Error loading file: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}
