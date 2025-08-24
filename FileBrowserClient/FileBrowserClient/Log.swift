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
    static var currentLevel: LogLevel = .error
    static var verboseMode: Bool = false

    private static func log(_ message: @autoclosure () -> String,
                            level: LogLevel,
                            label: String,
                            file: String = #fileID,
                            line: Int = #line,
                            function: String = #function) {
        guard level.rawValue >= currentLevel.rawValue else { return }
        // MARK: Only evaluated if level check passes
        let msg = message()
        if verboseMode {
            let location = "\(file):\(line) \(function)"
            print("\(label) [\(timestamp())] [\(location)] \(msg)")
        } else {
            print("\(label) [\(timestamp())] \(msg)")
        }
    }

    static func debug(_ message: @autoclosure () -> String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function) {
        log(message(), level: .debug, label: "🐛 DEBUG", file: file, line: line, function: function)
    }

    static func info(_ message: @autoclosure () -> String,
                     file: String = #fileID,
                     line: Int = #line,
                     function: String = #function) {
        log(message(), level: .info, label: "ℹ️ INFO", file: file, line: line, function: function)
    }

    static func warn(_ message: @autoclosure () -> String,
                     file: String = #fileID,
                     line: Int = #line,
                     function: String = #function) {
        log(message(), level: .warning, label: "⚠️ WARNING", file: file, line: line, function: function)
    }

    static func error(_ message: @autoclosure () -> String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function) {
        log(message(), level: .error, label: "❌ ERROR", file: file, line: line, function: function)
    }

    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
