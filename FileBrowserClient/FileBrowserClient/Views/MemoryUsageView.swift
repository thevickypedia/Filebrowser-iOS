//
//  MemoryUsageView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/27/25.
//

import SwiftUI

struct MemoryUsageView: View {
    @State private var memoryUsage: MemoryUsage?
    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if let memory = memoryUsage {
                let percentUsed = Double(memory.used) / Double(memory.total)

                ZStack {
                    // Background circle (total memory)
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                        .frame(width: 150, height: 150)

                    // Usage arc (used memory)
                    Circle()
                        .trim(from: 0, to: CGFloat(percentUsed))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90)) // start from top
                        .frame(width: 150, height: 150)
                        .animation(.easeInOut(duration: 0.4), value: percentUsed)

                    VStack {
                        Text("Memory Usage")
                            .font(.headline)

                        Text("\(formatBytes(Int64(memory.used))) / \(formatBytes(Int64(memory.total)))")
                            .font(.subheadline)

                        Text(String(format: "%.1f%% used", percentUsed * 100))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Text("Memory usage unavailable")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            loadMemory()
        }
        .onReceive(timer) { _ in
            loadMemory()
        }
    }

    private func loadMemory() {
        memoryUsage = getMemoryUsage()
    }
}
