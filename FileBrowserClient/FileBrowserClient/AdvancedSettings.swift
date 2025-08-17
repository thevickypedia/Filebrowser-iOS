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
}


struct AdvancedSettingsView: View {
    @Binding var cacheImage: Bool
    @Binding var cachePDF: Bool
    @Binding var cacheText: Bool

    @Binding var displayThumbnail: Bool
    @Binding var cacheThumbnail: Bool
    @Binding var animateGIF: Bool
    @Binding var chunkSize: Int

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
                .frame(width: 80)
            }
            Toggle("Cache Images", isOn: $cacheImage)
            Toggle("Cache PDFs", isOn: $cachePDF)
            Toggle("Cache Text Files", isOn: $cacheText)
            Toggle("Display Thumbnails", isOn: $displayThumbnail)
            Toggle("Cache Thumbnails", isOn: $cacheThumbnail)
            Toggle("Animate GIF Files", isOn: $animateGIF)
        }
    }
}
