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

    @Binding var isFullScreen: Bool

    // MARK: - Zoom & Pan
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var dragStartOffset: CGSize = .zero
    @GestureState private var gestureScale: CGFloat = 1.0
    @GestureState private var gestureOffset: CGSize = .zero

    // MARK: - Rotation
    @State private var rotationAngle: Angle = .zero

    // MARK: - Zoom & Pan Helper
    private var isZoomed: Bool { scale > 1.0 }

    // MARK: - Save Alert
    @State private var showSaveAlert = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Image
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale * gestureScale)
                    .rotationEffect(rotationAngle)
                    .offset(
                        x: offset.width + (isZoomed ? gestureOffset.width : 0),
                        y: offset.height + (isZoomed ? gestureOffset.height : 0)
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(combinedGestures())
                    .animation(.easeInOut(duration: 0.25), value: scale)

                // MARK: - Fullscreen Toggle
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            isFullScreen.toggle()
                        } label: {
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

                // MARK: - Rotation & Save Buttons
                if !isFullScreen {
                    VStack {
                        Spacer()
                        HStack(spacing: 24) {
                            Button { withAnimation { rotationAngle -= .degrees(90) } } label: {
                                Image(systemName: "rotate.left")
                            }
                            Button { withAnimation { rotationAngle += .degrees(90) } } label: {
                                Image(systemName: "rotate.right")
                            }
                            Button { saveEditedImage() } label: {
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
            .background(Color.black)
            .ignoresSafeArea(edges: isFullScreen ? .all : [])
            .navigationBarHidden(isFullScreen)
            .statusBar(hidden: isFullScreen)
        }
    }

    // MARK: - Combined Gestures
    private func combinedGestures() -> some Gesture {
        let pinch = MagnificationGesture()
            .updating($gestureScale) { value, state, _ in state = value }
            .onEnded { value in
                let newScale = max(scale * value, 1.0)
                // Adjust offset to zoom around gesture center
                offset = CGSize(
                    width: offset.width * newScale / scale,
                    height: offset.height * newScale / scale
                )
                scale = newScale
                dragStartOffset = offset
            }

        let drag = DragGesture()
            .updating($gestureOffset) { value, state, _ in
                if isZoomed { state = value.translation }
            }
            .onChanged { value in
                if isZoomed {
                    // follow finger exactly
                    offset.width = dragStartOffset.width + value.translation.width
                    offset.height = dragStartOffset.height + value.translation.height
                }
            }
            .onEnded { value in
                if isZoomed {
                    dragStartOffset = offset
                } else {
                    // swipe when not zoomed
                    if value.translation.width < -50 { onSwipeLeft() }
                    else if value.translation.width > 50 { onSwipeRight() }
                }
            }

        let doubleTap = TapGesture(count: 2)
            .onEnded {
                withAnimation(.easeInOut) {
                    if isZoomed {
                        scale = 1.0
                        offset = .zero
                        dragStartOffset = .zero
                    } else {
                        scale = 2.5
                        dragStartOffset = offset
                    }
                }
            }

        return SimultaneousGesture(
            SimultaneousGesture(pinch, drag),
            doubleTap
        )
    }

    // MARK: - Save Image
    private func saveEditedImage() {
        let radians = CGFloat(rotationAngle.radians)
        let originalSize = image.size
        let rotatedRect = CGRect(origin: .zero, size: originalSize)
            .applying(CGAffineTransform(rotationAngle: radians))
        let newSize = CGSize(width: abs(rotatedRect.width), height: abs(rotatedRect.height))
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let editedImage = renderer.image { ctx in
            ctx.cgContext.translateBy(x: newSize.width/2, y: newSize.height/2)
            ctx.cgContext.rotate(by: radians)
            ctx.cgContext.translateBy(x: -originalSize.width/2, y: -originalSize.height/2)
            image.draw(at: .zero)
        }
        UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil)
        showSaveAlert = true
    }
}
