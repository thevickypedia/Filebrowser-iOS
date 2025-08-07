//
//  CopyableTextContainer.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/7/25.
//


import SwiftUI

struct CopyableTextContainer: View {
    let text: String

    @State private var fontSize: CGFloat = 14
    @State private var useMonospaced: Bool = false
    @State private var showFontMenu = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button(action: { showFontMenu.toggle() }) {
                    Image(systemName: "chevron.down.circle")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(6)
                }
                .popover(isPresented: $showFontMenu) {
                    VStack(spacing: 12) {
                        Toggle("Monospaced", isOn: $useMonospaced)
                        Stepper("Size: \(Int(fontSize))", value: $fontSize, in: 10...24, step: 1)
                    }
                    .padding()
                    .frame(width: 200)
                }
            }
            .padding(.trailing, 12)

            ScrollView {
                CopyableTextView(
                    text: text,
                    font: useMonospaced
                        ? .monospacedSystemFont(ofSize: fontSize, weight: .regular)
                        : .systemFont(ofSize: fontSize)
                )
                .padding()
            }
        }
    }
}
