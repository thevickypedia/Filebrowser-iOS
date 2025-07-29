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

    var body: some View {
        Group {
            if let image = image {
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

        // Step 1: Load from memory or disk
        if let cached = ThumbnailCache.shared.image(for: file.path, modified: file.modified) {
            self.image = cached
            return
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
                guard let data = data, let img = UIImage(data: data) else { return }
                ThumbnailCache.shared.store(image: img, for: file.path, modified: file.modified)
                self.image = img
            }
        }.resume()
    }
}
