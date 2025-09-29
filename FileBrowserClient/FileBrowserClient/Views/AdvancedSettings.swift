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
    enum Section {
        case advancedSettings
        case loggingSettings
    }

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

    @State private var expandedSection: Section?

    var body: some View {
        DisclosureGroup("Advanced Settings", isExpanded: Binding(
            get: { expandedSection == .advancedSettings },
            set: { isExpanding in
                expandedSection = isExpanding ? .advancedSettings : nil
            }
        )) {
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
        }

        DisclosureGroup("Logging Settings", isExpanded: Binding(
            get: { expandedSection == .loggingSettings },
            set: { isExpanding in
                expandedSection = isExpanding ? .loggingSettings : nil
            }
        )) {
            HStack {
                Text("Log Option")
                Spacer()
                Picker("", selection: $logOption) {
                    ForEach([LogOptions.stdout, .file, .both], id: \.self) { option in
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
                    ForEach([LogLevel.trace, .debug, .info, .warning, .error], id: \.self) { level in
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
