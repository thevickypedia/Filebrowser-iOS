//
//  Constants.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/17/25.
//

import Foundation

class DefaultConstants {
    // ContentView
    static let maxKnownServers: Int = 5

    // BackgroundLogin
    static let backgroundLoginFrequency: Double = 5.0
    static let backgroundLoginBuffer: Double = 30.0

    // FileListView - Controls:
    // 1. How frequently, the download speed should be updated in the UX in list view
    // 2. Minimum time (in secs) to accumulate the bytes downloaded and estimate the speed
    static let downloadSpeedUpdateInterval: Double = 0.1
    // Only render first 100 items initially
    static let filesDisplayLimit: Int = 100

    static let uploadCleanupDelay: Int = 2

    static let searchRequestTimeout: Double = 30.0
    static let searchResourceTimeout: Double = 45.0

    // Request:
    static let defaultRequestTimeout: Double = 3.0
    static let defaultResourceTimeout: Double = 5.0

    // RemoteThumbnail:
    // Maximum number of thumbnails to render
    static let maxConcurrentThumbnailRender: Int = 4
    static let thumbnailQuality: CGFloat = 0.1
    static let thumbnailRetryLimit: Int = 10
    static let thumbnailResourceTimeout: Double = 10.0
    static let thumbnailRequestTimeout: Double = 60.0
    static let maxThumbnailSize: CGFloat = 320
    // 10 MB is the max GIF filesize that can be rendered as a thumbnail
    static let maxGIFThumbnailBytes: Int = 10_000_000

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
}

struct Constants {
    // ContentView
    static var maxKnownServers: Int = DefaultConstants.maxKnownServers

    // BackgroundLogin
    static var backgroundLoginFrequency: Double = DefaultConstants.backgroundLoginFrequency
    static var backgroundLoginBuffer: Double = DefaultConstants.backgroundLoginBuffer

    // FileListView - Controls:
    // 1. How frequently, the download speed should be updated in the UX in list view
    // 2. Minimum time (in secs) to accumulate the bytes downloaded and estimate the speed
    static var downloadSpeedUpdateInterval: Double = DefaultConstants.downloadSpeedUpdateInterval
    // Only render first 100 items initially
    static var filesDisplayLimit: Int = DefaultConstants.filesDisplayLimit

    static var uploadCleanupDelay: Int = DefaultConstants.uploadCleanupDelay

    static var searchRequestTimeout: Double = DefaultConstants.searchRequestTimeout
    static var searchResourceTimeout: Double = DefaultConstants.searchResourceTimeout

    // Request:
    static var defaultRequestTimeout: Double = DefaultConstants.defaultRequestTimeout
    static var defaultResourceTimeout: Double = DefaultConstants.defaultResourceTimeout

    // RemoteThumbnail:
    // Maximum number of thumbnails to render
    static var maxConcurrentThumbnailRender: Int = DefaultConstants.maxConcurrentThumbnailRender
    static var thumbnailQuality: CGFloat = DefaultConstants.thumbnailQuality
    static var thumbnailRetryLimit: Int = DefaultConstants.thumbnailRetryLimit
    static var thumbnailResourceTimeout: Double = DefaultConstants.thumbnailResourceTimeout
    static var thumbnailRequestTimeout: Double = DefaultConstants.thumbnailRequestTimeout
    static var maxThumbnailSize: CGFloat = DefaultConstants.maxThumbnailSize
    // 10 MB is the max GIF filesize that can be rendered as a thumbnail
    static var maxGIFThumbnailBytes: Int = DefaultConstants.maxGIFThumbnailBytes

    // MediaPlayerView:
    // Minimum duration (in secs) of a video to be considered resume worthy
    static var minMediaResumePrompt: Double = DefaultConstants.minMediaResumePrompt
    // Controls:
    // 1. How frequently the timestamp should be stored for a video
    // 2. Minimum time (in secs) before a video can be considered resume-able
    static var mediaResumeThreshold: Double = DefaultConstants.mediaResumeThreshold

    // PhotoPicker:
    // Maximum number of tasks that copy files to temp directory before upload
    static var maxUploadStagingLimit: Int = DefaultConstants.maxUploadStagingLimit

    // Log
    // Maximum number of lines in a log file before the file is appending with an index
    static var maxLinesPerLogFile: Int = DefaultConstants.maxLinesPerLogFile
    static var logFilePrefix: String = DefaultConstants.logFilePrefix

    // MetricsView
    static var lineChartMaxVisibleCount: Int = DefaultConstants.lineChartMaxVisibleCount
    static var lineChartGridLineCount: Int = DefaultConstants.lineChartGridLineCount

    // Utils
    // 100 MB preview limit
    static var previewSizeLimit: Int = DefaultConstants.previewSizeLimit
    // Hardcoded constants
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
