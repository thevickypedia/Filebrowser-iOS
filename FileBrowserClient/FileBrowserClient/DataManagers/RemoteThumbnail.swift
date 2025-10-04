//
//  RemoteThumbnail.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/28/25.
//

import SwiftUI
import AVFoundation

// MARK: - Global thumbnail loader
final class GlobalThumbnailLoader {
    static let shared = GlobalThumbnailLoader()

    private var inFlight: Set<String> = []
    private var subscribers: [String: [(UIImage?, Data?) -> Void]] = [:]
    // Only track failed paths to prevent infinite retries
    private var failedPaths: Set<String> = []
    private let queue = DispatchQueue(label: "GlobalThumbnailLoaderQueue", attributes: .concurrent)

    func load(filePath: String, start: () -> Void, completion: @escaping (UIImage?, Data?) -> Void) {
        var shouldStart = false
        var shouldSkip = false

        queue.sync(flags: .barrier) {
            // Don't retry failed paths (this prevents infinite retry loop)
            if failedPaths.contains(filePath) {
                shouldSkip = true
                return
            }

            if !inFlight.contains(filePath) {
                inFlight.insert(filePath)
                shouldStart = true
            }
            subscribers[filePath, default: []].append(completion)
        }

        if shouldSkip {
            // Return nil immediately for failed paths
            completion(nil, nil)
            return
        }

        if shouldStart {
            start()
        }
    }

    func finish(filePath: String, image: UIImage?, gifData: Data?, failed: Bool = false) {
        var completions: [(UIImage?, Data?) -> Void] = []

        queue.sync(flags: .barrier) {
            inFlight.remove(filePath)
            // Only mark as failed if it actually failed
            if failed {
                failedPaths.insert(filePath)
            }
            completions = subscribers[filePath] ?? []
            subscribers[filePath] = nil
        }

        for callback in completions {
            callback(image, gifData)
        }
    }

    func clearFailedPath(_ filePath: String? = nil) {
        if let path = filePath {
            _ = queue.sync(flags: .barrier) {
                failedPaths.remove(path)
            }
        } else {
            failedPaths.removeAll()
        }
    }
}

// MARK: - RemoteThumbnail View
struct RemoteThumbnail: View {
    let file: FileItem
    let serverURL: String
    let token: String
    let advancedSettings: AdvancedSettings
    let extensionTypes: ExtensionTypes
    var width: CGFloat = 32
    var height: CGFloat = 32
    @Binding var loadingFiles: [String: Bool]
    var iconSize: CGFloat
    let baseRequest: Request

    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var gifData: Data?
    // Prevent multiple load attempts
    @State private var loadAttempted = false

    private let thumbnailQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = Constants.maxConcurrentThumbnailRender
        return queue
    }()

    var body: some View {
        Group {
            if let gifData = gifData, advancedSettings.animateGIF {
                AnimatedImageView(data: gifData)
                    .frame(width: width, height: height)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            } else if isLoading {
                ProgressView()
                    .frame(width: width, height: height)
            } else {
                // Show default thumbnail (match other system icons)
                let symbol = systemIcon(for: file.name, extensionTypes: extensionTypes) ?? "doc"
                Image(systemName: symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
            }
        }
        .modifier(ViewVisibilityModifier(onVisible: {
            // MARK: Only attempt load once per view lifecycle
            // Keep threshold [0] as tight as possible to avoid loading anything outside current view
            if !loadAttempted {
                loadAttempted = true
                // Show spinner immediately for first-frame visibility
                isLoading = true
                loadingFiles[file.path] = true
                loadThumbnail()
            }
        }, threshold: 0))
        .id(file.path) // Ensure view resets when file changes
    }

    func overlayPlayIcon(on image: UIImage) -> UIImage {
        let size = image.size
        let renderer = UIGraphicsImageRenderer(size: size)
        Log.debug("▶️ Adding icon overlay for image")

        return renderer.image { _ in
            // Draw the original thumbnail
            image.draw(in: CGRect(origin: .zero, size: size))

            // Configure the play icon (adjust size and position)
            if let playIcon = UIImage(systemName: "play.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal) {
                let iconSize = CGSize(width: size.width * 0.3, height: size.width * 0.3)
                let iconOrigin = CGPoint(x: (size.width - iconSize.width) / 2,
                                         y: (size.height - iconSize.height) / 2)
                playIcon.draw(in: CGRect(origin: iconOrigin, size: iconSize))
            }
        }
    }

    private func loadThumbnail() {
        GlobalThumbnailLoader.shared.load(filePath: file.path, start: {
            // Start actual loading
            DispatchQueue.main.async {
                loadingFiles[file.path] = true
                image = nil
                gifData = nil
                isLoading = true
            }
            thumbnailQueue.addOperation {
                self.actuallyLoadThumbnail()
            }
        }, completion: { image, gifData in
            DispatchQueue.main.async {
                if let gif = gifData {
                    self.gifData = gif
                } else if let img = image {
                    self.image = img
                } else {
                    // Failed to load - will show default icon
                    // Don't need to do anything special here
                }
                self.isLoading = false
                self.loadingFiles[file.path] = false
            }
        })
    }

    private func retryHandler(retryCount: Int, errMsg: String) {
        if retryCount < Constants.thumbnailRetryLimit {
            Log.warn("⚠️ \(errMsg) — attempt \(retryCount + 1)")
            // Retry by re-adding operation to queue with incremented retry count
            thumbnailQueue.addOperation {
                self.actuallyLoadThumbnail(retryCount: retryCount + 1)
            }
        } else {
            Log.error("❌ \(errMsg) — retry attempts exceeded")
            GlobalThumbnailLoader.shared.finish(filePath: file.path, image: nil, gifData: nil, failed: true)
        }
    }

    private func actuallyLoadThumbnail(retryCount: Int = 0) {
        let fileName = file.name.lowercased()
        let isGIF = fileName.hasSuffix(".gif")
        let isVideo = extensionTypes.videoExtensions.contains { fileName.hasSuffix($0) }

        // Step 1: Cache check
        if advancedSettings.cacheThumbnail {
            let existingCache = FileCache.shared.retrieve(
                for: serverURL,
                path: file.path,
                modified: file.modified,
                fileID: "thumb"
            )
            if let cached = existingCache {
                if isGIF {
                    GlobalThumbnailLoader.shared.finish(filePath: file.path, image: nil, gifData: cached, failed: false)
                } else if let img = UIImage(data: cached) {
                    GlobalThumbnailLoader.shared.finish(filePath: file.path, image: img, gifData: nil, failed: false)
                } else {
                    // Cached data is corrupted, continue with network load
                }
                return
            }
        }

        // Step 2: Video thumbnail generation
        if isVideo {
            guard let videoURL = buildAPIURL(
                baseURL: serverURL,
                pathComponents: ["api", "raw", file.path],
                queryItems: [URLQueryItem(name: "auth", value: token)]
            ) else {
                GlobalThumbnailLoader.shared.finish(filePath: file.path, image: nil, gifData: nil, failed: true)
                return
            }

            // ⚠️ No extra DispatchQueue here since it's already on the thumbnailQueue
            autoreleasepool {
                let asset = AVURLAsset(url: videoURL)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                // Downscale thumbnails to reduce memory
                imageGenerator.maximumSize = CGSize(width: 320, height: 320)
                let time = CMTime(seconds: 1, preferredTimescale: 600)

                do {
                    let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                    let uiImage = UIImage(cgImage: cgImage)
                    let thumbImage = overlayPlayIcon(on: uiImage)
                    var imageData: Data?
                    if let compressed = thumbImage.jpegData(compressionQuality: Constants.thumbnailQuality) {
                        imageData = compressed
                        Log.debug("🗜️ Compressed thumbnail size: \(sizeConverter(compressed.count))")
                    } else {
                        Log.warn("Video thumbnail compression failed - falling back to PNG.")
                        imageData = thumbImage.pngData()
                    }
                    if let data = imageData, advancedSettings.cacheThumbnail {
                        FileCache.shared.store(
                            for: serverURL,
                            data: data,
                            path: file.path,
                            modified: file.modified,
                            fileID: "thumb"
                        )
                    }
                    GlobalThumbnailLoader.shared.finish(filePath: file.path, image: thumbImage, gifData: nil, failed: false)
                } catch {
                    let errMsg = "Video thumbnail generation failed: \(error.localizedDescription)"
                    retryHandler(retryCount: retryCount, errMsg: errMsg)
                }
            }
            return
        }

        // Step 3: Images & GIFs
        guard let preparedRequest = baseRequest.prepare(
            pathComponents: ["api", "preview", "thumb", file.path],
            queryItems: [
                URLQueryItem(name: "auth", value: token),
                URLQueryItem(name: "inline", value: "true")
            ]
        ) else {
            GlobalThumbnailLoader.shared.finish(filePath: file.path, image: nil, gifData: nil, failed: true)
            return
        }

        preparedRequest.session.dataTask(with: preparedRequest.request) { data, _, error in
            guard let data = data, error == nil else {
                let errMsg = "Image thumbnail request failed for file: \(file.name) — error: \(error?.localizedDescription ?? "Unknown error")"
                retryHandler(retryCount: retryCount, errMsg: errMsg)
                return
            }
            autoreleasepool {
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
                    GlobalThumbnailLoader.shared.finish(filePath: file.path, image: nil, gifData: data, failed: false)
                } else if let img = UIImage(data: data) {
                    GlobalThumbnailLoader.shared.finish(filePath: file.path, image: img, gifData: nil, failed: false)
                } else {
                    let errMsg = "Failed to decode image thumbnail for file: \(file.name) — data size: \(data.count) bytes"
                    retryHandler(retryCount: retryCount, errMsg: errMsg)
                }
            }
        }.resume()
    }
}
