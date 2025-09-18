//
//  FileBrowserClientApp.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI
import AVFoundation
import MediaPlayer

@main
struct FileBrowserClientApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        // https://emojipedia.org/
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .onAppear {
                    setupGlobalAudioSession()
                    setupAudioSessionNotifications()
                }
        }
    }

    private func setupGlobalAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()

            // Configure for background audio playback
            try audioSession.setCategory(
                .playback,
                mode: .moviePlayback,
                options: [
                    .allowAirPlay,
                    .allowBluetoothA2DP
                ]
            )

            try audioSession.setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            Log.info("🎵 Global audio session configured for background playback")
            Log.info("🔊 Category: \(audioSession.category.rawValue)")
            Log.info("🔊 Mode: \(audioSession.mode.rawValue)")
            Log.info("🔊 Active: \(audioSession.isOtherAudioPlaying ? "Other audio playing" : "None")")

        } catch {
            Log.warn("⚠️ Failed to set up global audio session: \(error)")

            // Fallback: try the most basic setup
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                Log.info("🎵 Basic audio session configured as fallback")
            } catch {
                Log.error("❌ Even basic audio session failed: \(error)")
            }
        }
    }

    private func setupAudioSessionNotifications() {
        // Handle audio session interruptions (calls, other apps, etc.)
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: nil,
            queue: .main
        ) { notification in
            handleAudioSessionInterruption(notification)
        }

        // Handle audio route changes (headphones plugged/unplugged, etc.)
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: nil,
            queue: .main
        ) { notification in
            handleAudioRouteChange(notification)
        }
    }

    private func handleAudioSessionInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        switch type {
        case .began:
            Log.info("🔇 Audio session interruption began")
            // The system automatically pauses audio, but we might want to update UI

        case .ended:
            Log.info("🔊 Audio session interruption ended")

            if let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    Log.info("🎵 Should resume playback after interruption")
                    // We might want to resume playback here or let the user decide
                }
            }

        @unknown default:
            break
        }
    }

    private func handleAudioRouteChange(_ notification: Notification) {
        guard let info = notification.userInfo,
              let reasonValue = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        switch reason {
        case .oldDeviceUnavailable:
            Log.info("🎧 Audio device disconnected (e.g., headphones unplugged)")
            // We might want to pause playback when headphones are unplugged

        case .newDeviceAvailable:
            Log.info("🎧 New audio device connected")

        default:
            Log.info("🔄 Audio route changed: \(reason)")
        }
    }
}
