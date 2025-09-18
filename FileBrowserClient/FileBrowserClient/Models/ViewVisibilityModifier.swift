//
//  ViewVisibilityModifier.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/10/25.
//

import SwiftUI

struct ViewVisibilityModifier: ViewModifier {
    let onVisible: () -> Void
    let threshold: CGFloat // The distance from the viewport at which to trigger the load

    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) { value in
                let screenHeight = UIScreen.main.bounds.height
                if value < screenHeight + threshold && value > -threshold {
                    // View is near or in the viewport
                    if !isVisible {
                        isVisible = true
                        onVisible() // Trigger the load when the view becomes visible
                    }
                } else {
                    if isVisible {
                        isVisible = false
                    }
                }
            }
    }
}

// Custom Preference Key to track the position of the view
struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
