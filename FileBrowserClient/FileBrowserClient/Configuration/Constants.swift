//
//  Constants.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/17/25.
//

import Foundation

struct Constants {
    // FileListView - Controls:
    // 1. How frequently, the download speed should be updated in the UX in list view
    // 2. Minimum time (in secs) to accumulate the bytes downloaded and estimate the speed
    static let downloadSpeedUpdateInterval: Double = 0.1

    // RemoteThumbnail:
    // Maximum number of thumbnails to render
    static let maxConcurrentThumbnailRender: Int = 4
    static let thumbnailQuality: CGFloat = 0.1
    static let thumbnailRetryLimit: Int = 5

    // MediaPlayerView:
    // Minimum duration (in secs) of a video to be considered resume worthy
    static let minMediaResumePrompt: Double = 60.0
    // Controls:
    // 1. How frequently the timestamp should be stored for a video
    // 2. Minimum time (in secs) before a video can be considered resume-able
    static let mediaResumeThreshold: Double = 5.0

    // PhotoPicker:
    // Maximum number of tasks that copy files to temp directory before upload
    static let maxUploadStagingLimit: Int = 5
}
