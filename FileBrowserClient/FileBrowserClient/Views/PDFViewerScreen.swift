//
//  PDFViewerScreen.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/21/25.
//

import SwiftUI

struct PDFViewerScreen: View {
    let content: Data
    @State private var currentPage = 1
    @State private var pageCount = 1

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PDFKitView(data: content, currentPage: $currentPage, pageCount: $pageCount)

            // Page Number Display
            Text("Page \(currentPage) of \(pageCount)")
                .padding(8)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
        }
    }
}
