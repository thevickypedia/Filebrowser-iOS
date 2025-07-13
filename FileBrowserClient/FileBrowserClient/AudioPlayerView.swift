//
//  AudioPlayerView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/12/25.
//


import SwiftUI
import AVKit

struct AudioPlayerView: View {
    let file: FileItem
    let serverURL: String
    let token: String

    @State private var player: AVPlayer?

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: 60) // Audio-only layout
            } else {
                ProgressView("Loading audio...")
            }
        }
        .navigationTitle(file.name)
        .onAppear {
            player = AVPlayer(url: audioURL)
            player?.play()
        }
    }

    private var audioURL: URL {
        let encodedPath = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? file.path
        let fullURL = "\(serverURL)/api/raw/\(encodedPath)?auth=\(token)&inline=true"
        return URL(string: fullURL)!
    }
}
