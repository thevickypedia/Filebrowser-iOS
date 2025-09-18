//
//  FileList.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/18/25.
//

import Photos
import SwiftUI
import UniformTypeIdentifiers

func getNavigationTitle(for currentDisplayPath: String) -> String {
    // Use currentDisplayPath instead of pathStack for immediate updates
    if currentDisplayPath == "/" || currentDisplayPath.isEmpty {
        return "Home"
    }

    let components = currentDisplayPath.components(separatedBy: "/")
    return components.last?.isEmpty == false ? components.last! : "Home"
}

func getSheetNavigationTitle(_ sheetPathStack: [FileItem]) -> String {
    if sheetPathStack.isEmpty {
        return "Root" // Show "Root" when at the top level
    } else {
        return sheetPathStack.last?.name ?? "Root"
    }
}

func fullPath(for file: FileItem, with currentPath: String) -> String {
    if currentPath == "/" {
        return "/\(file.name)"
    } else {
        return "\(currentPath)/\(file.name)"
    }
}

// MARK: - Save Media to Photos
func saveToPhotos(fileURL: URL, fileType: UTType, completion: @escaping (Bool, Error?) -> Void) {
    // Ask only for add permission, not read
    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
        guard status == .authorized || status == .limited else {
            Log.warn("Photo Library add access denied")
            completion(false, NSError(
                domain: "PhotoLibrary", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Photo Library add access denied"]
            ))
            return
        }

        PHPhotoLibrary.shared().performChanges({
            if fileType.conforms(to: .image) {
                Log.trace("Storing \(fileURL.lastPathComponent) as an image")
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
            } else if fileType.conforms(to: .movie) {
                Log.trace("Storing \(fileURL.lastPathComponent) as a video")
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            } else {
                Log.warn("Unknown file type: \(fileType) - \(fileURL)")
            }
        }) { success, error in
            DispatchQueue.main.async { completion(success, error) }
        }
    }
}

// MARK: - Save Non-Media Files to Files App
func saveToFiles(fileURL: URL, fileName: String) -> URL? {
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let dest = docs.appendingPathComponent(fileName)

    // remove existing file if overwriting
    try? FileManager.default.removeItem(at: dest)

    do {
        try FileManager.default.copyItem(at: fileURL, to: dest)
        return dest
    } catch {
        Log.error("❌ Failed to save to Files: \(error.localizedDescription)")
        return nil
    }
}

func findFilePathForUploadId(_ id: UUID) -> String? {
    // If you didn't add filePath to notifications, this helper searches manager records for id
    if let rec = BackgroundTUSUploadManager.shared.records[id] {
        return rec.fileURL.path
    }
    return nil
}
