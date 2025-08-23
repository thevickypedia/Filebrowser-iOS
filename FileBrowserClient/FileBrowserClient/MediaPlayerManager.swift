//
//  MediaPlayerManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/23/25.
//

import Foundation
import AVKit
import MediaPlayer

extension CMTime {
    var isValidAndNumeric: Bool { isNumeric && flags.contains(.valid) }
}

class MediaPlayerManager: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isFullscreen: Bool = false
    private var timeObserverToken: Any?

    private func setupNowPlaying(title: String, duration: CMTime) {
        var info: [String: Any] = [:]
        info[MPMediaItemPropertyTitle] = title

        if duration.isValidAndNumeric {
            info[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(duration)
        }

        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0
        info[MPNowPlayingInfoPropertyPlaybackRate] = 0.0 // ✅ start paused
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info

        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true

        commandCenter.playCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            self.player?.play()
            self.updateNowPlaying(isPlaying: true)
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            self.player?.pause()
            self.updateNowPlaying(isPlaying: false)
            return .success
        }
    }

    private func updateNowPlaying(isPlaying: Bool) {
        guard var info = MPNowPlayingInfoCenter.default().nowPlayingInfo else { return }
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime().seconds ?? 0
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    func load(url: URL, title: String = "Unknown Title") {
        stop()
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: item)

        item.observe(\.status, options: [.new]) { item, _ in
            if item.status == .readyToPlay {
                print("✅ Player item ready")
                self.setupNowPlaying(title: title, duration: item.asset.duration)
            }
        }

        // 🔑 add periodic observer to update elapsed time
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1),
                                                            queue: .main) { [weak self] time in
            guard let self else { return }
            var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
            info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(time)
            info[MPNowPlayingInfoPropertyPlaybackRate] = self.player?.rate ?? 0
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }

        player?.pause()
    }

    func stop() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        player?.pause()
        player = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}
