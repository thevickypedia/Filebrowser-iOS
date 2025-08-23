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
    @EnvironmentObject var mediaManager: MediaPlayerManager

    var body: some View {
        ZStack {
            if let player = mediaManager.player {
                VideoPlayer(player: player)
                    .ignoresSafeArea(edges: mediaManager.isFullscreen ? .all : [])
            } else {
                ProgressView("Loading media player...")
            }

            // Fullscreen toggle
            VStack {
                HStack {
                    Spacer()
                    Button(action: { mediaManager.isFullscreen.toggle() }) {
                        Image(systemName: mediaManager.isFullscreen
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
        .onAppear {
            if let url = buildAPIURL(
                base: serverURL,
                pathComponents: ["api", "raw", file.path],
                queryItems: [ URLQueryItem(name: "auth", value: token) ]
            ) {
                mediaManager.load(url: url, title: file.name)
            }
        }
        .onDisappear {
            mediaManager.stop() // ✅ stop playback when leaving video
        }
        .navigationBarHidden(mediaManager.isFullscreen)
    }
}
