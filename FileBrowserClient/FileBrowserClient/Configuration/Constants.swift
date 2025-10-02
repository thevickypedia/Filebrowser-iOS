//
//  Constants.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/17/25.
//

import Foundation

struct Constants {
    // BackgroundLogin
    static let backgroundLoginFrequency: Double = 5.0
    static let backgroundLoginBuffer: Double = 30.0

    // FileListView - Controls:
    // 1. How frequently, the download speed should be updated in the UX in list view
    // 2. Minimum time (in secs) to accumulate the bytes downloaded and estimate the speed
    static let downloadSpeedUpdateInterval: Double = 0.1

    static let uploadCleanupDelay: Int = 2

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

    // Log
    // Maximum number of lines in a log file before the file is appending with an index
    static let maxLinesPerLogFile: Int = 1_000
    static let logFilePrefix: String = "filebrowser"

    // MetricsView
    static let lineChartMaxVisibleCount: Int = 100
    static let lineChartGridLineCount: Int = 4

    // Utils
    // 100 MB preview limit
    static let previewSizeLimit: Int = 100_000_000
    static let dateTimeFormats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX",  // SSSSSS → 6 digits of fractional seconds
        "yyyy-MM-dd'T'HH:mm:ssXXXXX",         // ISO 8601 with timezone
        "yyyy-MM-dd'T'HH:mm:ssZ",             // ISO 8601 with Z
        "yyyy-MM-dd HH:mm:ss",                // Common DB format
        "yyyy/MM/dd HH:mm:ss",
        "MM/dd/yyyy HH:mm:ss",
        "dd-MM-yyyy HH:mm:ss",
        "yyyy-MM-dd",
        "MM/dd/yyyy",
        "dd-MM-yyyy"
    ]

    // Shared
    static let timezone: TimeZone = .current
}
