//
//  LocalFileContentContainer.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/25/25.
//

import SwiftUI

struct LocalFileContentContainer: View {
    let localFile: URL
    let extensionTypes: ExtensionTypes
    @State private var content: Data?
    @State private var errorMessage: String?
    @State private var showExporter = false

    var body: some View {
        let fileName = localFile.lastPathComponent.lowercased()
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
            } else if let content = self.content {
                if extensionTypes.textExtensions.contains(where: fileName.hasSuffix) {
                    if let text = String(data: content, encoding: .utf8) {
                        ScrollView {
                            CopyableTextContainer(text: text)
                        }
                    } else {
                        Text("Failed to decode text")
                    }
                } else if fileName.hasSuffix(".pdf") {
                    PDFViewerScreen(content: content)
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
        .navigationTitle(localFile.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if extensionTypes.previewExtensions.contains(where: fileName.hasSuffix) && self.content == nil {
                loadContent()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showExporter = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showExporter) {
            FileExporter(fileURL: localFile)
        }
    }

    private func loadContent() {
        errorMessage = nil

        do {
            self.content = try Data(contentsOf: localFile)
        } catch {
            Log.warn("❌ Error loading file: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}
