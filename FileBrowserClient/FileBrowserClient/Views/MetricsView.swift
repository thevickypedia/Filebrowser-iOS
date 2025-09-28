//
//  MetricsView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/27/25.
//

import SwiftUI

enum ChartType: String, CaseIterable, Identifiable {
    case pie = "Pie"
    case bar = "Bar"
    case stacked = "Stacked"

    var id: String { rawValue }
}

struct MetricsView: View {
    @State private var memoryUsage: MemoryUsage?
    @State private var cpuUsage: Double?
    @State private var diskUsage: (used: UInt64, total: UInt64)?

    @State private var memoryChartType: ChartType = .pie
    @State private var cpuChartType: ChartType = .pie
    @State private var diskChartType: ChartType = .pie

    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                if let memory = memoryUsage {
                    MetricChartView(
                        title: "Memory",
                        used: Double(memory.used),
                        total: Double(memory.total),
                        formatUsed: { formatBytes(Int64(memory.used)) },
                        formatTotal: { formatBytes(Int64(memory.total)) },
                        chartType: $memoryChartType
                    )
                }

                if let cpu = cpuUsage {
                    MetricChartView(
                        title: "CPU",
                        used: cpu,
                        total: 100,
                        formatUsed: { String(format: "%.1f%%", cpu) },
                        formatTotal: { "100%" },
                        chartType: $cpuChartType
                    )
                }

                if let disk = diskUsage {
                    MetricChartView(
                        title: "Disk",
                        used: Double(disk.used),
                        total: Double(disk.total),
                        formatUsed: { formatBytes(Int64(disk.used)) },
                        formatTotal: { formatBytes(Int64(disk.total)) },
                        chartType: $diskChartType
                    )
                }
            }
            .padding()
            .onAppear(perform: loadData)
            .onReceive(timer) { _ in
                loadData()
            }
        }
    }

    private func loadData() {
        memoryUsage = getMemoryUsage()
        cpuUsage = getCPUUsage()
        diskUsage = getDiskUsage()
    }
}

struct MetricChartView: View {
    let title: String
    let used: Double
    let total: Double
    let formatUsed: () -> String
    let formatTotal: () -> String

    @Binding var chartType: ChartType

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
        VStack(spacing: 16) {
            Picker("Chart Type", selection: $chartType) {
                ForEach(ChartType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            switch chartType {
            case .pie:
                PieChartView(
                    title: title,
                    percentUsed: percentUsed,
                    formatUsed: formatUsed,
                    formatTotal: formatTotal,
                    color: color
                )
            case .bar:
                BarChartView(
                    title: title,
                    percentUsed: percentUsed,
                    formatUsed: formatUsed,
                    formatTotal: formatTotal,
                    color: color
                )
            case .stacked:
                StackedChartView(
                    title: title,
                    percentUsed: percentUsed,
                    formatUsed: formatUsed,
                    formatTotal: formatTotal,
                    color: color
                )
            }
        }
    }
}

struct PieChartView: View {
    let title: String
    let percentUsed: Double
    let formatUsed: () -> String
    let formatTotal: () -> String
    let color: Color

    var body: some View {
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

struct BarChartView: View {
    let title: String
    let percentUsed: Double
    let formatUsed: () -> String
    let formatTotal: () -> String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)

            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 20)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(10)

                Rectangle()
                    .frame(width: CGFloat(percentUsed) * 200, height: 20)
                    .foregroundColor(color)
                    .cornerRadius(10)
                    .animation(.easeInOut(duration: 0.4), value: percentUsed)
            }
            .frame(width: 200)

            Text("\(formatUsed()) / \(formatTotal())")
                .font(.subheadline)
            Text(String(format: "%.1f%% used", percentUsed * 100))
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct StackedChartView: View {
    let title: String
    let percentUsed: Double
    let formatUsed: () -> String
    let formatTotal: () -> String
    let color: Color

    var barCount: Int { 10 }

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)

            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<barCount, id: \.self) { index in
                    Rectangle()
                        .fill(index < Int(percentUsed * Double(barCount)) ? color : Color.gray.opacity(0.2))
                        .frame(width: 12, height: CGFloat(index + 1) * 10)
                        .animation(.easeInOut(duration: 0.4), value: percentUsed)
                }
            }
            .frame(height: 120)

            Text("\(formatUsed()) / \(formatTotal())")
                .font(.subheadline)
            Text(String(format: "%.1f%% used", percentUsed * 100))
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
