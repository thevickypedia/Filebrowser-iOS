//
//  MediaPlayerView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/12/25.
//

import SwiftUI
import AVKit
import MediaPlayer

struct MediaPlayerView: View {
    let file: FileItem
    let serverURL: String
    let token: String
    let displayFullScreen: Bool
    @State private var player: AVPlayer?
    @State private var isVisible: Bool = false
    @State private var isFullScreen: Bool = false
    @State private var playerItem: AVPlayerItem?
    @State private var timeObserver: Any?

    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea(edges: self.isFullScreen ? .all : [])
                    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
                        // Handle playback completion
                        setupNowPlayingInfo()
                    }
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
            setupRemoteTransportControls()
            NotificationCenter.default.addObserver(
                forName: UIApplication.didEnterBackgroundNotification,
                object: nil,
                queue: .main
            ) { _ in
                if let player = player, player.timeControlStatus != .playing {
                    print("▶️ Resuming playback on background entry")
                    player.play()
                    self.updateNowPlayingPlaybackState(isPlaying: player.timeControlStatus == .playing)
                }
            }
            NotificationCenter.default.addObserver(
                forName: AVAudioSession.interruptionNotification,
                object: nil,
                queue: .main
            ) { notification in
                handleAudioSessionInterruption(notification)
            }
        }
        .onDisappear {
            isVisible = false
            cleanupPlayer()
            clearNowPlayingInfo()
        }
        .navigationTitle(file.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(self.isFullScreen)
    }

    private func handleAudioSessionInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue),
              let player = player else {
            return
        }

        switch type {
        case .began:
            print("🔇 Audio session interruption began - pausing playback")
            player.pause()

        case .ended:
            print("🔊 Audio session interruption ended")
            if let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    print("🎵 Resuming playback after interruption")
                    player.play()
                }
            }

        @unknown default:
            break
        }
    }

    func loadPlayer() {
        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "raw", file.path],
            queryItems: [URLQueryItem(name: "auth", value: token)]
        ) else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVURLAsset(url: url)
            let item = AVPlayerItem(asset: asset)
            let loadedPlayer = AVPlayer(playerItem: item)
            loadedPlayer.automaticallyWaitsToMinimizeStalling = false

            DispatchQueue.main.async {
                self.playerItem = item
                self.player = loadedPlayer

                self.setupRemoteTransportControls()   // <-- rebind targets now that player exists

                // Setup Now Playing info
                setupNowPlayingInfo()

                // Add time observer for updating Now Playing info
                addPeriodicTimeObserver()

                // Auto-pause initially
                loadedPlayer.pause()
            }
        }
    }

    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        // Remove previous targets to prevent duplicates
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.skipForwardCommand.removeTarget(nil)
        commandCenter.skipBackwardCommand.removeTarget(nil)
        commandCenter.changePlaybackPositionCommand.removeTarget(nil)

        // Play
        commandCenter.playCommand.addTarget { _ in
            guard let player = self.player else { return .commandFailed }
            player.play()
            self.updateNowPlayingPlaybackState(isPlaying: true)
            return .success
        }

        // Pause
        commandCenter.pauseCommand.addTarget { _ in
            guard let player = self.player else { return .commandFailed }
            player.pause()
            self.updateNowPlayingPlaybackState(isPlaying: false)
            return .success
        }

        // Skip forward 15s
        commandCenter.skipForwardCommand.addTarget { _ in
            guard let player = self.player else { return .commandFailed }
            let current = player.currentTime()
            let newTime = CMTimeAdd(current, CMTime(seconds: 15, preferredTimescale: 1))
            player.seek(to: newTime) { _ in
                self.updateNowPlayingPlaybackState(isPlaying: player.timeControlStatus == .playing)
            }
            return .success
        }

        // Skip back 15s
        commandCenter.skipBackwardCommand.addTarget { _ in
            guard let player = self.player else { return .commandFailed }
            let current = player.currentTime()
            let newTime = CMTimeSubtract(current, CMTime(seconds: 15, preferredTimescale: 1))
            player.seek(to: newTime) { _ in
                self.updateNowPlayingPlaybackState(isPlaying: player.timeControlStatus == .playing)
            }
            return .success
        }

        // Scrub to position
        commandCenter.changePlaybackPositionCommand.addTarget { event in
            guard let player = self.player,
                  let e = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            let time = CMTime(seconds: e.positionTime, preferredTimescale: 1)
            player.seek(to: time) { _ in
                self.updateNowPlayingPlaybackState(isPlaying: player.timeControlStatus == .playing)
            }
            return .success
        }

        // Configure skip intervals
        commandCenter.skipForwardCommand.preferredIntervals = [15]
        commandCenter.skipBackwardCommand.preferredIntervals = [15]
    }

    private func updateNowPlayingPlaybackState(isPlaying: Bool) {
        guard let player = self.player else { return }
        var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    private func setupNowPlayingInfo() {
        guard let player = player,
              let playerItem = playerItem else { return }

        var nowPlayingInfo = [String: Any]()

        // Basic metadata
        nowPlayingInfo[MPMediaItemPropertyTitle] = file.name
        nowPlayingInfo[MPMediaItemPropertyArtist] = "FileBrowser"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "Media Files"

        // Playback info
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(playerItem.duration)

        if duration.isFinite && !duration.isNaN {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        }

        if currentTime.isFinite && !currentTime.isNaN {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        }

        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        // Try to extract artwork for video files
        if let asset = playerItem.asset as? AVURLAsset {
            extractArtwork(from: asset) { artwork in
                DispatchQueue.main.async {
                    if let artwork = artwork {
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                    }
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                }
            }
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }

    private func extractArtwork(from asset: AVURLAsset, completion: @escaping (MPMediaItemArtwork?) -> Void) {
        // For video files, try to generate a thumbnail
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 400, height: 400)

        let time = CMTime(seconds: 1, preferredTimescale: 1) // Get frame at 1 second

        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, result, _ in
            if let cgImage = cgImage, result == .succeeded {
                let uiImage = UIImage(cgImage: cgImage)
                let artwork = MPMediaItemArtwork(boundsSize: uiImage.size) { _ in uiImage }
                completion(artwork)
            } else {
                // For audio files or if video thumbnail fails, use a default icon
                self.createDefaultArtwork { defaultArtwork in
                    completion(defaultArtwork)
                }
            }
        }
    }

    private func createDefaultArtwork(completion: @escaping (MPMediaItemArtwork?) -> Void) {
        // Create a simple default artwork
        let size = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        // Draw a simple background
        UIColor.systemBlue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        // Add a play icon
        let playIcon = UIImage(systemName: "play.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let iconSize: CGFloat = 80
        let iconRect = CGRect(
            x: (size.width - iconSize) / 2,
            y: (size.height - iconSize) / 2,
            width: iconSize,
            height: iconSize
        )
        playIcon?.draw(in: iconRect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            completion(artwork)
        } else {
            completion(nil)
        }
    }

    private func addPeriodicTimeObserver() {
        guard let player = player else { return }

        // Remove existing observer
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }

        // Add new observer that updates every second
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 1),
            queue: .main
        ) { _ in
            // Update Now Playing info periodically
            DispatchQueue.main.async {
                self.setupNowPlayingInfo()
            }
        }
    }

    private func cleanupPlayer() {
        // Remove time observer
        if let timeObserver = timeObserver, let player = player {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }

        // Pause and cleanup player
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        playerItem = nil

        // Clear remote control targets
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.skipForwardCommand.removeTarget(nil)
        commandCenter.skipBackwardCommand.removeTarget(nil)
        commandCenter.changePlaybackPositionCommand.removeTarget(nil)
    }

    private func clearNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}
