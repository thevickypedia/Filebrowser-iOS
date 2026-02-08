//
//  DeviceSettingsView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 2/8/26.
//

import SwiftUI

struct DeviceSettingsView: View {

    // MARK: - Local editable state

    @State private var maxKnownServers = Constants.maxKnownServers

    @State private var backgroundLoginFrequency = Constants.backgroundLoginFrequency
    @State private var backgroundLoginBuffer = Constants.backgroundLoginBuffer

    @State private var downloadSpeedUpdateInterval = Constants.downloadSpeedUpdateInterval
    @State private var filesDisplayLimit = Constants.filesDisplayLimit
    @State private var uploadCleanupDelay = Constants.uploadCleanupDelay

    @State private var searchRequestTimeout = Constants.searchRequestTimeout
    @State private var searchResourceTimeout = Constants.searchResourceTimeout

    @State private var defaultRequestTimeout = Constants.defaultRequestTimeout
    @State private var defaultResourceTimeout = Constants.defaultResourceTimeout

    @State private var maxConcurrentThumbnailRender = Constants.maxConcurrentThumbnailRender
    @State private var thumbnailQuality = Constants.thumbnailQuality
    @State private var thumbnailRetryLimit = Constants.thumbnailRetryLimit
    @State private var thumbnailResourceTimeout = Constants.thumbnailResourceTimeout
    @State private var thumbnailRequestTimeout = Constants.thumbnailRequestTimeout
    @State private var maxThumbnailSize = Constants.maxThumbnailSize
    @State private var maxGIFThumbnailBytes = Constants.maxGIFThumbnailBytes

    @State private var minMediaResumePrompt = Constants.minMediaResumePrompt
    @State private var mediaResumeThreshold = Constants.mediaResumeThreshold

    @State private var maxUploadStagingLimit = Constants.maxUploadStagingLimit

    @State private var maxLinesPerLogFile = Constants.maxLinesPerLogFile

    @State private var lineChartMaxVisibleCount = Constants.lineChartMaxVisibleCount
    @State private var lineChartGridLineCount = Constants.lineChartGridLineCount

    @State private var previewSizeLimit = Constants.previewSizeLimit

    @State private var deviceSettingsMessage: ToastMessagePayload?

    // MARK: - View

    var body: some View {
        Form {

            // ContentView
            Section(header: Text("ContentView")) {
                Stepper("Max Known Servers: \(maxKnownServers)",
                        value: $maxKnownServers,
                        in: 1...50)
            }

            // BackgroundLogin
            Section(header: Text("Background Login")) {
                Stepper("Login Frequency: \(backgroundLoginFrequency, specifier: "%.1f")s",
                        value: $backgroundLoginFrequency,
                        in: 1...60)

                Stepper("Login Buffer: \(backgroundLoginBuffer, specifier: "%.0f")s",
                        value: $backgroundLoginBuffer,
                        in: 0...120,
                        step: 5)
            }

            // FileListView
            Section(header: Text("File List View")) {
                Stepper("Speed Update Interval: \(downloadSpeedUpdateInterval, specifier: "%.2f")s",
                        value: $downloadSpeedUpdateInterval,
                        in: 0.05...2.0,
                        step: 0.05)

                Stepper("Files Display Limit: \(filesDisplayLimit)",
                        value: $filesDisplayLimit,
                        in: 10...2000,
                        step: 50)
            }

            Section {
                Stepper("Upload Cleanup Delay: \(uploadCleanupDelay)s",
                        value: $uploadCleanupDelay,
                        in: 0...30)
            }

            // Search
            Section(header: Text("Search")) {
                Stepper("Request Timeout: \(searchRequestTimeout, specifier: "%.0f")s",
                        value: $searchRequestTimeout,
                        in: 5...120,
                        step: 5)

                Stepper("Resource Timeout: \(searchResourceTimeout, specifier: "%.0f")s",
                        value: $searchResourceTimeout,
                        in: 5...180,
                        step: 5)
            }

            // Request
            Section(header: Text("Network Request")) {
                Stepper("Default Request Timeout: \(defaultRequestTimeout, specifier: "%.1f")s",
                        value: $defaultRequestTimeout,
                        in: 1...30,
                        step: 0.5)

                Stepper("Default Resource Timeout: \(defaultResourceTimeout, specifier: "%.1f")s",
                        value: $defaultResourceTimeout,
                        in: 1...60)
            }

            // RemoteThumbnail
            Section(header: Text("Remote Thumbnails")) {
                Stepper("Max Concurrent Renders: \(maxConcurrentThumbnailRender)",
                        value: $maxConcurrentThumbnailRender,
                        in: 1...10)

                Slider(value: $thumbnailQuality, in: 0.05...1.0)
                Text("Quality: \(thumbnailQuality, specifier: "%.2f")")

                Stepper("Retry Limit: \(thumbnailRetryLimit)",
                        value: $thumbnailRetryLimit,
                        in: 0...20)

                Stepper("Resource Timeout: \(thumbnailResourceTimeout, specifier: "%.0f")s",
                        value: $thumbnailResourceTimeout,
                        in: 5...120,
                        step: 5)

                Stepper("Request Timeout: \(thumbnailRequestTimeout, specifier: "%.0f")s",
                        value: $thumbnailRequestTimeout,
                        in: 10...300,
                        step: 10)

                Stepper("Max Thumbnail Size: \(Int(maxThumbnailSize))",
                        value: Binding(
                            get: { Int(maxThumbnailSize) },
                            set: { maxThumbnailSize = CGFloat($0) }
                        ),
                        in: 64...1024,
                        step: 32)

                Stepper("Max GIF Size: \(maxGIFThumbnailBytes / 1_000_000) MB",
                        value: $maxGIFThumbnailBytes,
                        in: 1_000_000...50_000_000,
                        step: 1_000_000)
            }

            // MediaPlayerView
            Section(header: Text("Media Player")) {
                Stepper("Min Resume Prompt: \(minMediaResumePrompt, specifier: "%.0f")s",
                        value: $minMediaResumePrompt,
                        in: 10...600,
                        step: 10)

                Stepper("Resume Threshold: \(mediaResumeThreshold, specifier: "%.1f")s",
                        value: $mediaResumeThreshold,
                        in: 1...30)
            }

            // PhotoPicker
            Section(header: Text("Photo Picker")) {
                Stepper("Max Upload Staging: \(maxUploadStagingLimit)",
                        value: $maxUploadStagingLimit,
                        in: 1...20)
            }

            // Log
            Section(header: Text("Logging")) {
                Stepper("Max Lines Per File: \(maxLinesPerLogFile)",
                        value: $maxLinesPerLogFile,
                        in: 100...10_000,
                        step: 100)
            }

            // MetricsView
            Section(header: Text("Metrics View")) {
                Stepper("Max Visible Points: \(lineChartMaxVisibleCount)",
                        value: $lineChartMaxVisibleCount,
                        in: 10...500,
                        step: 10)

                Stepper("Grid Line Count: \(lineChartGridLineCount)",
                        value: $lineChartGridLineCount,
                        in: 1...10)
            }

            // Utils
            Section(header: Text("Utils")) {
                Stepper("Preview Size Limit: \(previewSizeLimit / 1_000_000) MB",
                        value: $previewSizeLimit,
                        in: 10_000_000...1_000_000_000,
                        step: 10_000_000)
            }

            // Actions
            Section {
                Button("Save Settings", action: {
                    save()
                    deviceSettingsMessage = ToastMessagePayload(text: "⚙️ Settings Updated", color: .green, duration: 3.5)
                })
                    .fontWeight(.semibold)

                Button("Reset to Default Settings", action: {
                    reset()
                    deviceSettingsMessage = ToastMessagePayload(text: "⚙️ Settings Reset", color: .yellow, duration: 3.5)
                })
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Device Settings")
        .modifier(ToastMessage(payload: $deviceSettingsMessage))
    }

    // MARK: - Actions
    private func save() {
        Constants.maxKnownServers = maxKnownServers

        Constants.backgroundLoginFrequency = backgroundLoginFrequency
        Constants.backgroundLoginBuffer = backgroundLoginBuffer

        Constants.downloadSpeedUpdateInterval = downloadSpeedUpdateInterval
        Constants.filesDisplayLimit = filesDisplayLimit
        Constants.uploadCleanupDelay = uploadCleanupDelay

        Constants.searchRequestTimeout = searchRequestTimeout
        Constants.searchResourceTimeout = searchResourceTimeout

        Constants.defaultRequestTimeout = defaultRequestTimeout
        Constants.defaultResourceTimeout = defaultResourceTimeout

        Constants.maxConcurrentThumbnailRender = maxConcurrentThumbnailRender
        Constants.thumbnailQuality = thumbnailQuality
        Constants.thumbnailRetryLimit = thumbnailRetryLimit
        Constants.thumbnailResourceTimeout = thumbnailResourceTimeout
        Constants.thumbnailRequestTimeout = thumbnailRequestTimeout
        Constants.maxThumbnailSize = maxThumbnailSize
        Constants.maxGIFThumbnailBytes = maxGIFThumbnailBytes

        Constants.minMediaResumePrompt = minMediaResumePrompt
        Constants.mediaResumeThreshold = mediaResumeThreshold

        Constants.maxUploadStagingLimit = maxUploadStagingLimit

        Constants.maxLinesPerLogFile = maxLinesPerLogFile

        Constants.lineChartMaxVisibleCount = lineChartMaxVisibleCount
        Constants.lineChartGridLineCount = lineChartGridLineCount

        Constants.previewSizeLimit = previewSizeLimit
    }

    private func reset() {
        maxKnownServers = DefaultConstants.maxKnownServers

        backgroundLoginFrequency = DefaultConstants.backgroundLoginFrequency
        backgroundLoginBuffer = DefaultConstants.backgroundLoginBuffer

        downloadSpeedUpdateInterval = DefaultConstants.downloadSpeedUpdateInterval
        filesDisplayLimit = DefaultConstants.filesDisplayLimit
        uploadCleanupDelay = DefaultConstants.uploadCleanupDelay

        searchRequestTimeout = DefaultConstants.searchRequestTimeout
        searchResourceTimeout = DefaultConstants.searchResourceTimeout

        defaultRequestTimeout = DefaultConstants.defaultRequestTimeout
        defaultResourceTimeout = DefaultConstants.defaultResourceTimeout

        maxConcurrentThumbnailRender = DefaultConstants.maxConcurrentThumbnailRender
        thumbnailQuality = DefaultConstants.thumbnailQuality
        thumbnailRetryLimit = DefaultConstants.thumbnailRetryLimit
        thumbnailResourceTimeout = DefaultConstants.thumbnailResourceTimeout
        thumbnailRequestTimeout = DefaultConstants.thumbnailRequestTimeout
        maxThumbnailSize = DefaultConstants.maxThumbnailSize
        maxGIFThumbnailBytes = DefaultConstants.maxGIFThumbnailBytes

        minMediaResumePrompt = DefaultConstants.minMediaResumePrompt
        mediaResumeThreshold = DefaultConstants.mediaResumeThreshold

        maxUploadStagingLimit = DefaultConstants.maxUploadStagingLimit

        maxLinesPerLogFile = DefaultConstants.maxLinesPerLogFile

        lineChartMaxVisibleCount = DefaultConstants.lineChartMaxVisibleCount
        lineChartGridLineCount = DefaultConstants.lineChartGridLineCount

        previewSizeLimit = DefaultConstants.previewSizeLimit
    }
}
