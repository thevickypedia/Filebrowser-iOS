//
//  FileItem.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//


import Foundation

struct FileItem: Codable, Identifiable {
    var id: String { path }

    let name: String
    let path: String
    let isDir: Bool
    let modified: String?
    let size: Int?
    // optional: add extension later
}
