//
//  FileExporter.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/25/25.
//

import SwiftUI
import UIKit

struct FileExporter: UIViewControllerRepresentable {
    let fileURL: URL
    var completion: ((Bool) -> Void)? // true if completed, false if cancelled

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

        activityVC.completionWithItemsHandler = { _, completed, _, _ in
            // Call your completion handler
            completion?(completed)
        }

        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need to update in this case
    }
}
