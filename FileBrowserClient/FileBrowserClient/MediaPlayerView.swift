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
    @State private var player: AVPlayer

    init(file: FileItem, serverURL: String, token: String) {
        self.file = file
        self.token = token
        self.serverURL = serverURL
        let path = file.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let url = URL(string: "\(serverURL)/api/raw/\(removePrefix(urlPath: path))?auth=\(token)")!
        self._player = State(initialValue: AVPlayer(url: url))
    }

    var body: some View {
        VideoPlayer(player: player)
            .navigationTitle(file.name)
            .onAppear {
                // Keep player paused until played manually
                player.pause()
            }
            .onDisappear {
                player.pause()
                player.replaceCurrentItem(with: nil)
            }
    }
}
