//
//  FileList.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/18/25.
//

func getNavigationTitle(for currentDisplayPath: String) -> String {
    // Use currentDisplayPath instead of pathStack for immediate updates
    if currentDisplayPath == "/" || currentDisplayPath.isEmpty {
        return "Home"
    }

    let components = currentDisplayPath.components(separatedBy: "/")
    return components.last?.isEmpty == false ? components.last! : "Home"
}

func getSheetNavigationTitle(_ sheetPathStack: [FileItem]) -> String {
    if sheetPathStack.isEmpty {
        return "Root" // Show "Root" when at the top level
    } else {
        return sheetPathStack.last?.name ?? "Root"
    }
}

func fullPath(for file: FileItem, with currentPath: String) -> String {
    if currentPath == "/" {
        return "/\(file.name)"
    } else {
        return "\(currentPath)/\(file.name)"
    }
}
