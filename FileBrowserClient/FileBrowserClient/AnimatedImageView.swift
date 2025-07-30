//
//  AnimatedImageView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/30/25.
//


import SwiftUI
import UIKit
import ImageIO

struct AnimatedImageView: UIViewRepresentable {
    let data: Data

    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = animatedImage(from: data)

        container.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func animatedImage(from data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              CGImageSourceGetCount(source) > 1 else {
            return UIImage(data: data) // fallback to static
        }

        var images: [UIImage] = []
        var duration: TimeInterval = 0

        for i in 0..<CGImageSourceGetCount(source) {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            let frameDuration = getFrameDuration(from: source, at: i)
            duration += frameDuration
            images.append(UIImage(cgImage: cgImage))
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }

    private func getFrameDuration(from source: CGImageSource, at index: Int) -> TimeInterval {
        let defaultFrameDuration = 0.1
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gif = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let duration = gif[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval ??
                             gif[kCGImagePropertyGIFDelayTime] as? TimeInterval else {
            return defaultFrameDuration
        }
        return duration < 0.02 ? 0.1 : duration
    }
}
