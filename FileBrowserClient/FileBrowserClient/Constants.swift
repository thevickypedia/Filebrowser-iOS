//
//  Constants.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/17/25.
//

struct Constants {
    // FileListView - Controls:
    // 1. How frequently, the download speed should be updated in the UX in list view
    // 2. Minimum time (in secs) to accumulate the bytes downloaded and estimate the speed
    static var downloadSpeedUpdateInterval: Double = 0.1

    // RemoteThumbnail: Maximum number of thumbnails to render
    static var maxConcurrentThumbnailRender: Int = 4

    // FileListView: Time (in secs) to display the preparing uploading spinner
    // TODO: Find a better way to implement this (look into PhotoPicker module)
    static var preparingUploadResetDuration: Int = 10

    // MediaPlayerView: Minimum duration (in secs) of a video to be considered resume worthy
    static var minMediaResumePrompt: Double = 60.0

    // MediaPlayerView - Controls:
    // 1. How frequently the timestamp should be stored for a video
    // 2. Minimum time (in secs) before a video can be considered resume-able
    static var mediaResumeThreshold: Double = 5.0
}
