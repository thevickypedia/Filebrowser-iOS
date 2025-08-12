//
//  FullScreenImageWrapper.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/11/25.
//


import SwiftUI

struct FullScreenImageWrapper: View {
    let image: UIImage
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var isUIVisible: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ZoomableImageView(
                image: image,
                onSwipeLeft: onSwipeLeft,
                onSwipeRight: onSwipeRight
            )
            .simultaneousGesture(
                TapGesture(count: 1).onEnded {
                    withAnimation {
                        isUIVisible.toggle()
                    }
                }
            )

            if isUIVisible {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .transition(.opacity)
            }
        }
        .statusBarHidden(!isUIVisible)
    }
}
