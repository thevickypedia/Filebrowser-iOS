//
//  SearchResults.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 10/10/25.
//

import Foundation

/// Filters out search results that include hidden files or directories (dotfiles) in their path.
///
/// This function checks each `FileItemSearch` result and removes any result that contains
/// a path component starting with a dot (`.`), such as `.git` or `.DS_Store`, **if** the user
/// has enabled `hideDotfiles` option.
///
/// - Parameters:
///   - results: An array of `FileItemSearch` items to be filtered.
///   - settings: The current `UserAccount` settings which may include the `hideDotfiles` flag.
///
/// - Returns: A filtered array of `FileItemSearch` results with hidden files/directories removed,
///            or the original array if `hideDotfiles` is `false` or not set.
func filterSearchResults(for results: [FileItemSearch], settings: UserAccount?) -> [FileItemSearch] {
    guard settings?.hideDotfiles == true else {
        Log.debug("👀 hideDotfiles is false or not set; skipping search results' filter")
        return results
    }
    var filteredResults: [FileItemSearch] = []

    for result in results {
        let components = result.path.components(separatedBy: "/")
        var isDotfile = false
        for component in components where component.starts(with: ".") {
            Log.debug("👀 Skipping \(result.path) since \(component) is hidden")
            isDotfile = true
            break
        }
        if !isDotfile {
            filteredResults.append(result)
        }
    }

    return filteredResults
}
