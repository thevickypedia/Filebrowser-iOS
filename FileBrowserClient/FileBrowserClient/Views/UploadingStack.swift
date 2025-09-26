//
//  UploadingStack.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/21/25.
//

import SwiftUI

struct UploadingStack: View {
    let isUploading: Bool
    let fileName: String?
    let fileIcon: String?
    let uploaded: String?
    let total: String?
    let progress: Double
    let progressPct: Int
    let speed: Double
    let index: Int
    let totalCount: Int
    let chunkSize: Int
    let isPaused: Bool
    let onPause: () -> Void
    let onResume: () -> Void
    let onCancel: () -> Void
    let nextUploadInQueue: () -> String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // 🗂️ File Info
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isUploading ? (fileIcon ?? "doc.fill") : "doc.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                VStack(alignment: .leading, spacing: 4) {
                    Text(isUploading ? (fileName ?? "Unknown") : "--").font(.headline)
                    if isUploading {
                        Text("\(uploaded ?? "0") / \(total ?? "0")")
                            .font(.subheadline).foregroundColor(.gray)
                    }
                }
            }

            // 🔄 Queue
            HStack(spacing: 12) {
                Image(systemName: isUploading ? "list.number" : "clock").foregroundColor(.indigo)
                Text("\(index + 1) of \(totalCount)").font(.body)
            }

            // 🚀 Speed
            HStack(spacing: 12) {
                Image(systemName: "speedometer").foregroundColor(.green)
                Text(isUploading ? String(format: "%.2f MB/s", speed) : "--").font(.body)
            }

            // 📤 Chunk Size
            HStack(spacing: 12) {
                Image(systemName: "square.stack.3d.up").foregroundColor(.orange)
                Text("\(chunkSize) MB").font(.body)
            }

            // 📊 Progress Bar
            ProgressView(value: progress, total: 1.0) {
                EmptyView()
            } currentValueLabel: {
                Text(isUploading ? "⬆️ \(progressPct)%" : "⬆️ 0%")
            }
            .progressViewStyle(LinearProgressViewStyle())
            .padding(.top, 8)

            if let nextUp = nextUploadInQueue() {
                Text(nextUp)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }

            // ⏸️ Pause, ▶️ Resume and ❌ Cancel
            HStack(spacing: 20) {
                if isPaused {
                    Button(action: onResume) {
                        Label("Resume", systemImage: "play.circle.fill")
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.green)
                } else {
                    Button(action: onPause) {
                        Label("Pause", systemImage: "pause.circle.fill")
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.yellow)
                }
                Button(action: onCancel) {
                    Label("Cancel", systemImage: "xmark.circle.fill")
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
