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
    @State private var zoomAnchor: CGPoint = .zero
    @GestureState private var gestureScale: CGFloat = 1.0

    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero

    @State private var rotationAngle: Angle = .zero
    @State private var isZoomed: Bool = false
    @State private var showSaveAlert = false

    @Binding var isFullScreen: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale * gestureScale)
                    .rotationEffect(rotationAngle)
                    .offset(x: offset.width + gestureOffset.width,
                            y: offset.height + gestureOffset.height)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(pinchGesture())
                    .simultaneousGesture(doubleTapGesture())
                    .gesture(dragGesture())
                    .animation(.easeInOut(duration: 0.25), value: scale)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // Save the touch location relative to center
                                zoomAnchor = CGPoint(
                                    x: value.location.x - geometry.size.width / 2,
                                    y: value.location.y - geometry.size.height / 2
                                )
                            }
                    )

                // Full-screen toggle button
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isFullScreen.toggle()
                        }) {
                            Image(systemName: isFullScreen
                                  ? "arrow.down.right.and.arrow.up.left"
                                  : "arrow.up.left.and.arrow.down.right")
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                        }
                    }
                    .padding()
                    Spacer()
                }

                // Rotate buttons
                VStack {
                    Spacer()
                    HStack(spacing: 24) {
                        Button {
                            withAnimation { rotationAngle -= .degrees(90) }
                        } label: {
                            Image(systemName: "rotate.left")
                        }

                        Button {
                            withAnimation { rotationAngle += .degrees(90) }
                        } label: {
                            Image(systemName: "rotate.right")
                        }

                        Button {
                            saveEditedImage()
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                }
                .alert("Saved to Photos", isPresented: $showSaveAlert) {}
            }
        }
    }

    private func saveEditedImage() {
        let renderer = UIGraphicsImageRenderer(size: image.size)

        let editedImage = renderer.image { ctx in
            ctx.cgContext.translateBy(x: image.size.width / 2,
                                      y: image.size.height / 2)
            ctx.cgContext.rotate(by: CGFloat(rotationAngle.radians))
            ctx.cgContext.translateBy(x: -image.size.width / 2,
                                      y: -image.size.height / 2)

            image.draw(at: .zero)
        }

        UIImageWriteToSavedPhotosAlbum(
            editedImage,
            nil,
            nil,
            nil
        )

        showSaveAlert = true
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
                let finalScale = scale * value
                let clampedScale = max(finalScale, 1.0)
                let anchorInView = zoomAnchor
                let scaleDelta = clampedScale / scale
                let newOffset = CGSize(
                    width: (offset.width - anchorInView.x) * scaleDelta + anchorInView.x,
                    height: (offset.height - anchorInView.y) * scaleDelta + anchorInView.y
                )
                offset = newOffset
                scale = clampedScale
                isZoomed = clampedScale > 1.0
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
                        offset = CGSize(
                            width: (offset.width - zoomAnchor.x) * 2.5 + zoomAnchor.x,
                            height: (offset.height - zoomAnchor.y) * 2.5 + zoomAnchor.y
                        )
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
