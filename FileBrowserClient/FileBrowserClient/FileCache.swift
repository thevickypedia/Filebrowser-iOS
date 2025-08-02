//
//  FileCache.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/29/25.
//


import UIKit

class FileCache {
    static let shared = FileCache()

    private let fileManager = FileManager.default
    private let diskCacheURL: URL

    private init() {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheURL = cacheDir.appendingPathComponent("filecache", isDirectory: true)
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }

    private func cacheKey(for path: String, modified: String?, fileID: String?) -> String {
        let safePath = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? UUID().uuidString
        let safeModified = modified ?? "unknown"
        let safeFileID = fileID?.trimmingCharacters(in: CharacterSet(charactersIn: ".")) ?? "unknown"
        return "cache-\(safePath)-\(safeFileID)-\(safeModified)"
    }

    func data(for path: String, modified: String?, fileID: String?) -> Data? {
        let key = cacheKey(for: path, modified: modified, fileID: fileID)
        let diskPath = diskCacheURL.appendingPathComponent(key)
        // return try? Data(contentsOf: diskPath)
        if let data = try? Data(contentsOf: diskPath) {
            Log.debug("Cache retrieved: {'path:' \(path), 'key': \(key)}")
            return data
        }
        return nil
    }

    func store(data: Data, for path: String, modified: String?, fileID: String?) {
        let key = cacheKey(for: path, modified: modified, fileID: fileID)
        let diskPath = diskCacheURL.appendingPathComponent(key)
        // try? data.write(to: diskPath)
        if let _ = try? data.write(to: diskPath) {
            Log.debug("Cache stored: {'path:' \(path), 'key': \(key)}")
        }
    }

    func diskCacheSize() -> Int64 {
        guard let urls = try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        return urls.reduce(0) { total, url in
            let size = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
            return total + Int64(size)
        }
    }

    func clearDiskCache() {
        guard let urls = try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: nil) else {
            return
        }
        for url in urls {
            try? fileManager.removeItem(at: url)
        }
    }
}
