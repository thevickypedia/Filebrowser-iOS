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

        init(photoPickerStatus: PhotoPickerStatus, onFilesPicked: @escaping (_ urls: [URL]) -> Void) {
            self.photoPickerStatus = photoPickerStatus
            self.onFilesPicked = onFilesPicked
        }

        func updateCurrentProcessed(fileName: String, bytes: Int, idx: Int, total: Int) {
            let fileSize = sizeConverter(bytes)
            if bytes == 0 {
                Log.debug("\(fileName): Unable to determine file size")
            } else {
                Log.debug("\(fileName): \(fileSize)")
            }
            DispatchQueue.main.async {
                self.photoPickerStatus.currentlyPreparing = "Preparing [\(idx)/\(total)] \(fileName) \(bytes == 0 ? "" : "- \(fileSize)")"
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

            // TODO: Drop enumerated and use iterative count - accurate index can swap idx from 4 to 1
            for (idx, result) in results.enumerated() {
                dispatchGroup.enter()

                let provider = result.itemProvider
                let suggestedName = provider.suggestedName ?? "Unknown"

                Log.info("Start: Processing \(suggestedName)")

                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                        defer { dispatchGroup.leave() }

                        guard let data = data else { return }

                        let pathExt = URL(fileURLWithPath: suggestedName).pathExtension
                        let ext = pathExt.isEmpty ? "jpg" : pathExt
                        let base = URL(fileURLWithPath: suggestedName).deletingPathExtension().lastPathComponent
                        let filename = (base.isEmpty ? "photo-\(UUID().uuidString)" : base) + ".\(ext)"

                        self.updateCurrentProcessed(fileName: "\(suggestedName).\(ext)", bytes: data.count, idx: idx, total: total)

                        if let temp = FileCache.shared.writeTemporaryFile(data: data, suggestedName: filename) {
                            resultQueue.async {
                                collectedURLs.append(temp)
                            }
                        }

                        Log.info("End: Writing image \(suggestedName)")
                    }
                } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                        defer { dispatchGroup.leave() }

                        guard let url = url else { return }

                        let pathExt = URL(fileURLWithPath: suggestedName).pathExtension
                        let ext = pathExt.isEmpty ? "mov" : pathExt
                        let base = URL(fileURLWithPath: suggestedName).deletingPathExtension().lastPathComponent
                        let filename = (base.isEmpty ? "video-\(UUID().uuidString)" : base) + ".\(ext)"

                        if let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? NSNumber {
                            self.updateCurrentProcessed(
                                fileName: "\(suggestedName).\(ext)", bytes: fileSize.intValue, idx: idx, total: total
                            )
                        } else {
                            self.updateCurrentProcessed(fileName: "\(suggestedName).\(ext)", bytes: 0, idx: idx, total: total)
                        }

                        if let temp = FileCache.shared.copyToTemporaryFile(from: url, as: filename) {
                            resultQueue.async {
                                collectedURLs.append(temp)
                            }
                        }

                        Log.info("End: Copying video \(suggestedName)")
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
