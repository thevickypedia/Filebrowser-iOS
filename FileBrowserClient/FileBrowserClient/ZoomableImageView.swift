//
//  ZoomableImageView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/8/25.
//

import SwiftUI

struct ZoomableImageView: View {
    let image: UIImage
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void

    @State private var scale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0

    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero

    @State private var isZoomed: Bool = false

    var body: some View {
        GeometryReader { geometry in
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale * gestureScale)
                .offset(x: offset.width + gestureOffset.width,
                        y: offset.height + gestureOffset.height)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .gesture(pinchGesture())
                .simultaneousGesture(doubleTapGesture())
                .gesture(dragGesture())
                .animation(.easeInOut(duration: 0.25), value: scale)
        }
    }

    private func dragGesture() -> some Gesture {
        DragGesture()
            .updating($gestureOffset) { value, state, _ in
                if isZoomed {
                    state = value.translation
                }
            }
            .onEnded { value in
                if isZoomed {
                    // Pan behavior
                    offset.width += value.translation.width
                    offset.height += value.translation.height
                } else {
                    // Swipe behavior
                    if value.translation.width < -50 {
                        onSwipeLeft()
                    } else if value.translation.width > 50 {
                        onSwipeRight()
                    }
                }
            }
    }

    // MARK: - Gestures
    private func pinchGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureScale) { value, state, _ in
                state = value
            }
            .onEnded { value in
                scale = max(scale * value, 1.0)
                isZoomed = scale > 1.0
            }
    }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gestureOffset) { value, state, _ in
                if isZoomed {
                    state = value.translation
                }
            }
            .onEnded { value in
                if isZoomed {
                    offset.width += value.translation.width
                    offset.height += value.translation.height
                }
            }
    }

    private func doubleTapGesture() -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation(.easeInOut) {
                    if isZoomed {
                        scale = 1.0
                        offset = .zero
                        isZoomed = false
                    } else {
                        scale = 2.5
                        isZoomed = true
                    }
                }
            }
    }

    private func swipeGesture() -> some Gesture {
        DragGesture()
            .onEnded { value in
                if value.translation.width < -50 {
                    onSwipeLeft()
                } else if value.translation.width > 50 {
                    onSwipeRight()
                }
            }
    }
}
