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
        HStack(spacing: 30) {
            if let memory = memoryUsage {
                PieChartView(
                    title: "Memory",
                    used: Double(memory.used),
                    total: Double(memory.total),
                    color: .blue,
                    formatUsed: { formatBytes(Int64(memory.used)) },
                    formatTotal: { formatBytes(Int64(memory.total)) }
                )
            }

            if let cpu = cpuUsage {
                PieChartView(
                    title: "CPU",
                    used: cpu,
                    total: 100,
                    color: .red,
                    formatUsed: { String(format: "%.1f%%", cpu) },
                    formatTotal: { "100%" }
                )
            }

            if let disk = diskUsage {
                PieChartView(
                    title: "Disk",
                    used: Double(disk.used),
                    total: Double(disk.total),
                    color: .green,
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
    let color: Color
    let formatUsed: () -> String
    let formatTotal: () -> String

    var percentUsed: Double {
        total > 0 ? used / total : 0
    }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: CGFloat(percentUsed))
                    .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 120, height: 120)
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
