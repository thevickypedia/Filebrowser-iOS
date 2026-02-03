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

    private func cacheKey(path: String, modified: String?, fileID: String?) -> String {
        let safePath = sanitizer(path)
        let safeFileID = sanitizer(fileID?.trimmingCharacters(in: CharacterSet(charactersIn: ".")) ?? "unknown")
        let safeModified = sanitizer(modified ?? "unknown", replacement: "-")
        return "cache-\(safePath)-\(safeFileID)-\(safeModified)"
    }

    func retrieve(for server: String, path: String, modified: String?, fileID: String?) -> Data? {
        let key = cacheKey(path: path, modified: modified, fileID: fileID)
        let diskPath = diskCacheURL.appendingPathComponent(key)
        var result: Data?
        DispatchQueue.global(qos: .utility).sync {
            result = try? Data(contentsOf: diskPath, options: .mappedIfSafe)
            if result != nil {
                Log.trace("Cache retrieved: \(diskPath)")
            }
        }
        return result
    }

    func store(for server: String, data: Data, path: String, modified: String?, fileID: String?) {
        let key = cacheKey(path: path, modified: modified, fileID: fileID)
        let diskPath = diskCacheURL.appendingPathComponent(key)
        DispatchQueue.global(qos: .utility).async {
            if (try? data.write(to: diskPath)) != nil {
                Log.trace("Cache stored: \(diskPath)")
            }
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

    func clearDiskCache(_ serverURL: String?) {
        guard let urls = try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: nil),
              !urls.isEmpty
        else {
            Log.info("No stored cache available!")
            return
        }
        for url in urls {
            try? fileManager.removeItem(at: url)
        }
    }

    func writeTemporaryFile(data: Data, suggestedName: String) -> URL? {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(suggestedName)
        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            Log.error("❌ Failed to write temp file: \(error)")
            return nil
        }
    }

    func copyToTemporaryFile(from sourceURL: URL, as suggestedName: String) -> URL? {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(suggestedName)
        do {
            if FileManager.default.fileExists(atPath: tempURL.path) {
                try FileManager.default.removeItem(at: tempURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: tempURL)
            return tempURL
        } catch {
            Log.error("❌ Failed to copy temp file: \(error.localizedDescription)")
            return nil
        }
    }

    func removeTempFile(at fileURL: URL) {
        Task(priority: .low) {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    Log.trace("🗑️ Deleted temp file: \(fileURL.lastPathComponent)")
                } catch {
                    Log.warn("⚠️ Failed to delete file: \(error.localizedDescription)")
                }
            }
        }
    }
}
