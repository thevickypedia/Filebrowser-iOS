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
        private var currentCount = 0
        private var processedFilenames = Set<String>()

        init(photoPickerStatus: PhotoPickerStatus, onFilePicked: @escaping (_ url: URL) -> Void) {
            self.photoPickerStatus = photoPickerStatus
            self.onFilePicked = onFilePicked
        }

        func updateCurrentProcessed(fileName: String, total: Int, bytes: Int? = nil) {
            DispatchQueue.main.async {
                if !self.processedFilenames.contains(fileName) {
                    self.currentCount += 1
                    self.processedFilenames.insert(fileName)
                }

                if let byteSize = bytes {
                    let fileSize = sizeConverter(byteSize)
                    Log.debug("Copied \(fileName) [\(fileSize)] to temp directory")
                } else {
                    Log.debug("Copied \(fileName) [Unknown size] to temp directory")
                }
            }
        }

        struct ProcessedResults {
            let provider: NSItemProvider
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
                processedResults.append(
                    ProcessedResults(
                        provider: provider, rawFileName: rawFileName, isImage: isImage, isVideo: isVideo, filename: filename)
                )
            }
            return processedResults
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking rawResults: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard !rawResults.isEmpty else {
                // MARK: Exit early with reset state
                self.photoPickerStatus.isPreparingUpload = false
                return
            }

            let results = preProcessor(rawResults)
            let total = results.count
            Log.info("Selected files for upload: \(total)")

            let writingQueue = DispatchQueue(label: "photoPicker.tempWriter", attributes: .concurrent)

            // TODO: One large file in between blocks smaller files that could have been uploaded meanwhile
            for result in results {
                writingQueue.async {
                    if result.isImage {
                        result.provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                            guard let data = data else { return }

                            self.updateCurrentProcessed(fileName: result.rawFileName, total: total, bytes: data.count)

                            if let temp = FileCache.shared.writeTemporaryFile(data: data, suggestedName: result.filename) {
                                DispatchQueue.main.async {
                                    self.onFilePicked(temp)
                                    self.photoPickerStatus.isPreparingUpload = false
                                }
                            }
                        }
                    } else if result.isVideo {
                        result.provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                            guard let url = url else { return }

                            if let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? NSNumber {
                                self.updateCurrentProcessed(
                                    fileName: result.rawFileName, total: total, bytes: fileSize.intValue
                                )
                            } else {
                                self.updateCurrentProcessed(fileName: result.rawFileName, total: total)
                            }

                            if let temp = FileCache.shared.copyToTemporaryFile(from: url, as: result.filename) {
                                DispatchQueue.main.async {
                                    self.onFilePicked(temp)
                                    self.photoPickerStatus.isPreparingUpload = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
