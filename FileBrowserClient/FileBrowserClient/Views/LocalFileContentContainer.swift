//
//  LocalFileContentContainer.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/25/25.
//

import SwiftUI

struct LocalFileContentContainer: View {
    let localFile: URL
    let fileSize: Int?
    let extensionTypes: ExtensionTypes
    @State private var content: Data?
    @State private var showExporter = false
    @State private var previewError: PreviewErrorPayload?

    var body: some View {
        let fileName = localFile.lastPathComponent.lowercased()
        Group {
            if let errorPayload = previewError {
                VStack(spacing: 8) {
                    Text("Unable to load file")
                        .foregroundColor(.red)
                    Text(errorPayload.text)
                        .font(.caption)
                        .foregroundColor(errorPayload.color)
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
        previewError = nil
        content = nil
        if let warning = unsafeFileSize(byteSize: fileSize) {
            previewError = PreviewErrorPayload(text: warning)
            return
        }

        // DispatchQueue.main.async - Main thread where all UI updates happen
        // DispatchQueue.global(qos:) - Background thread used for non-UI tasks
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: localFile)
                DispatchQueue.main.async {
                    self.content = data
                }
            } catch {
                Log.warn("❌ Error loading file: \(error)")
                DispatchQueue.main.async {
                    previewError = PreviewErrorPayload(text: error.localizedDescription)
                }
            }
        }
    }
}
