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

    func makeUIViewController(context: Context) -> some UIViewController {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
