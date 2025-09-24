//
//  AdvancedSettings.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/17/25.
//

import SwiftUI

struct AdvancedSettings {
    // Controlled with file extensions
    let cacheImage: Bool
    let cachePDF: Bool
    let cacheText: Bool
    // Controlled with individual condition blocks
    let displayThumbnail: Bool
    let cacheThumbnail: Bool
    let animateGIF: Bool
    let chunkSize: Int
    let logOption: LogOptions
    let logLevel: LogLevel
    let verboseLogging: Bool
}

struct AdvancedSettingsView: View {
    @Binding var cacheImage: Bool
    @Binding var cachePDF: Bool
    @Binding var cacheText: Bool

    @Binding var displayThumbnail: Bool
    @Binding var cacheThumbnail: Bool
    @Binding var animateGIF: Bool
    @Binding var chunkSize: Int
    @Binding var logOption: LogOptions
    @Binding var logLevel: LogLevel
    @Binding var verboseLogging: Bool

    var body: some View {
        DisclosureGroup("Advanced Settings") {
            HStack {
                Text("Chunk Size (MB)")
                Spacer()
                Picker("", selection: $chunkSize) {
                    ForEach([1, 2, 5, 10, 20], id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 120)
            }
            Toggle("Cache Images", isOn: $cacheImage)
            Toggle("Cache PDFs", isOn: $cachePDF)
            Toggle("Cache Text Files", isOn: $cacheText)
            Toggle("Display Thumbnails", isOn: $displayThumbnail)
            Toggle("Cache Thumbnails", isOn: $cacheThumbnail)
            Toggle("Animate GIF Files", isOn: $animateGIF)
            HStack {
                Text("Log Option")
                Spacer()
                Picker("", selection: $logOption) {
                    ForEach([LogOptions.stdout, LogOptions.file, LogOptions.both], id: \.self) { option in
                        Text(String(describing: option)).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 120)
            }
            HStack {
                Text("Log Level")
                Spacer()
                Picker("", selection: $logLevel) {
                    ForEach([LogLevel.trace, LogLevel.debug, LogLevel.info, LogLevel.warning, LogLevel.error], id: \.self) { level in
                        Text(String(describing: level)).tag(level)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 120)
            }
            Toggle("Verbose Logging", isOn: $verboseLogging)
        }
    }
}
