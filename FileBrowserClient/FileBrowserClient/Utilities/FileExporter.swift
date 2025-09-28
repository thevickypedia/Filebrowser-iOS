//
//  FileExporter.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/25/25.
//

import SwiftUI
import UIKit

struct FileExportResult {
    let activityType: UIActivity.ActivityType?
    let completed: Bool
    let returnedItems: [Any]?
    let error: Error?
}

struct FileExporter: UIViewControllerRepresentable {
    let fileURL: URL
    var completion: ((FileExportResult) -> Void)?

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

        activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            // Call completion handler
            completion?(FileExportResult(
                activityType: activityType,
                completed: completed,
                returnedItems: returnedItems,
                error: activityError
            ))
        }

        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need to update in this case
    }
}
