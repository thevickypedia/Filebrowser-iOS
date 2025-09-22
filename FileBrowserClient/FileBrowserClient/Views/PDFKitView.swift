//
//  PDFKitView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/8/25.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let data: Data
    @Binding var currentPage: Int
    @Binding var pageCount: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        context.coordinator.pdfView = pdfView

        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.usePageViewController(true, withViewOptions: nil)

        if let document = PDFDocument(data: data) {
            pdfView.document = document
            context.coordinator.document = document

            // Delay setting the bindings to avoid view update conflicts
            DispatchQueue.main.async {
                self.pageCount = document.pageCount
                self.currentPage = 1
            }
        }

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.pageChanged),
            name: Notification.Name.PDFViewPageChanged,
            object: pdfView
        )

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // Do NOT reset the document here — it causes page jumps and resets
    }

    class Coordinator: NSObject {
        var parent: PDFKitView
        weak var pdfView: PDFView?
        var document: PDFDocument?

        init(_ parent: PDFKitView) {
            self.parent = parent
        }

        @objc func pageChanged(notification: Notification) {
            guard let pdfView = pdfView,
                  let currentPage = pdfView.currentPage,
                  let document = document else { return }

            let pageIndex = document.index(for: currentPage)

            DispatchQueue.main.async {
                self.parent.currentPage = pageIndex + 1
            }
        }
    }
}
