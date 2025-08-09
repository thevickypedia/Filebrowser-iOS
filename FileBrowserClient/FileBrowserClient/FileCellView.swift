//
//  FileCellView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/8/25.
//

import SwiftUI

struct FileCellView: View {
    let file: FileItem
    let index: Int?
    let style: GridStyle?
    let module: Bool
    let selectionMode: Bool
    let isSelected: Bool
    let onTap: () -> Void

    let extensionTypes: ExtensionTypes
    let advancedSettings: AdvancedSettings
    let serverURL: String
    let token: String
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if style == nil {
                    // 📄 List View Style (thumbnail left, text right)
                    HStack(spacing: 12) {
                        FileThumbnailView(
                            file: file,
                            style: nil,
                            extensionTypes: extensionTypes,
                            advancedSettings: advancedSettings,
                            serverURL: serverURL,
                            token: token
                        )
                        .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)

                        Text(file.name)
                            .foregroundColor(.primary)

                        Spacer()
                    }
                } else {
                    // 🗂️ Grid View Style (thumbnail above, text below)
                    VStack(spacing: 6) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                                .frame(height: style!.gridHeight)

                            FileThumbnailView(
                                file: file,
                                style: style,
                                extensionTypes: extensionTypes,
                                advancedSettings: advancedSettings,
                                serverURL: serverURL,
                                token: token
                            )
                        }

                        Text(file.name)
                            .font(module ? .caption2 : .caption)
                            .multilineTextAlignment(.center)
                            .lineLimit(style?.lineLimit ?? 1)
                            .padding(.horizontal, 2)
                            .foregroundColor(.primary)
                    }
                }
            }

            // ✅ Selection Mode (shared across layouts)
            if selectionMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: style?.selectionSize ?? 18, height: style?.selectionSize ?? 18)
                    .foregroundColor(isSelected ? .blue : .gray)
                    .padding(6)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
    }
}
