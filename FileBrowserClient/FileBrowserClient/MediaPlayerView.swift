//
//  MediaPlayerView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/12/25.
//

import SwiftUI
import AVKit

struct MediaPlayerView: View {
    let file: FileItem
    let serverURL: String
    let token: String
    @State private var player: AVPlayer?
    @State private var isVisible = false

    var body: some View {
        Group {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea() // ✅ Fullscreen under status/nav bar
            } else {
                ProgressView("Loading media player...")
            }
        }
        .onAppear {
            isVisible = true
            if player == nil && isVisible {
                loadPlayer()
            }
        }
        .onDisappear {
            isVisible = false
            player?.pause()
            player?.replaceCurrentItem(with: nil)
            player = nil
        }
        .navigationTitle(file.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    func loadPlayer() {
        if let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "raw", file.path],
            queryItems: [ URLQueryItem(name: "auth", value: token) ]
        ) {
            DispatchQueue.global(qos: .userInitiated).async {
                let asset = AVURLAsset(url: url)
                let item = AVPlayerItem(asset: asset)
                let loadedPlayer = AVPlayer(playerItem: item)
                DispatchQueue.main.async {
                    self.player = loadedPlayer
                    loadedPlayer.pause()
                }
            }
        }
    }
}
