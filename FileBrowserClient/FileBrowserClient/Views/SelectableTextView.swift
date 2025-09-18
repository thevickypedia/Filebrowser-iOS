//
//  SelectableTextView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/7/25.
//

import SwiftUI

struct SelectableTextView: View {
    var text: String
    // Allow unlimited height by default
    var maxHeight: CGFloat = .infinity

    var body: some View {
        SelectableTextViewRepresentable(text: text, maxHeight: maxHeight)
    }

    private struct SelectableTextViewRepresentable: UIViewRepresentable {
        var text: String
        var maxHeight: CGFloat

        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.isEditable = false
            textView.isSelectable = true
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            textView.textContainerInset = .zero
            textView.textContainer.lineFragmentPadding = 0
            textView.font = UIFont.preferredFont(forTextStyle: .body)
            textView.textContainer.lineBreakMode = .byWordWrapping
            textView.textContainer.widthTracksTextView = true

            // Set content hugging and compression resistance
            textView.setContentHuggingPriority(.required, for: .vertical)
            textView.setContentCompressionResistancePriority(.required, for: .vertical)

            return textView
        }

        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.text = text
            // Calculate the required height for the text
            let size = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: .greatestFiniteMagnitude))
            let constrainedHeight = min(size.height, maxHeight)
            // Update the frame height
            if uiView.bounds.height != constrainedHeight {
                DispatchQueue.main.async {
                    uiView.invalidateIntrinsicContentSize()
                }
            }
        }

        func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
            let width = proposal.width ?? UIView.layoutFittingCompressedSize.width
            let size = uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            let constrainedHeight = min(size.height, maxHeight)
            return CGSize(width: width, height: constrainedHeight)
        }
    }
}
