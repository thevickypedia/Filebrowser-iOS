//
//  ZoomableImageView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/8/25.
//


import SwiftUI

struct ZoomableImageView: View {
    let image: UIImage

    @State private var scale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0

    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero

    @State private var isZoomed: Bool = false

    var body: some View {
        GeometryReader { geometry in
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit) // Keeps image centered
                .scaleEffect(scale * gestureScale)
                .offset(x: offset.width + gestureOffset.width, y: offset.height + gestureOffset.height)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .gesture(pinchGesture())
                .gesture(doubleTapGesture())
                .gesture(panGesture())
                .animation(.easeInOut(duration: 0.25), value: scale)
        }
    }

    // MARK: - Gestures

    private func pinchGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureScale) { value, state, _ in
                state = value
            }
            .onEnded { value in
                let newScale = scale * value
                scale = max(newScale, 1.0) // Don't zoom out below original size
            }
    }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gestureOffset) { value, state, _ in
                if scale > 1.0 {
                    state = value.translation
                }
            }
            .onEnded { value in
                if scale > 1.0 {
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
                    } else {
                        scale = 2.5
                    }
                    isZoomed.toggle()
                }
            }
    }
}
