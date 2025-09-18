//
//  DownloadManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/15/25.
//

import Foundation
import UniformTypeIdentifiers

final class DownloadManager: NSObject, URLSessionDownloadDelegate {
    static let shared = DownloadManager()
    private var session: URLSession!

    // Mapping id -> (task, progressClosure, completion)
    private var records: [UUID: (task: URLSessionDownloadTask, progress: (Int64, Int64, Int64) -> Void, completion: (Result<URL, Error>) -> Void)] = [:]

    private override init() {
        super.init()
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 60
        cfg.waitsForConnectivity = true
        session = URLSession(configuration: cfg, delegate: self, delegateQueue: nil)
    }

    /// Returns the UUID task id you can use to cancel
    @discardableResult
    func download(from url: URL, token: String?, id: UUID = UUID(),
                  progress: @escaping (Int64, Int64, Int64) -> Void,
                  completion: @escaping (Result<URL, Error>) -> Void) -> UUID {
        var req = URLRequest(url: url)
        if let authToken = token {
            req.setValue(authToken, forHTTPHeaderField: "X-Auth")
        }
        let task = session.downloadTask(with: req)
        records[id] = (task: task, progress: progress, completion: completion)
        task.resume()
        return id
    }

    func cancel(_ id: UUID) {
        guard let rec = records[id] else { return }
        rec.task.cancel()
        records.removeValue(forKey: id)
    }

    // MARK: URLSessionDownloadDelegate

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        // find record for task
        if let (id, _) = records.first(where: { $0.value.task.taskIdentifier == downloadTask.taskIdentifier }) {
            records[id]?.progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        // find record
        guard let pair = records.first(where: { $0.value.task.taskIdentifier == downloadTask.taskIdentifier }) else { return }
        let id = pair.key
        let completion = pair.value.completion

        // move file to unique temp location so it's safe to present/share
        let tmpDir = FileManager.default.temporaryDirectory
        let filename = downloadTask.response?.suggestedFilename ?? UUID().uuidString
        let dest = tmpDir.appendingPathComponent(filename)

        do {
            // remove existing if present
            if FileManager.default.fileExists(atPath: dest.path) {
                try FileManager.default.removeItem(at: dest)
            }
            try FileManager.default.moveItem(at: location, to: dest)
            completion(.success(dest))
        } catch {
            completion(.failure(error))
        }

        // cleanup record; keep completion already called
        records.removeValue(forKey: id)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // If error occurred, report it for the appropriate record
        if let err = error,
           let pair = records.first(where: { $0.value.task.taskIdentifier == task.taskIdentifier }) {
            let id = pair.key
            let completion = pair.value.completion
            completion(.failure(err))
            records.removeValue(forKey: id)
        }
    }
}
