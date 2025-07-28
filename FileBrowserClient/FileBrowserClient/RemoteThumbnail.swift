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

        let cacheKey = NSString(string: file.path)
        if let cached = ImageCache.shared.object(forKey: cacheKey) {
            self.image = cached
            return
        }

        guard let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return
        }

        guard let url = URL(string: "\(serverURL)/api/preview/thumb/\(encodedPath)?auth=\(token)&inline=true") else {
            return
        }

        isLoading = true

        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                isLoading = false
                guard let data = data, let image = UIImage(data: data) else { return }
                ImageCache.shared.setObject(image, forKey: cacheKey)
                self.image = image
            }
        }.resume()
    }
}
