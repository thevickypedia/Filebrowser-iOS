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
    @State private var showFontControls = false
    @State private var isWordWrapped = true  // New state for word wrap toggle

    private let defaultFontSize: CGFloat = 14
    private let minFontSize: CGFloat = 10
    private let maxFontSize: CGFloat = 24

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DisclosureGroup(
                isExpanded: $showFontControls,
                content: {
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $useMonospaced) {
                            Label("Monospaced Font", systemImage: "textformat")
                        }

                        HStack {
                            Label("Font Size", systemImage: "textformat.size")
                            Spacer()
                            Stepper("\(Int(fontSize))", value: $fontSize, in: minFontSize...maxFontSize)
                        }

                        HStack {
                            Spacer()
                            Button(action: {
                                isWordWrapped.toggle()
                            }) {
                                Label(isWordWrapped ? "Disable Word Wrap" : "Enable Word Wrap", systemImage: isWordWrapped ? "arrow.right.arrow.left" : "rectangle.on.rectangle.angled")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .buttonStyle(.bordered)
                            }
                            .padding(.horizontal)
                        }

                        HStack {
                            Spacer()
                            Button("Reset") {
                                fontSize = defaultFontSize
                                useMonospaced = false
                                isWordWrapped = true
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .font(.subheadline)
                },
                label: {
                    HStack {
                        Label("Text Options", systemImage: "slider.horizontal.3")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            )
            .padding(.bottom, 8)

            // ScrollView for the Text Content
            ScrollView(isWordWrapped ? .vertical : .horizontal, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    CopyableTextView(
                        text: text,
                        font: useMonospaced
                            ? .monospacedSystemFont(ofSize: fontSize, weight: .regular)
                            : .systemFont(ofSize: fontSize)
                    )
                    .padding()
                    .lineLimit(isWordWrapped ? nil : 1)  // Toggle word wrap using .lineLimit
                    .fixedSize(horizontal: isWordWrapped ? false : true, vertical: true)  // Allow horizontal overflow
                }
            }
        }
        .padding()
    }
}
