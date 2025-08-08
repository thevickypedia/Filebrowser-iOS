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
}

enum ViewMode {
    case list, grid, module
}

struct GridStyle {
    let gridHeight: CGFloat
    let isModule: Bool

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
