//
//  MetricChartView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/29/25.
//

import SwiftUI

struct MetricChartView: View {
    let title: String
    let used: Double
    let total: Double
    let pulseInterval: PulseInterval  // <-- rename to camelCase for Swift style
    let formatUsed: () -> String
    let formatTotal: () -> String

    @Binding var chartType: ChartType
    let history: [MetricsSnapshot]

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

    // Filtered chart types based on pulseInterval
    var availableChartTypes: [ChartType] {
        if pulseInterval == .never {
            return ChartType.allCases.filter { $0 != .line }
        }
        return ChartType.allCases
    }

    var body: some View {
        VStack(spacing: 16) {
            Picker("Chart Type", selection: $chartType) {
                ForEach(availableChartTypes) { type in
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
            case .line:
                LineChartView(
                    title: title,
                    values: liveValues(),
                    maxValue: 100,
                    color: color
                )
            }
        }
    }

    func liveValues() -> [Double] {
        switch title {
        case "CPU":
            return history.compactMap { $0.cpu?.percentUsed }.map { $0 * 100 }
        case "Memory":
            return history.compactMap { $0.memory?.percentUsed }.map { $0 * 100 }
        case "Disk":
            return history.compactMap { $0.disk?.percentUsed }.map { $0 * 100 }
        default:
            return []
        }
    }
}
