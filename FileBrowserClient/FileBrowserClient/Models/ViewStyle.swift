//
//  ViewStyle.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/8/25.
//

import SwiftUI

struct ViewStyle {
    // Global scale is now calculated, not hard-coded
    /* To handle scaling globally:
     - ViewStyle.globalScale = 1.2 // 20% bigger
     - ViewStyle.globalScale = 0.9 // 10% smaller
     */
    static var globalScale: CGFloat {
        let device = UIDevice.current.userInterfaceIdiom
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let isLandscape = screenWidth > screenHeight

        var scale: CGFloat = 1.0

        // 🔹 Base scale by device type
        switch device {
        case .pad:
            scale = 1.4 // iPads = bigger icons
        case .phone:
            if max(screenWidth, screenHeight) < 700 {
                scale = 0.95 // small phones = slightly smaller icons
            } else {
                scale = 1.0 // large phones = normal size
            }
        default:
            scale = 1.0
        }

        // 🔹 Adjust for landscape
        if isLandscape {
            scale *= 0.9
        }

        return scale
    }

    // List sizes
    static var listIconSize: CGFloat { 28 * globalScale }
    static var listCornerRadius: CGFloat { 4 * globalScale }

    // Grid/module sizes
    static func gridStyle(module: Bool) -> GridStyle {
        let baseHeight: CGFloat = module ? 70 : 100
        return GridStyle(gridHeight: baseHeight * globalScale, isModule: module)
    }

    // Mosaic size
    static func mosaicStyle() -> GridStyle {
        let baseHeight: CGFloat = 180
        return GridStyle(gridHeight: baseHeight * globalScale, isModule: false, isMosaic: true)
    }
}

struct GridStyle {
    let gridHeight: CGFloat
    let isModule: Bool
    let isMosaic: Bool

    // Initialize grid style
    init(gridHeight: CGFloat, isModule: Bool, isMosaic: Bool = false) {
        self.gridHeight = gridHeight
        self.isModule = isModule
        self.isMosaic = isMosaic
    }

    var iconSize: CGFloat {
        isModule ? gridHeight * 0.45 : gridHeight * 0.4
    }
    var folderSize: CGFloat {
        isModule ? gridHeight * 0.45 : gridHeight * 0.35
    }
    var selectionSize: CGFloat { gridHeight * 0.2 }
    var lineLimit: Int { isModule ? 2 : 1 }
}

struct Icons {
    // Icon - SystemName mapping to be used in FileListView
    static let folder: String = "folder"
    static let doc: String = "doc"
}

struct SymlinkBadgeModifier: ViewModifier {
    let iconSize: CGFloat
    let isSymlink: Bool

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                if isSymlink {
                    let badgeSize = max(7, iconSize * 0.22)
                    let offset = iconSize * 0.08

                    Image(systemName: "arrowshape.turn.up.right")
                        .font(.system(size: badgeSize, weight: .regular))
                        .foregroundStyle(.primary.opacity(0.45))
                        .offset(x: offset, y: offset)
                }
            }
    }
}

extension View {
    func symlinkBadge(iconSize: CGFloat, isSymlink: Bool) -> some View {
        self.modifier(SymlinkBadgeModifier(iconSize: iconSize, isSymlink: isSymlink))
    }
}

func baseIcon(for file: FileItem, fileName: String, extensionTypes: ExtensionTypes) -> String {
    if file.isDir {
        return Icons.folder
    }
    return systemIcon(for: fileName, extensionTypes: extensionTypes) ?? Icons.doc
}

@ViewBuilder
func iconView(for file: FileItem, size: CGFloat, extensionTypes: ExtensionTypes) -> some View {
    let fileName = file.name.lowercased()
    let iconName = baseIcon(for: file, fileName: fileName, extensionTypes: extensionTypes)

    Image(systemName: iconName)
        .resizable()
        .scaledToFit()
        .frame(width: size, height: size)
        .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
        .symlinkBadge(iconSize: size, isSymlink: file.isSymlink)
}

func adaptiveColumns(module: Bool) -> [GridItem] {
    /*
     On iPhone portrait, you'll get ~3–4 columns depending on module/grid mode.
     On iPhone landscape, you'll see 5–6 columns.
     On iPad portrait, possibly 6–8 columns.
     On iPad landscape, 10+ columns.
    */
    let screenWidth = UIScreen.main.bounds.width
    let style = ViewStyle.gridStyle(module: module)

    // Available space per item including spacing (padding handled separately)
    let minItemWidth = style.gridHeight + 20 // height ~= width + padding buffer

    // Figure out how many items fit in the width
    let columnsCount = max(1, Int(screenWidth / minItemWidth))

    return Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: columnsCount
    )
}

func mosaicColumns() -> [GridItem] {
    let screenWidth = UIScreen.main.bounds.width
    let style = ViewStyle.mosaicStyle()

    // Remove spacing completely for true edge-to-edge
    let minItemWidth = style.gridHeight
    let columnsCount = max(2, Int(screenWidth / minItemWidth))

    return Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: columnsCount
    )
}

enum ViewMode: String {
    case list, grid, module, mosaic
}

enum SortOption {
    case nameAsc, nameDesc, sizeAsc, sizeDesc, modifiedAsc, modifiedDesc
}
