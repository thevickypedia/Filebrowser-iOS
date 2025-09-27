//
//  MemoryUsageView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/27/25.
//


import SwiftUI

struct MemoryUsageView: View {
    @State private var memoryUsage: MemoryUsage?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let memory = memoryUsage {
                let percentUsed = Double(memory.used) / Double(memory.total)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Memory Usage")
                        .font(.headline)

                    ProgressView(value: percentUsed) {
                        Text("\(formatBytes(Int64(memory.used)))/\(formatBytes(Int64(memory.total)))")
                            .font(.subheadline)
                    }

                    Text(String(format: "%.1f%% used", percentUsed * 100))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                Text("Memory usage unavailable")
                    .foregroundColor(.gray)
            }
        }
        .onAppear(perform: loadMemory)
    }

    private func loadMemory() {
        memoryUsage = getMemoryUsage()
    }
}
