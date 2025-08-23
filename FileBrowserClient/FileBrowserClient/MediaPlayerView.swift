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
    let displayFullScreen: Bool
    @State private var player: AVPlayer?
    @State private var isVisible: Bool = false
    @State private var isFullScreen: Bool = false

    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea(edges: self.isFullScreen ? .all : [])
            } else {
                ProgressView("Loading media player...")
            }

            // Fullscreen toggle
            if displayFullScreen {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { self.isFullScreen.toggle() }) {
                            Image(systemName: self.isFullScreen
                                  ? "arrow.down.right.and.arrow.up.left"
                                  : "arrow.up.left.and.arrow.down.right")
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                        }
                    }
                    .padding()
                    Spacer()
                }
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
        .navigationBarHidden(self.isFullScreen)
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
