//
//  MetricsView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/27/25.
//

import SwiftUI

enum PulseInterval: String, CaseIterable, Identifiable {
    case halfSecond = "0.5s"
    case oneSecond = "1s"
    case threeSeconds = "3s"
    case fiveSeconds = "5s"
    case tenSeconds = "10s"
    case never = "Never"

    var id: String { rawValue }

    var interval: TimeInterval? {
        switch self {
        case .halfSecond: return 0.5
        case .oneSecond: return 1
        case .threeSeconds: return 3
        case .fiveSeconds: return 5
        case .tenSeconds: return 10
        case .never: return nil
        }
    }
}

enum ChartType: String, CaseIterable, Identifiable {
    case pie = "Pie"
    case bar = "Bar"
    case stacked = "Stacked"

    var id: String { rawValue }
}

struct MetricsSnapshot: Codable {
    let timestamp: Date
    let memory: UsageMetric?
    let cpu: UsageMetric?
    let disk: UsageMetric?

    struct UsageMetric: Codable {
        let used: String
        let total: String
        let percentUsed: Double
    }

    static func from(memory: MemoryUsage?, cpu: Double?, disk: (used: UInt64, total: UInt64)?) -> MetricsSnapshot {
        func format(_ used: Double, _ total: Double) -> UsageMetric {
            return UsageMetric(
                used: formatBytes(Int64(used)),
                total: formatBytes(Int64(total)),
                percentUsed: total > 0 ? used / total : 0
            )
        }

        return MetricsSnapshot(
            timestamp: Date(),
            memory: memory.map { format(Double($0.used), Double($0.total)) },
            cpu: cpu.map { UsageMetric(used: String(format: "%.1f%%", $0), total: "100%", percentUsed: $0 / 100) },
            disk: disk.map { format(Double($0.used), Double($0.total)) }
        )
    }
}

struct MetricsView: View {
    @State private var memoryUsage: MemoryUsage?
    @State private var cpuUsage: Double?
    @State private var diskUsage: (used: UInt64, total: UInt64)?

    @AppStorage("memoryChartType") private var memoryChartType: ChartType = .pie
    @AppStorage("cpuChartType") private var cpuChartType: ChartType = .pie
    @AppStorage("diskChartType") private var diskChartType: ChartType = .pie

    @State private var pulseInterval: PulseInterval = .halfSecond
    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var lastUpdated: Date = Date()
    @State private var presentExportSheet = false
    @State private var exportURL: URL?

    @State private var toastMessage: ToastMessagePayload?
    @State private var errorTitle: String?
    @State private var errorMessage: String?

    @State private var history: [MetricsSnapshot] = []

    private func exportSnapshot() -> URL? {
        let snapshot = MetricsSnapshot.from(
            memory: memoryUsage,
            cpu: cpuUsage,
            disk: diskUsage
        )

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601

            let data = try encoder.encode(snapshot)

            let filename = "SystemMetrics_\(getTimeStamp()).json"
            Log.info("Exporting device metrics snapshot as \(filename)")
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
            try data.write(to: url)

            return url
        } catch {
            let msg = "Failed to export metrics: \(error.localizedDescription)"
            errorTitle = "Internal Error"
            errorMessage = msg
            Log.error(msg)
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar with Manual Refresh and Pulse
            HStack {
                if pulseInterval == .never {
                    Button(action: {
                        loadData()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .padding(.leading)
                }

                Menu {
                    ForEach(PulseInterval.allCases) { interval in
                        Button(action: {
                            pulseInterval = interval
                            updateTimer()
                        }) {
                            if pulseInterval == interval {
                                Label(interval.rawValue, systemImage: "checkmark")
                            } else {
                                Text(interval.rawValue)
                            }
                        }
                    }
                } label: {
                    Label("Pulse: \(pulseInterval.rawValue)", systemImage: "waveform.path.ecg")
                        .padding(.horizontal)
                }

                Spacer()

                Button(action: {
                    exportURL = exportSnapshot()
                    presentExportSheet = exportURL != nil
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .padding(.top)

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

                    if !history.isEmpty {
                        Section(header: Text("Live CPU Pulse")) {
                            PulseLineChart(
                                values: history.compactMap { $0.cpu.map { $0.percentUsed * 100 } },
                                maxValue: 100
                            )
                        }
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
            }

            // Footer with Last Updated
            Text("Last updated: \(lastUpdated.formatted(.dateTime.hour().minute().second()))")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
        .onAppear {
            updateTimer()
            loadData()
        }
        .onReceive(timer) { _ in
            loadData()
        }
        .sheet(isPresented: $presentExportSheet) {
            if let url = exportURL {
                FileExporter(fileURL: url) { exportResult in
                    toastMessage = processFileExporterResponse(fileURL: url, exportResult: exportResult)
                }
            } else {
                ProgressView("Generating Snapshot")
            }
        }
        .modifier(ToastMessage(payload: $toastMessage))
        .modifier(ErrorAlert(title: $errorTitle, message: $errorMessage))
    }

    private func loadData() {
        memoryUsage = getMemoryUsage()
        cpuUsage = getCPUUsage()
        diskUsage = getDiskUsage()
        lastUpdated = Date()

        history.append(MetricsSnapshot.from(
            memory: memoryUsage,
            cpu: cpuUsage,
            disk: diskUsage
        ))

        // Optional: keep only last 100 data points
        if history.count > 100 {
            history.removeFirst()
        }
    }

    private func updateTimer() {
        timer.upstream.connect().cancel()
        if let interval = pulseInterval.interval {
            timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
        }
    }
}

struct PulseLineChart: View {
    let values: [Double] // e.g., [12.5, 25.0, 30.0, 50.0]
    let maxValue: Double

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            let stepX = width / CGFloat(max(values.count - 1, 1))
            let scaleY = maxValue > 0 ? height / maxValue : 0

            Path { path in
                for (index, value) in values.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = height - CGFloat(value) * scaleY
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.green, lineWidth: 2)
            .animation(.easeOut(duration: 0.3), value: values)
        }
        .frame(height: 80)
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
