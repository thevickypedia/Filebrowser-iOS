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

struct ResourceResponse: Codable {
    let items: [FileItem]
}
