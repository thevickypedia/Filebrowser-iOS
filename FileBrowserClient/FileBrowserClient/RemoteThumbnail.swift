//
//  RemoteThumbnail.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/28/25.
//

import SwiftUI
import AVFoundation

struct RemoteThumbnail: View {
    let file: FileItem
    let serverURL: String
    let token: String
    let advancedSettings: AdvancedSettings
    let extensionTypes: ExtensionTypes
    var width: CGFloat = 32
    var height: CGFloat = 32
    var thumbnailQuality: CGFloat = 0.1
    @Binding var loadingFiles: [String: Bool]

    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var gifData: Data?

    var body: some View {
        Group {
            if let gifData = gifData, advancedSettings.animateGIF {
                AnimatedImageView(data: gifData)
                    .frame(width: self.width, height: self.height)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.width, height: self.height)
            } else if isLoading {
                ProgressView()
                    .frame(width: self.width, height: self.height)
            } else {
                Color.clear
                    .frame(width: self.width, height: self.height)
            }
        }
        .modifier(ViewVisibilityModifier(onVisible: {
            loadThumbnail()
        }, threshold: 0)) // Load 0px before the view comes into the viewport
    }

    func defaultThumbnail(fileName: String) -> UIImage? {
        return UIImage(
            systemName: systemIcon(
                for: fileName,
                extensionTypes: ExtensionTypes()
            ) ?? "doc"
        )
    }

    func resetLoadingFiles(delayFactor: Float = 0.1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isLoading = false
            loadingFiles[file.path] = false
        }
    }

    func loadThumbnail() {
        // Prevent loading if already in progress or cached
        guard loadingFiles[file.path] != true else { return }
        loadingFiles[file.path] = true

        // Reset state
        image = nil
        gifData = nil
        isLoading = true

        let fileName = file.name.lowercased()
        let isGIF = fileName.hasSuffix(".gif")
        let isVideo = extensionTypes.videoExtensions.contains { fileName.hasSuffix($0) }

        // Check cache
        if advancedSettings.cacheThumbnail {
            let existingCache = FileCache.shared.retrieve(
                for: serverURL,
                path: file.path,
                modified: file.modified,
                fileID: "thumb"
            )

            if isGIF {
                if let cached = existingCache {
                    self.gifData = cached
                    resetLoadingFiles(delayFactor: 0.5)
                    return
                }
            } else {
                if let cached = existingCache,
                   let image = UIImage(data: cached) {
                    self.image = image
                    resetLoadingFiles(delayFactor: isVideo ? 0.5 : 0.25)
                    return
                }
            }
        }

        // Step 2: Build URL

        // TODO: Display a small play icon to indicate that it is a video
        // Step 2a: Handle video thumbnail
        if isVideo {
            guard let videoURL = buildAPIURL(
                base: serverURL,
                pathComponents: ["api", "raw", file.path],
                queryItems: [
                    URLQueryItem(name: "auth", value: token)
                ]
            ) else {
                resetLoadingFiles()
                return
            }

            DispatchQueue.global(qos: .userInitiated).async {
                let asset = AVURLAsset(url: videoURL)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                let time = CMTime(seconds: 1, preferredTimescale: 600)

                do {
                    let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                    let uiImage = UIImage(cgImage: cgImage)
                    var imageData: Data?
                    if let compressed = uiImage.jpegData(compressionQuality: thumbnailQuality) {
                        imageData = compressed
                        Log.debug("📦 Compressed thumbnail size: \(sizeConverter(compressed.count))")
                    } else {
                        Log.warn("Video thumbnail compression failed — falling back to PNG.")
                        imageData = uiImage.pngData()
                    }

                    DispatchQueue.main.async {
                        if let data = imageData, advancedSettings.cacheThumbnail {
                            FileCache.shared.store(
                                for: serverURL,
                                data: data,
                                path: file.path,
                                modified: file.modified,
                                fileID: "thumb"
                            )
                        }
                        self.image = uiImage
                        resetLoadingFiles(delayFactor: 0.5)
                    }
                } catch {
                    Log.error("Video thumbnail generation failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.image = defaultThumbnail(fileName: fileName)
                        resetLoadingFiles()
                    }
                }
            }
            // Don't continue to image/gif fetch
            return
        }

        // Step 2b: Image or GIF fetch
        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "preview", "thumb", file.path],
            queryItems: [
                URLQueryItem(name: "auth", value: token),
                URLQueryItem(name: "inline", value: "true")
            ]
        ) else {
            resetLoadingFiles()
            return
        }

        // Step 3: Fetch and store
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.image = defaultThumbnail(fileName: fileName)
                    resetLoadingFiles()
                    return
                }
                if advancedSettings.cacheThumbnail {
                    FileCache.shared.store(
                        for: serverURL,
                        data: data,
                        path: file.path,
                        modified: file.modified,
                        fileID: "thumb"
                    )
                }
                if isGIF {
                    self.gifData = data
                } else if let image = UIImage(data: data) {
                    self.image = image
                } else {
                    self.image = defaultThumbnail(fileName: fileName)
                }
            }
        }.resume()

        resetLoadingFiles()
    }
}
