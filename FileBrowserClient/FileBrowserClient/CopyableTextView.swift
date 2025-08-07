//
//  CopyableTextView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/7/25.
//

import SwiftUI
import UIKit

struct CopyableTextView: UIViewRepresentable {
    let text: String
    var font: UIFont = .preferredFont(forTextStyle: .body)

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false // Let SwiftUI scroll it
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = []

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = font
    }
}
