//
//  FileThumbnailView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/8/25.
//

import SwiftUI

struct FileThumbnailView: View {
    let file: FileItem
    let style: GridStyle?
    let extensionTypes: ExtensionTypes
    let advancedSettings: AdvancedSettings
    let serverURL: String
    let token: String

    var body: some View {
        let fileName = file.name.lowercased()
        let useThumbnail = advancedSettings.displayThumbnail &&
            extensionTypes.imageExtensions.contains(where: fileName.hasSuffix)

        if useThumbnail {
            RemoteThumbnail(
                file: file,
                serverURL: serverURL,
                token: token,
                advancedSettings: advancedSettings,
                extensionTypes: extensionTypes,
                width: style?.gridHeight ?? ViewStyle.listIconSize,
                height: style?.gridHeight ?? ViewStyle.listIconSize
            )
            .scaledToFill()
            .frame(
                width: style?.gridHeight ?? ViewStyle.listIconSize,
                height: style?.gridHeight ?? ViewStyle.listIconSize
            )
            .clipped()
        } else {
            Image(systemName: file.isDir
                ? Icons.folder
                : systemIcon(for: fileName, extensionTypes: extensionTypes) ?? Icons.doc)
                .resizable()
                .scaledToFit()
                .frame(height: style?.iconSize ?? ViewStyle.listIconSize)
                .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
        }
    }
}
