//
//  MetricsView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/27/25.
//

import SwiftUI

struct MetricsView: View {
    @State private var memoryUsage: MemoryUsage?
    @State private var cpuUsage: Double?
    @State private var diskUsage: (used: UInt64, total: UInt64)?
    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 40) {
            if let memory = memoryUsage {
                PieChartView(
                    title: "Memory",
                    used: Double(memory.used),
                    total: Double(memory.total),
                    formatUsed: { formatBytes(Int64(memory.used)) },
                    formatTotal: { formatBytes(Int64(memory.total)) }
                )
            }

            if let cpu = cpuUsage {
                PieChartView(
                    title: "CPU",
                    used: cpu,
                    total: 100,
                    formatUsed: { String(format: "%.1f%%", cpu) },
                    formatTotal: { "100%" }
                )
            }

            if let disk = diskUsage {
                PieChartView(
                    title: "Disk",
                    used: Double(disk.used),
                    total: Double(disk.total),
                    formatUsed: { formatBytes(Int64(disk.used)) },
                    formatTotal: { formatBytes(Int64(disk.total)) }
                )
            }
        }
        .padding()
        .onAppear(perform: loadData)
        .onReceive(timer) { _ in
            loadData()
        }
    }

    private func loadData() {
        memoryUsage = getMemoryUsage()
        cpuUsage = getCPUUsage()
        diskUsage = getDiskUsage()
    }
}

struct PieChartView: View {
    let title: String
    let used: Double
    let total: Double
    let formatUsed: () -> String
    let formatTotal: () -> String

    var percentUsed: Double {
        total > 0 ? used / total : 0
    }

    var color: Color {
        switch percentUsed {
        case 0..<0.25:
            return .green
        case 0.25..<0.5:
            return .yellow
        case 0.5..<0.75:
            return .orange
        default:
            return .red
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: CGFloat(percentUsed))
                    .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 140, height: 140)
                    .animation(.easeInOut(duration: 0.4), value: percentUsed)

                VStack {
                    Text(title)
                        .font(.headline)
                    Text("\(formatUsed()) / \(formatTotal())")
                        .font(.subheadline)
                    Text(String(format: "%.1f%% used", percentUsed * 100))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
