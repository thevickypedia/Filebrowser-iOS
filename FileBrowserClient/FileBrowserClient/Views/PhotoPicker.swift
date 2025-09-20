//
//  PhotoPicker.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/5/25.
//

import SwiftUI
import PhotosUI

class PhotoPickerStatus: ObservableObject {
    @Published var isPreparingUpload: Bool = false
    @Published var totalSelected: [String] = []
    @Published var processedFiles: [String] = []
    @Published var pendingUploads: [String] = []
    @Published var cancellableTasks: [Task<Void, Never>] = []
}

struct PhotoPicker: UIViewControllerRepresentable {
    @ObservedObject var photoPickerStatus: PhotoPickerStatus
    var onFilePicked: (_ url: URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(photoPickerStatus: photoPickerStatus, onFilePicked: onFilePicked)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        // MARK: Entry
        UIApplication.shared.isIdleTimerDisabled = true
        DispatchQueue.main.async {
            self.photoPickerStatus.isPreparingUpload = true
        }
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.filter = .any(of: [.images, .videos])

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var onFilePicked: (_ url: URL) -> Void
        var photoPickerStatus: PhotoPickerStatus

        init(photoPickerStatus: PhotoPickerStatus, onFilePicked: @escaping (_ url: URL) -> Void) {
            self.photoPickerStatus = photoPickerStatus
            self.onFilePicked = onFilePicked
        }

        // TODO: May be adding @MainActor is warranted
        func updateCurrentProcessed(fileName: String, total: Int, bytes: Int? = nil) {
            DispatchQueue.main.async {
                if !self.photoPickerStatus.processedFiles.contains(fileName) {
                    self.photoPickerStatus.processedFiles.append(fileName)
                }

                if let byteSize = bytes {
                    let fileSize = sizeConverter(byteSize)
                    Log.debug("Copying \(fileName) [\(fileSize)] to temp directory")
                } else {
                    Log.debug("Copying \(fileName) [Unknown size] to temp directory")
                }
            }
        }

        struct ProcessedResults: Sendable {
            let rawFileName: String
            let isImage: Bool
            let isVideo: Bool
            let filename: String
        }

        func preProcessor(_ rawResults: [PHPickerResult]) -> [ProcessedResults] {
            var processedResults: [ProcessedResults] = []
            for result in rawResults {
                let provider: NSItemProvider = result.itemProvider
                let suggestedName = provider.suggestedName ?? "Unknown"
                let isImage = provider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
                let isVideo = provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier)
                let pathExt = URL(fileURLWithPath: suggestedName).pathExtension
                let base = URL(fileURLWithPath: suggestedName).deletingPathExtension().lastPathComponent
                let defaultExt = isImage ? "jpg" : "mov"
                let ext = pathExt.isEmpty ? defaultExt : pathExt
                let rawFileName = "\(suggestedName).\(ext)"
                let defaultPre = isImage ? "photo" : "video"
                let filename = (base.isEmpty ? "\(defaultPre)-\(UUID().uuidString)" : base) + ".\(ext)"
                self.photoPickerStatus.totalSelected.append(rawFileName)
                self.photoPickerStatus.pendingUploads.append(rawFileName)
                processedResults.append(
                    ProcessedResults(
                        rawFileName: rawFileName, isImage: isImage, isVideo: isVideo, filename: filename)
                )
            }
            return processedResults
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking rawResults: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard !rawResults.isEmpty else {
                photoPickerStatus.isPreparingUpload = false
                return
            }

            let results = preProcessor(rawResults)
            let total = results.count
            Log.info("Selected files for upload: \(total)")

            // Cancel and clear existing tasks
            photoPickerStatus.cancellableTasks.forEach { $0.cancel() }
            photoPickerStatus.cancellableTasks.removeAll()

            // TODO: One large file in between, blocks smaller files that could have been uploaded meanwhile
            for (index, result) in results.enumerated() {
                // FIXME: Temporary solution - itemProvider should come from "preProcessor" func
                let provider = rawResults[index].itemProvider
                let fileName = result.rawFileName

                let task = Task(priority: .userInitiated) {
                    guard !Task.isCancelled else {
                        Log.debug("❌ Task cancelled before start: \(fileName)")
                        return
                    }

                    if result.isImage {
                        Log.debug("📷 Loading image: \(fileName)")

                        do {
                            let data = try await withCheckedThrowingContinuation { continuation in
                                provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                                    if let data = data {
                                        continuation.resume(returning: data)
                                    } else {
                                        continuation.resume(throwing: error ?? NSError(domain: "PhotoPicker", code: 1, userInfo: nil))
                                    }
                                }
                            }

                            guard !Task.isCancelled else {
                                Log.debug("🛑 Cancelled image processing: \(fileName)")
                                return
                            }

                            updateCurrentProcessed(fileName: fileName, total: total, bytes: data.count)

                            if let tempURL = FileCache.shared.writeTemporaryFile(data: data, suggestedName: result.filename) {
                                await MainActor.run {
                                    onFilePicked(tempURL)
                                }
                            }

                        } catch {
                            Log.error("❌ Failed to load image \(fileName): \(error.localizedDescription)")
                        }

                    } else if result.isVideo {
                        Log.debug("🎥 Loading video: \(fileName)")

                        do {
                            let tempCopiedURL: URL = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
                                provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                                    guard let tempURL = url else {
                                        continuation.resume(throwing: error ?? NSError(domain: "PhotoPicker", code: 2, userInfo: nil))
                                        return
                                    }

                                    if let copied = FileCache.shared.copyToTemporaryFile(from: tempURL, as: result.filename) {
                                        continuation.resume(returning: copied)
                                    } else {
                                        let copyError = NSError(domain: "PhotoPicker", code: 3, userInfo: [
                                            NSLocalizedDescriptionKey: "Failed to copy video temp file: \(tempURL.lastPathComponent)"
                                        ])
                                        continuation.resume(throwing: copyError)
                                    }
                                }
                            }
                            guard !Task.isCancelled else {
                                Log.debug("🛑 Cancelled video processing: \(fileName)")
                                return
                            }

                            let size = (try? FileManager.default.attributesOfItem(atPath: tempCopiedURL.path)[.size] as? NSNumber)?.intValue
                            updateCurrentProcessed(fileName: fileName, total: total, bytes: size)

                            await MainActor.run {
                                onFilePicked(tempCopiedURL)
                            }

                        } catch {
                            Log.error("❌ Failed to load video \(fileName): \(error.localizedDescription)")
                        }
                    }
                }

                Log.debug("📌 Task scheduled: \(fileName)")
                photoPickerStatus.cancellableTasks.append(task)
            }

            // Upload process officially started
            photoPickerStatus.isPreparingUpload = false
        }
    }
}
