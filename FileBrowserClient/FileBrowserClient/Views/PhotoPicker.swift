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
    @Published var currentlyPreparing: String?
}

struct PhotoPicker: UIViewControllerRepresentable {
    @ObservedObject var photoPickerStatus: PhotoPickerStatus
    var onFilesPicked: (_ urls: [URL]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(photoPickerStatus: photoPickerStatus, onFilesPicked: onFilesPicked)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        // MARK: Entry
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
        var onFilesPicked: (_ urls: [URL]) -> Void
        var photoPickerStatus: PhotoPickerStatus
        private var currentCount = 0
        private var processedFilenames = Set<String>()

        init(photoPickerStatus: PhotoPickerStatus, onFilesPicked: @escaping (_ urls: [URL]) -> Void) {
            self.photoPickerStatus = photoPickerStatus
            self.onFilesPicked = onFilesPicked
        }

        func updateCurrentProcessed(fileName: String, total: Int, bytes: Int? = nil) {
            DispatchQueue.main.async {
                if !self.processedFilenames.contains(fileName) {
                    self.currentCount += 1
                    self.processedFilenames.insert(fileName)
                }

                if let byteSize = bytes {
                    let fileSize = sizeConverter(byteSize)
                    if byteSize == 0 {
                        Log.debug("End: Writing \(fileName): Unable to determine file size")
                    } else {
                        Log.debug("End: Writing \(fileName): \(fileSize)")
                    }
                    self.photoPickerStatus.currentlyPreparing = "\(self.currentCount)/\(total): \(fileName) \(byteSize == 0 ? "" : "- \(fileSize)")"
                } else {
                    Log.debug("Start: Copying \(fileName)")
                    self.photoPickerStatus.currentlyPreparing = "\(self.currentCount)/\(total): \(fileName)"
                }
            }
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard !results.isEmpty else {
                // MARK: Exit early with reset state
                self.photoPickerStatus.isPreparingUpload = false
                return
            }

            let total = results.count
            Log.info("Selected files for upload: \(total)")

            let dispatchGroup = DispatchGroup()
            var collectedURLs: [URL] = []
            let resultQueue = DispatchQueue(label: "photoPicker.resultQueue") // For thread-safe access

            for result in results {
                dispatchGroup.enter()

                let provider = result.itemProvider
                let suggestedName = provider.suggestedName ?? "Unknown"

                let isImage = provider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
                let isVideo = provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier)

                let pathExt = URL(fileURLWithPath: suggestedName).pathExtension
                let base = URL(fileURLWithPath: suggestedName).deletingPathExtension().lastPathComponent

                let defaultExt = isImage ? "jpg" : "mov"
                let ext = pathExt.isEmpty ? defaultExt : pathExt

                let defaultPre = isImage ? "photo" : "video"
                let filename = (base.isEmpty ? "\(defaultPre)-\(UUID().uuidString)" : base) + ".\(ext)"

                self.updateCurrentProcessed(fileName: "\(suggestedName).\(ext)", total: total)

                if isImage {
                    provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                        defer { dispatchGroup.leave() }

                        guard let data = data else { return }

                        self.updateCurrentProcessed(fileName: "\(suggestedName).\(ext)", total: total, bytes: data.count)

                        if let temp = FileCache.shared.writeTemporaryFile(data: data, suggestedName: filename) {
                            resultQueue.async {
                                collectedURLs.append(temp)
                            }
                        }
                    }
                } else if isVideo {
                     provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                        defer { dispatchGroup.leave() }

                        guard let url = url else { return }

                        if let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? NSNumber {
                            self.updateCurrentProcessed(
                                fileName: "\(suggestedName).\(ext)", total: total, bytes: fileSize.intValue
                            )
                        } else {
                            self.updateCurrentProcessed(fileName: "\(suggestedName).\(ext)", total: total, bytes: 0)
                        }

                        if let temp = FileCache.shared.copyToTemporaryFile(from: url, as: filename) {
                            resultQueue.async {
                                collectedURLs.append(temp)
                            }
                        }
                    }
                } else {
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.onFilesPicked(collectedURLs)
                self.photoPickerStatus.isPreparingUpload = false
            }
        }
    }
}
