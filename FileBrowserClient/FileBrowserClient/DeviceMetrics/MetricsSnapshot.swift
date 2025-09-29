//
//  MetricsSnapshot.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/29/25.
//

import SwiftUI

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
