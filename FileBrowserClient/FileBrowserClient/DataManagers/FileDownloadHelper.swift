//
//  FileDownloadHelper.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/21/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Photos

struct FileDownloadHelper {
    /// Builds the raw download URL for a file
    static func makeDownloadURL(serverURL: String, token: String, filePath: String) -> URL? {
        return buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "raw", filePath],
            queryItems: [ URLQueryItem(name: "auth", value: token) ]
        )
    }

    /// Handles saving downloaded file to Photos or Files
    static func handleDownloadCompletion(
        file: FileItem,
        localURL: URL,
        statusMessage: Binding<StatusPayload?>,
        errorTitle: Binding<String?>,
        errorMessage: Binding<String?>
    ) {
        let ext = localURL.pathExtension.lowercased()
        if let utType = UTType(filenameExtension: ext),
           utType.conforms(to: .image) || utType.conforms(to: .movie) || utType.identifier == "com.compuserve.gif" {
            // Save to Photos
            saveToPhotos(fileURL: localURL, fileType: utType) { success, error in
                if success {
                    statusMessage.wrappedValue = StatusPayload(
                        text: "📸 Saved to Photos: \(file.name)",
                        color: .green,
                        duration: 2
                    )
                } else {
                    errorTitle.wrappedValue = "Save Error"
                    errorMessage.wrappedValue = error?.localizedDescription ?? "Failed to save"
                }
                try? FileManager.default.removeItem(at: localURL)
            }
        } else {
            // Save to Files
            if let savedURL = saveToFiles(fileURL: localURL, fileName: file.name) {
                statusMessage.wrappedValue = StatusPayload(
                    text: "📂 Saved to Files: \(file.name)",
                    color: .green,
                    duration: 2
                )
                Log.debug("Saved file at: \(savedURL)")
            } else {
                errorMessage.wrappedValue = "Failed to save file: \(file.name)"
            }
            try? FileManager.default.removeItem(at: localURL)
        }
    }
}
