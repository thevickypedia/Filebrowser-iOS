//
//  ListViewHelper.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 10/11/25.
//

import SwiftUI

func preparingUploadStack(totalSelected: Int) -> some View {
    return ZStack {
        ProgressView("Preparing \(totalSelected) files for upload...")
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .padding(24)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 10)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

func parseSearchQuery(query: String, queryPrefix: String?, displayName: String) -> String {
    var finalQuery = query
    if let prefix = queryPrefix {
        Log.debug("🔎 Search type: \(displayName)")
        finalQuery = "\(prefix) \(finalQuery)"
    }
    return finalQuery
}

func getUploadURL(serverURL: String, encodedName: String, currentPath: String) -> URL? {
    return buildAPIURL(
        baseURL: serverURL,
        pathComponents: currentPath == "/" ? ["api", "tus", encodedName] : ["api", "tus", currentPath, encodedName],
        queryItems: [URLQueryItem(name: "override", value: "false")]
    )
}
