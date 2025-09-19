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

    private func cacheKeyPrefix(for server: String) -> String {
        let safeServer = sanitizer(server.trimmingCharacters(in: CharacterSet(charactersIn: ".")))
        return "cache-\(safeServer)-"
    }

    private func cacheKey(for server: String, path: String, modified: String?, fileID: String?) -> String {
        let safePath = sanitizer(path)
        let safeServer = sanitizer(server.trimmingCharacters(in: CharacterSet(charactersIn: ".")))
        let safeFileID = sanitizer(fileID?.trimmingCharacters(in: CharacterSet(charactersIn: ".")) ?? "unknown")
        let safeModified = sanitizer(modified ?? "unknown", replacement: "-")
        return "cache-\(safeServer)-\(safePath)-\(safeFileID)-\(safeModified)"
    }

    func retrieve(for server: String, path: String, modified: String?, fileID: String?) -> Data? {
        let key = cacheKey(for: server, path: path, modified: modified, fileID: fileID)
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
        let key = cacheKey(for: server, path: path, modified: modified, fileID: fileID)
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
        // let cachePrefix = serverURL.map { cacheKeyPrefix(for: $0) } ?? diskCacheURL
        var cachePrefix: String
        if let server = serverURL {
            cachePrefix = cacheKeyPrefix(for: server)
            Log.info("Clearing local cache for: \(server)")
        } else {
            Log.info("Deleting ALL server cache")
            cachePrefix = ""
        }
        for url in urls {
            // Use ".path" for faster comparison (vs ".absoluteString")
            let cacheURL = url.path.components(separatedBy: "/").last ?? ""
            if cacheURL.hasPrefix(cachePrefix) {
                try? fileManager.removeItem(at: url)
            }
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
                    Log.info("🗑️ Deleted temp file: \(fileURL.lastPathComponent)")
                } catch {
                    Log.warn("⚠️ Failed to delete file: \(error)")
                }
            }
        }
    }
}
