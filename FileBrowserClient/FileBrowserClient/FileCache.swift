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

    private func sanitize(_ input: String, replacement: Character = "_") -> String {
        let allowed = CharacterSet.alphanumerics
        let replaced = input.map { char in
            String(char).rangeOfCharacter(from: allowed) != nil ? char : replacement
        }
        let collapsed = String(replaced)
            .replacingOccurrences(of: "\(replacement)+", with: String(replacement), options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: String(replacement)))
        return collapsed
    }

    private func cacheKey(for server: String, path: String, modified: String?, fileID: String?) -> String {
        let safePath = sanitize(path)
        let safeServer = sanitize(server.trimmingCharacters(in: CharacterSet(charactersIn: ".")))
        let safeFileID = sanitize(fileID?.trimmingCharacters(in: CharacterSet(charactersIn: ".")) ?? "unknown")
        let safeModified = sanitize(modified ?? "unknown", replacement: "-")
        return "cache-\(safeServer)-\(safePath)-\(safeFileID)-\(safeModified)"
    }

    func retrieve(for server: String, path: String, modified: String?, fileID: String?) -> Data? {
        let key = cacheKey(for: server, path: path, modified: modified, fileID: fileID)
        let diskPath = diskCacheURL.appendingPathComponent(key)
        var result: Data?
        DispatchQueue.global(qos: .utility).sync {
            result = try? Data(contentsOf: diskPath, options: .mappedIfSafe)
            if result != nil {
                Log.debug("Cache retrieved: \(diskPath)")
            }
        }
        return result
    }

    func store(for server: String, data: Data, path: String, modified: String?, fileID: String?) {
        let key = cacheKey(for: server, path: path, modified: modified, fileID: fileID)
        let diskPath = diskCacheURL.appendingPathComponent(key)
        DispatchQueue.global(qos: .utility).async {
            if (try? data.write(to: diskPath)) != nil {
                Log.debug("Cache stored: \(diskPath)")
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

    func clearDiskCache() {
        // TODO: Instead of deleting all cache, only the logged in server's cache should be cleared
        guard let urls = try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: nil) else {
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
}
