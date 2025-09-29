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
    case line = "Line"
    case stacked = "Stacked"

    var id: String { rawValue }
}

struct UpTimeStats {
    let bootTime: String
    let bootTimeAgo: String
}

struct MetricsView: View {
    @State private var memoryUsage: GenericUsage?
    @State private var cpuUsage: Double?
    @State private var diskUsage: GenericUsage?

    @AppStorage("memoryChartType") private var memoryChartType: ChartType = .pie
    @AppStorage("cpuChartType") private var cpuChartType: ChartType = .pie
    @AppStorage("diskChartType") private var diskChartType: ChartType = .pie

    @State private var pulseInterval: PulseInterval = .oneSecond
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var lastUpdated: Date = Date()
    @State private var systemUptime: UpTimeStats?
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

    private func getSystemUptimeStats() -> UpTimeStats? {
        guard let upTime = getSystemUptime() else { return nil }
        let bootDate = Date(timeIntervalSince1970: upTime)
        let timeInterval = Date().timeIntervalSince(bootDate)
        let timeZone = TimeZone.current
        let bootTimeAgo = timeAgoString(from: calculateTimeDifference(timeInterval: timeInterval))
        let bootTime = "\(getTimeStamp(from: bootDate, as: "MM/dd/yyyy HH:mm:ss", timezone: timeZone)) \(timeZone.abbreviation() ?? "")"
        return UpTimeStats(bootTime: bootTime, bootTimeAgo: bootTimeAgo)
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
                    if let upTime = systemUptime {
                        VStack {
                            Text("Boot Time")
                                .font(.headline)
                            Spacer()
                            Text(upTime.bootTimeAgo)
                                .font(.subheadline)
                            Text(upTime.bootTime)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    if let memory = memoryUsage {
                        MetricChartView(
                            title: "Memory",
                            used: Double(memory.used),
                            total: Double(memory.total),
                            pulseInterval: pulseInterval,
                            formatUsed: { formatBytes(Int64(memory.used)) },
                            formatTotal: { formatBytes(Int64(memory.total)) },
                            chartType: $memoryChartType,
                            history: history
                        )
                    }

                    if let cpu = cpuUsage {
                        MetricChartView(
                            title: "CPU",
                            used: cpu,
                            total: 100,
                            pulseInterval: pulseInterval,
                            formatUsed: { String(format: "%.1f%%", cpu) },
                            formatTotal: { "100%" },
                            chartType: $cpuChartType,
                            history: history
                        )
                    }

                    if let disk = diskUsage {
                        MetricChartView(
                            title: "Disk",
                            used: Double(disk.used),
                            total: Double(disk.total),
                            pulseInterval: pulseInterval,
                            formatUsed: { formatBytes(Int64(disk.used)) },
                            formatTotal: { formatBytes(Int64(disk.total)) },
                            chartType: $diskChartType,
                            history: history
                        )
                    }
                }
                .padding()
            }

            // Footer with Last Updated
            if pulseInterval == .never {
                Text("Last updated: \(lastUpdated.formatted(.dateTime.hour().minute().second()))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
        }
        .onAppear {
            updateTimer()
            loadData()
            if systemUptime == nil {
                systemUptime = getSystemUptimeStats()
            }
        }
        .onDisappear {
            history.removeAll()
        }
        .onReceive(timer) { _ in
            loadData()
        }
        .onChange(of: pulseInterval) { newInterval in
            if newInterval == .never {
                if memoryChartType == .line {
                    memoryChartType = .bar
                }
                if cpuChartType == .line {
                    cpuChartType = .bar
                }
                if diskChartType == .line {
                    diskChartType = .bar
                }
            }
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
