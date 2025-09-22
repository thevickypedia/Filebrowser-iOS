//
//  DownloadingStack.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/21/25.
//


import SwiftUI

struct DownloadingStack: View {
    let fileName: String?
    let fileIcon: String?
    let downloaded: String?
    let total: String?
    let progress: Double
    let progressPct: Int
    let speed: Double
    let index: Int
    let totalCount: Int
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // 🗂️ File Info
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: fileIcon ?? "arrow.down.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                VStack(alignment: .leading, spacing: 4) {
                    Text(fileName ?? "Downloading...")
                        .font(.headline)
                    Text("\(downloaded ?? "0") / \(total ?? "—")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            // 🔄 Queue
            HStack(spacing: 12) {
                Image(systemName: "list.number").foregroundColor(.indigo)
                Text("\(index) of \(totalCount)").font(.body)
            }

            // 🚀 Speed
            HStack(spacing: 12) {
                Image(systemName: "speedometer").foregroundColor(.green)
                Text(String(format: "%.2f MB/s", speed)).font(.body)
            }

            // 📊 Progress Bar
            ProgressView(value: progress, total: 1.0) {
                EmptyView()
            } currentValueLabel: {
                Text("\(progressPct)%")
            }
            .progressViewStyle(LinearProgressViewStyle())
            .padding(.top, 8)

            Button(action: onCancel) {
                Label("Cancel Download", systemImage: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
