//
//  PhotoPicker.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/5/25.
//


import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    var onFilesPicked: (_ urls: [URL]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onFilesPicked: onFilesPicked)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0  // 0 == unlimited
        config.filter = .any(of: [.images, .videos])

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var onFilesPicked: (_ urls: [URL]) -> Void

        init(onFilesPicked: @escaping (_ urls: [URL]) -> Void) {
            self.onFilesPicked = onFilesPicked
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard !results.isEmpty else { return }

            var tempURLs: [URL] = []
            let dispatchGroup = DispatchGroup()

            for result in results {
                let provider = result.itemProvider

                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    dispatchGroup.enter()
                    provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                        defer { dispatchGroup.leave() }
                        if let data = data,
                           let url = FileCache.shared.writeTemporaryFile(data: data, suggestedName: "photo-\(UUID().uuidString).jpg") {
                            tempURLs.append(url)
                        }
                    }
                } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    dispatchGroup.enter()
                    provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                        defer { dispatchGroup.leave() }
                        guard let url = url,
                              let data = try? Data(contentsOf: url),
                              let temp = FileCache.shared.writeTemporaryFile(data: data, suggestedName: "video-\(UUID().uuidString).mov")
                        else { return }
                        tempURLs.append(temp)
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.onFilesPicked(tempURLs)
            }
        }
    }
}
