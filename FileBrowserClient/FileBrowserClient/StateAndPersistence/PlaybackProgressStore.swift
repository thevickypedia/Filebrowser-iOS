//
//  PlaybackProgressStore.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/10/25.
//

import Foundation

struct PlaybackProgressStore {
    static func saveProgress(for hash: String, time: Double) {
        Log.debug("Storing play back progress with hash: \(hash)")
        UserDefaults.standard.set(time, forKey: hash)
    }

    static func loadProgress(for hash: String) -> Double? {
        Log.debug("Loading play back progress with hash: \(hash)")
        return UserDefaults.standard.double(forKey: hash)
    }
}
