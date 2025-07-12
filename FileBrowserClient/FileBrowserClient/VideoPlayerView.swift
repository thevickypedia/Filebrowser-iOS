//
//  VideoPlayerView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/12/25.
//


import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let file: FileItem
    let serverURL: String
    let token: String

    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .navigationTitle(file.name)
            .onAppear {
                AVPlayer(url: videoURL).play()
            }
    }

    private var videoURL: URL {
        let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? file.path
        let fullURL = "\(serverURL)/api/raw/\(encodedPath)?auth=\(token)&inline=true"
        return URL(string: fullURL)!
    }
}
