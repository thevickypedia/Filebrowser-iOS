//
//  ThumbnailCache.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/29/25.
//


import UIKit

class ThumbnailCache {
    static let shared = ThumbnailCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheURL: URL

    private init() {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheURL = cacheDir.appendingPathComponent("thumbnails", isDirectory: true)

        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }

    private func cacheKey(for path: String, modified: String?) -> String {
        let safePath = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? UUID().uuidString
        let safeModified = modified ?? "unknown"
        return "thumb-\(safePath)-\(safeModified)"
    }

    func image(for path: String, modified: String?) -> UIImage? {
        let key = cacheKey(for: path, modified: modified) as NSString

        if let image = memoryCache.object(forKey: key) {
            return image
        }

        let diskPath = diskCacheURL.appendingPathComponent(key as String)
        if let data = try? Data(contentsOf: diskPath),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key)
            return image
        }

        return nil
    }

    func store(image: UIImage, for path: String, modified: String?) {
        let key = cacheKey(for: path, modified: modified) as NSString
        memoryCache.setObject(image, forKey: key)

        let diskPath = diskCacheURL.appendingPathComponent(key as String)
        if let data = image.pngData() {
            try? data.write(to: diskPath)
        }
    }
}
