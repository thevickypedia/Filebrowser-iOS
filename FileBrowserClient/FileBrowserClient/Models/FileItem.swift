//
//  FileItem.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import Foundation

struct FileItem: Codable, Identifiable, Hashable {
    var id: String { path }

    let path: String
    let name: String
    let size: Int
    let `extension`: String
    let modified: String
    let mode: Int  // File mode (mod)
    let isDir: Bool
    let isSymlink: Bool
    let type: String
}

struct FileItemSearch: Decodable {
    let dir: Bool
    let path: String
}

enum SortBy: String, Codable {
    case name
    case modified
    case size
}

struct Sorting: Codable {
    let by: SortBy
    let asc: Bool
}

struct ResourceResponse: Codable {
    let items: [FileItem]

    let numDirs: Int64
    let numFiles: Int64
    let sorting: Sorting

    let path: String
    let name: String
    let size: Int64
    let `extension`: String
    let modified: String
    let mode: Int64
    let isDir: Bool
    let isSymlink: Bool
    let type: String
}

struct UsageInfo: Codable {
    let path: String
    let used: Int64
    let total: Int64
    let free: Int64
}
