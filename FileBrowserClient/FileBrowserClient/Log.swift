//
//  Log.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/22/25.
//

import Foundation

enum LogLevel: Int {
    case debug = 0
    case info
    case warning
    case error
}

struct Log {
    static var currentLevel: LogLevel = .warning

    private static func log(_ message: String, level: LogLevel, label: String) {
        guard level.rawValue >= currentLevel.rawValue else { return }
        print("\(label) [\(timestamp())] \(message)")
    }

    static func debug(_ message: String) {
        log(message, level: .debug, label: "🐛 DEBUG")
    }

    static func info(_ message: String) {
        log(message, level: .info, label: "ℹ️ INFO")
    }

    static func warn(_ message: String) {
        log(message, level: .warning, label: "⚠️ WARNING")
    }

    static func error(_ message: String) {
        log(message, level: .error, label: "❌ ERROR")
    }

    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
