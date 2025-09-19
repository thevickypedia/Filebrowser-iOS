//
//  PhotoPicker.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/5/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

extension String {
    func ifEmpty(_ fallback: String) -> String {
        return self.isEmpty ? fallback : self
    }
}

extension Optional where Wrapped == String {
    func ifEmpty(_ fallback: String) -> String {
        switch self {
        case .some(let value): return value.ifEmpty(fallback)
        case .none: return fallback
        }
    }
}

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

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard !results.isEmpty else {
                DispatchQueue.main.async {
                    self.photoPickerStatus.isPreparingUpload = false
                }
                return
            }

            Log.info("Selected files for upload: \(results.count)")

            Task {
                await withTaskGroup(of: Void.self) { group in
                    for result in results {
                        group.addTask {
                            await self.handlePickedResult(result)
                        }
                    }

                    await group.waitForAll()

                    // ✅ Only after all are *launched* and finished
                    DispatchQueue.main.async {
                        self.photoPickerStatus.isPreparingUpload = false
                    }
                }
            }
        }

        func loadDataAsync(from provider: NSItemProvider, typeIdentifier: String) async throws -> Data {
            try await withCheckedThrowingContinuation { continuation in
                provider.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: NSError(domain: "PhotoPicker", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown data loading error"]))
                    }
                }
            }
        }

        func loadFileURLAsync(from provider: NSItemProvider, typeIdentifier: String, as suggestedName: String) async throws -> URL {
            try await withCheckedThrowingContinuation { continuation in
                provider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let sourceURL = url else {
                        continuation.resume(throwing: NSError(domain: "PhotoPicker", code: -1, userInfo: [NSLocalizedDescriptionKey: "File URL is nil"]))
                        return
                    }

                    let ext = URL(fileURLWithPath: suggestedName).pathExtension.ifEmpty("mov")
                    let base = URL(fileURLWithPath: suggestedName).deletingPathExtension().lastPathComponent
                    let filename = (base.isEmpty ? "video-\(UUID().uuidString)" : base) + ".\(ext)"

                    let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

                    do {
                        // Force overwrite if exists
                        if FileManager.default.fileExists(atPath: destinationURL.path) {
                            try FileManager.default.removeItem(at: destinationURL)
                        }

                        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                        continuation.resume(returning: destinationURL)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }

        // MARK: - Async handler
        private func handlePickedResult(_ result: PHPickerResult) async {
            let provider = result.itemProvider
            let suggestedName = provider.suggestedName ?? ""

            do {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    let data = try await loadDataAsync(from: provider, typeIdentifier: UTType.image.identifier)

                    let ext = URL(fileURLWithPath: suggestedName).pathExtension.ifEmpty("jpg")
                    let base = URL(fileURLWithPath: suggestedName).deletingPathExtension().lastPathComponent
                    let filename = (base.isEmpty ? "photo-\(UUID().uuidString)" : base) + ".\(ext)"

                    if let temp = FileCache.shared.writeTemporaryFile(data: data, suggestedName: filename) {
                        DispatchQueue.main.async {
                            self.onFilePicked(temp)
                        }
                    }
                } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    let fileURL = try await loadFileURLAsync(
                        from: provider,
                        typeIdentifier: UTType.movie.identifier,
                        as: suggestedName
                    )

                    DispatchQueue.main.async {
                        self.onFilePicked(fileURL)
                    }
                }
            } catch {
                Log.error("❌ Failed to handle picked file: \(suggestedName), error: \(error)")
            }
        }
    }
}
