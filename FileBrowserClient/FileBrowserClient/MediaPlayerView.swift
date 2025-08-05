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
    @State private var player: AVPlayer? = nil

    var body: some View {
        Group {
            if let player = player {
                VideoPlayer(player: player)
            } else {
                ProgressView("Loading video...")
            }
        }
        .onAppear {
            if player == nil {
                let path = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
                if let url = URL(string: "\(serverURL)/api/raw/\(removePrefix(urlPath: path))?auth=\(token)") {
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
        .onDisappear {
            player?.pause()
            player?.replaceCurrentItem(with: nil)
            player = nil
        }
        .navigationTitle(file.name)
    }
}
