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
}

struct PhotoPicker: UIViewControllerRepresentable {
    @ObservedObject var photoPickerStatus: PhotoPickerStatus

    var onFilePicked: (_ url: URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(photoPickerStatus: photoPickerStatus, onFilePicked: onFilePicked)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        // MARK: Entry
        DispatchQueue.main.async {
            self.photoPickerStatus.isPreparingUpload = true
        }
        var config = PHPickerConfiguration()
        config.selectionLimit = 0  // 0 == unlimited
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

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard !results.isEmpty else {
                // MARK: Exit early with reset state
                self.photoPickerStatus.isPreparingUpload = false
                return
            }
            Log.info("Selected files for upload: \(results.count)")

            let writingQueue = DispatchQueue(label: "photoPicker.tempWriter", attributes: .concurrent)

            for result in results {
                writingQueue.async {
                    let provider = result.itemProvider
                    let suggestedName = provider.suggestedName ?? ""
                    Log.debug("Start: Writing \(suggestedName) to temporary location")

                    if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                            guard let data = data else { return }

                            let pathExt = URL(fileURLWithPath: suggestedName).pathExtension
                            let ext = pathExt.isEmpty ? "jpg" : pathExt
                            let base = URL(fileURLWithPath: suggestedName).deletingPathExtension().lastPathComponent
                            let filename = (base.isEmpty ? "photo-\(UUID().uuidString)" : base) + ".\(ext)"

                            if let temp = FileCache.shared.writeTemporaryFile(data: data, suggestedName: filename) {
                                DispatchQueue.main.async {
                                    self.onFilePicked(temp)
                                    self.photoPickerStatus.isPreparingUpload = false
                                }
                            }
                            Log.debug("End: Writing \(suggestedName) to temporary location")
                        }
                    } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                        provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                            guard let url = url,
                                  let data = try? Data(contentsOf: url) else { return }

                            let pathExt = URL(fileURLWithPath: suggestedName).pathExtension
                            let ext = pathExt.isEmpty ? "mov" : pathExt
                            let base = URL(fileURLWithPath: suggestedName).deletingPathExtension().lastPathComponent
                            let filename = (base.isEmpty ? "video-\(UUID().uuidString)" : base) + ".\(ext)"

                            if let temp = FileCache.shared.writeTemporaryFile(data: data, suggestedName: filename) {
                                DispatchQueue.main.async {
                                    self.onFilePicked(temp)
                                    self.photoPickerStatus.isPreparingUpload = false
                                }
                            }
                            Log.debug("End: Writing \(suggestedName) to temporary location")
                        }
                    }
                }
            }
        }
    }
}
