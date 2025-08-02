//
//  RemoteThumbnail.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/28/25.
//

import SwiftUI

struct RemoteThumbnail: View {
    let file: FileItem
    let serverURL: String
    let token: String

    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var gifData: Data?

    var body: some View {
        Group {
            if let gifData = gifData {
                AnimatedImageView(data: gifData)
                    .frame(width: 32, height: 32)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            } else if isLoading {
                ProgressView()
                    .frame(width: 32, height: 32)
            } else {
                Color.clear
                    .frame(width: 32, height: 32)
                    .onAppear {
                    loadThumbnail()
                }
            }
        }
    }

    func loadThumbnail() {
        guard image == nil else { return }
        let existingCache = FileCache.shared.data(
            for: file.path,
            modified: file.modified,
            fileID: "thumb_\(file.extension ?? "unknown")"
        )

        // Step 1: Load from memory or disk
        if file.name.lowercased().hasSuffix(".gif") {
            if let cached = existingCache {
                self.gifData = cached
                return
            }
        } else {
            if let cached = existingCache,
               let image = UIImage(data: cached) {
                self.image = image
                return
            }
        }

        // Step 2: Build URL
        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(serverURL)/api/preview/thumb/\(encodedPath)?auth=\(token)&inline=true") else {
            return
        }

        isLoading = true

        // Step 3: Fetch and store
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.isLoading = false
                guard let data = data else { return }
                FileCache.shared.store(data: data, for: file.path, modified: file.modified, fileID: "thumb")
                if file.name.lowercased().hasSuffix(".gif") {
                    self.gifData = data
                } else if let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }.resume()
    }
}
