//
//  MediaPlayerView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/12/25.
//

import SwiftUI
import AVKit
import MediaPlayer

struct ResumePromptData: Identifiable {
    let id = UUID()
    let resumeTime: Double
}

struct MediaPlayerView: View {
    let file: FileItem
    let serverURL: String
    let username: String?
    let token: String
    let displayFullScreen: Bool

    // Display as alerts
    @State private var errorTitle: String?
    @State private var errorMessage: String?

    @State private var player: AVPlayer?
    @State private var isVisible: Bool = false
    @State private var isFullScreen: Bool = false
    @State private var playerItem: AVPlayerItem?
    @State private var timeObserver: Any?
    @State private var npSeeded = false                  // seed only once per item
    @State private var npTitle: String?            // stable title (in memory only)
    @State private var npArtwork: MPMediaItemArtwork?    // stable artwork (in memory only)
    @State private var npBaseInfo: [String: Any] = [:]   // stable Now Playing bas
    @State private var notifTokens: [NSObjectProtocol] = []
    @State private var lastSavedTime: Double = 0
    @State private var resumePromptData: ResumePromptData?
    @State private var pendingPlayer: AVPlayer?
    @State private var pendingItem: AVPlayerItem?

    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea(edges: self.isFullScreen ? .all : [])
                    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
                        // No metadata rebuild; just ensure rate is 0 and time is final
                        self.updateNowPlayingPlaybackState(isPlaying: false)
                        // ⏹ Reset saved playback progress when video ends
                        PlaybackProgressStore.saveProgress(for: createHash(for: file.path), time: 0)
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
            npTitle = file.name
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
                    Log.info("▶️ Resuming playback on background entry")
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
        .sheet(item: $resumePromptData, onDismiss: {
            if player == nil, let pendingPlayer = pendingPlayer, let pendingItem = pendingItem {
                // MARK: Secondary: Fallback to beginning if user closes the sheet without choosing an option
                self.finishPlayerSetup(player: pendingPlayer, item: pendingItem, seekTo: nil)
                self.pendingPlayer = nil
                self.pendingItem = nil
                self.resumePromptData = nil
            }
        }) { data in
            ResumePromptView(
                resumeTimeFormatted: formatTime(data.resumeTime),
                onSelection: { playFromBeginning in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        guard let player = self.pendingPlayer, let item = self.pendingItem else { return }
                        let seekTime = playFromBeginning ? nil : data.resumeTime
                        self.finishPlayerSetup(player: player, item: item, seekTo: seekTime, autoPlay: true)
                        self.pendingPlayer = nil
                        self.pendingItem = nil
                        self.resumePromptData = nil
                    }
                }
            )
            .interactiveDismissDisabled(true) // MARK: Primary: Disable swipe-down dismissal
        }
        .navigationTitle(file.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(self.isFullScreen)
        .modifier(ErrorAlert(title: $errorTitle, message: $errorMessage))
    }

    private func seedNowPlayingIfNeeded() {
        guard let player = player,
              let playerItem = playerItem,
              npSeeded == false else { return }

        var info: [String: Any] = [:]
        info[MPMediaItemPropertyTitle] = npTitle ?? file.name
        info[MPMediaItemPropertyArtist] = "FileBrowser"
        info[MPMediaItemPropertyAlbumTitle] = "Media Files"

        let asset = playerItem.asset
        asset.loadTracks(withMediaType: .video) { tracks, error in
            guard error == nil else { return }

            var info: [String: Any] = [:]
            info[MPMediaItemPropertyTitle] = self.npTitle ?? self.file.name
            info[MPMediaItemPropertyArtist] = "FileBrowser"
            info[MPMediaItemPropertyAlbumTitle] = "Media Files"

            let hasVideo = !(tracks?.isEmpty ?? true)
            info[MPNowPlayingInfoPropertyMediaType] = hasVideo
                ? MPNowPlayingInfoMediaType.video.rawValue
                : MPNowPlayingInfoMediaType.audio.rawValue

            let current = CMTimeGetSeconds(player.currentTime())
            if current.isFinite && !current.isNaN {
                info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = current
            }

            let dur = CMTimeGetSeconds(playerItem.duration)
            if dur.isFinite && !dur.isNaN {
                info[MPMediaItemPropertyPlaybackDuration] = dur
            }

            info[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

            if let art = self.npArtwork {
                info[MPMediaItemPropertyArtwork] = art
            }

            self.npBaseInfo = info
            self.npSeeded = true
            self.publishNowPlaying(forceRate: player.timeControlStatus == .playing ? 1.0 : 0.0)

            if self.npArtwork == nil, let urlAsset = playerItem.asset as? AVURLAsset {
                self.extractArtwork(from: urlAsset) { art in
                    guard let art = art else { return }
                    self.npArtwork = art
                    self.npBaseInfo[MPMediaItemPropertyArtwork] = art
                    self.publishNowPlaying()
                }
            }
        }
    }

    private func publishNowPlaying(forceRate: Double? = nil, overrideElapsed: Double? = nil) {
        guard let player = self.player else { return }

        // Start from our in‑memory base (title/artwork are stable here)
        var info = self.npBaseInfo

        // Elapsed/time
        let elapsed = overrideElapsed ?? CMTimeGetSeconds(player.currentTime())
        if elapsed.isFinite && !elapsed.isNaN {
            info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsed
        }

        // Playback rate
        if let forceRate = forceRate {
            info[MPNowPlayingInfoPropertyPlaybackRate] = forceRate
        } else {
            info[MPNowPlayingInfoPropertyPlaybackRate] = (player.timeControlStatus == .playing) ? 1.0 : 0.0
        }

        // Publish full dict each time to avoid transient UI clears
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    private func registerItemObservers(for item: AVPlayerItem) {
        // Clear previous
        unregisterItemObservers()

        // Time jumped (seek), playback stalled, access log entries → immediately republish full info
        let n1 = NotificationCenter.default.addObserver(forName: .AVPlayerItemTimeJumped, object: item, queue: .main) { _ in
            self.publishNowPlaying()
        }
        let n2 = NotificationCenter.default.addObserver(forName: .AVPlayerItemPlaybackStalled, object: item, queue: .main) { _ in
            self.publishNowPlaying()
        }
        let n3 = NotificationCenter.default.addObserver(forName: .AVPlayerItemNewAccessLogEntry, object: item, queue: .main) { _ in
            self.publishNowPlaying()
        }
        notifTokens = [n1, n2, n3]
    }

    private func unregisterItemObservers() {
        for token in notifTokens {
            NotificationCenter.default.removeObserver(token)
        }
        notifTokens.removeAll()
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
            Log.info("🔇 Audio session interruption began - pausing playback")
            player.pause()

        case .ended:
            Log.info("🔊 Audio session interruption ended")
            if let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    Log.info("🎵 Resuming playback after interruption")
                    player.play()
                }
            }

        @unknown default:
            break
        }
    }

    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
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

            // Load the metadata asynchronously
            Task {
                do {
                    try _ = await asset.load(.duration)
                    try _ = await asset.load(.tracks)

                    let item = AVPlayerItem(asset: asset)
                    let loadedPlayer = AVPlayer(playerItem: item)
                    loadedPlayer.automaticallyWaitsToMinimizeStalling = false

                    let savedTime = await PlaybackProgressStore.loadProgress(for: createHash(for: file.path))

                    DispatchQueue.main.async {
                        self.pendingPlayer = loadedPlayer
                        self.pendingItem = item

                        if let savedTimeTmp = savedTime, savedTimeTmp > 5.0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                self.resumePromptData = ResumePromptData(resumeTime: savedTimeTmp)
                            }
                        } else {
                            self.finishPlayerSetup(player: loadedPlayer, item: item, seekTo: nil)
                        }
                    }
                } catch {
                    Log.error("❌ Failed to load asset metadata: \(error)")
                    DispatchQueue.main.async {
                        errorTitle = "Metadata failed"
                        errorMessage = "Failed to load asset metadata: \(error)"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // MARK: Fallback to a basic player with default AVPlayer
                            let item = AVPlayerItem(asset: asset)
                            self.finishPlayerSetup(player: AVPlayer(url: url), item: item, seekTo: nil, autoPlay: false)
                        }
                    }
                }
            }
        }
    }

    private func finishPlayerSetup(player: AVPlayer, item: AVPlayerItem, seekTo time: Double?, autoPlay: Bool = true) {
        self.playerItem = item
        self.player = player

        self.registerItemObservers(for: item)
        self.setupRemoteTransportControls()
        self.seedNowPlayingIfNeeded()
        self.addPeriodicTimeObserver()

        if let seekTime = time {
            let target = CMTime(seconds: seekTime, preferredTimescale: 1)
            player.seek(to: target) { _ in
                Log.info("⏮ Resumed playback at \(seekTime)s for \(file.name)")
                if autoPlay {
                    player.play()
                }
            }
        } else {
            if autoPlay {
                player.play()
            }
        }
    }

    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        // Remove previous targets to prevent duplicates
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.togglePlayPauseCommand.removeTarget(nil)
        commandCenter.skipForwardCommand.removeTarget(nil)
        commandCenter.skipBackwardCommand.removeTarget(nil)
        commandCenter.changePlaybackPositionCommand.removeTarget(nil)

        // PLAY
        commandCenter.playCommand.addTarget { _ in
            self.publishNowPlaying(forceRate: 1.0)      // publish BEFORE action (no gap)
            self.player?.play()
            self.publishNowPlaying(forceRate: 1.0)      // publish AFTER action
            return .success
        }

        // PAUSE
        commandCenter.pauseCommand.addTarget { _ in
            self.publishNowPlaying(forceRate: 0.0)
            self.player?.pause()
            self.publishNowPlaying(forceRate: 0.0)
            return .success
        }

        // TOGGLE (some UIs send only toggle)
        commandCenter.togglePlayPauseCommand.addTarget { _ in
            guard let player = self.player else { return .commandFailed }
            if player.timeControlStatus == .playing {
                self.publishNowPlaying(forceRate: 0.0)
                player.pause()
                self.publishNowPlaying(forceRate: 0.0)
            } else {
                self.publishNowPlaying(forceRate: 1.0)
                player.play()
                self.publishNowPlaying(forceRate: 1.0)
            }
            return .success
        }

        // SKIP FORWARD 15s
        commandCenter.skipForwardCommand.preferredIntervals = [15]
        commandCenter.skipForwardCommand.addTarget { _ in
            guard let playerLocal = self.player else { return .commandFailed }
            let current = playerLocal.currentTime()
            let target = CMTimeAdd(current, CMTime(seconds: 15, preferredTimescale: 1))
            self.publishNowPlaying(overrideElapsed: CMTimeGetSeconds(target)) // immediately reflect target
            playerLocal.seek(to: target) { _ in
                self.publishNowPlaying(forceRate: playerLocal.timeControlStatus == .playing ? 1.0 : 0.0)
            }
            return .success
        }

        // SKIP BACKWARD 15s
        commandCenter.skipBackwardCommand.preferredIntervals = [15]
        commandCenter.skipBackwardCommand.addTarget { _ in
            guard let playerLocal = self.player else { return .commandFailed }
            let current = playerLocal.currentTime()
            let target = CMTimeSubtract(current, CMTime(seconds: 15, preferredTimescale: 1))
            self.publishNowPlaying(overrideElapsed: CMTimeGetSeconds(target))
            playerLocal.seek(to: target) { _ in
                self.publishNowPlaying(forceRate: playerLocal.timeControlStatus == .playing ? 1.0 : 0.0)
            }
            return .success
        }

        // SCRUB TO POSITION
        commandCenter.changePlaybackPositionCommand.addTarget { event in
            guard let playerLocal = self.player,
                  let eventLocal = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            let target = CMTime(seconds: eventLocal.positionTime, preferredTimescale: 1)
            self.publishNowPlaying(overrideElapsed: eventLocal.positionTime)  // reflect instantly
            playerLocal.seek(to: target) { _ in
                self.publishNowPlaying(forceRate: playerLocal.timeControlStatus == .playing ? 1.0 : 0.0)
            }
            return .success
        }
    }

    private func updateNowPlayingPlaybackState(isPlaying: Bool) {
        publishNowPlaying(forceRate: isPlaying ? 1.0 : 0.0)
    }

    private func setupNowPlayingInfo() {
        // Backward-compat shim — just seed once
        seedNowPlayingIfNeeded()
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

    private func createHash(for path: String) -> String {
        let safeHash = sanitizer("\(serverURL)-\(username ?? "UnknownUser")-\(path)")
        return "PlaybackProgress-\(safeHash)"
    }

    private func addPeriodicTimeObserver() {
        guard let player = player else { return }

        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 1),
            queue: .main
        ) { _ in
            self.updateNowPlayingPlaybackState(isPlaying: player.timeControlStatus == .playing)

            let currentTime = CMTimeGetSeconds(player.currentTime())
            if currentTime.isFinite && !currentTime.isNaN {
                // Save every 5 seconds
                if lastSavedTime == 0 || currentTime - lastSavedTime >= 5 {
                    lastSavedTime = currentTime
                    PlaybackProgressStore.saveProgress(for: createHash(for: file.path), time: currentTime)
                }
            }

            // If duration was unknown at seed time, fill it in once it becomes finite.
            if let item = self.playerItem {
                let dur = CMTimeGetSeconds(item.duration)
                if dur.isFinite && !dur.isNaN && self.npBaseInfo[MPMediaItemPropertyPlaybackDuration] == nil {
                    self.npBaseInfo[MPMediaItemPropertyPlaybackDuration] = dur
                    // Re-publish full dict to make lock screen show proper time instead of -:--
                    var full = self.npBaseInfo
                    full[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
                    full[MPNowPlayingInfoPropertyPlaybackRate] = player.timeControlStatus == .playing ? 1.0 : 0.0
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = full
                }
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
        unregisterItemObservers()
        player = nil
        playerItem = nil

        npSeeded = false
        npTitle = nil
        npArtwork = nil
        npBaseInfo = [:]

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
