//
//  PlaybackProgressStore.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/10/25.
//

import Foundation

struct PlaybackProgressStore {
    static func saveProgress(for path: String, time: Double) {
        UserDefaults.standard.set(time, forKey: "PlaybackProgress_\(path)")
    }

    static func loadProgress(for path: String) -> Double? {
        return UserDefaults.standard.double(forKey: "PlaybackProgress_\(path)")
    }
}
