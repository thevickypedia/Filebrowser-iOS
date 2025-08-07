//
//  SelectableTextView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/7/25.
//



import SwiftUI

struct SelectableTextView: View {
    var text: String
    var height: CGFloat = 22 // Default height

    var body: some View {
        SelectableTextViewRepresentable(text: text)
            .frame(height: height)
    }

    private struct SelectableTextViewRepresentable: UIViewRepresentable {
        var text: String

        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.isEditable = false
            textView.isSelectable = true
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            textView.textContainerInset = .zero
            textView.textContainer.lineFragmentPadding = 0
            textView.font = UIFont.preferredFont(forTextStyle: .body)
            return textView
        }

        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.text = text
        }
    }
}
