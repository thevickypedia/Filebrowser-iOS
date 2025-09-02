//
//  Log.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/22/25.
//

import Foundation

enum LogLevel: Int {
    case trace = 0
    case debug
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
        let paddedLabel = label.padding(toLength: 10, withPad: " ", startingAt: 0)
        if verboseMode {
            let fileName = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
            let functionName: String = {
                let pattern = #"^(\w+)"#
                if let match = function.range(of: pattern, options: .regularExpression) {
                    return String(function[match])
                }
                return function // fallback
            }()
            let location = "[\(fileName):\(line)] - \(functionName)"
            print("\(paddedLabel) - \(timestamp()) - \(location) - \(msg)")
        } else {
            print("\(paddedLabel) - \(timestamp()) - \(msg)")
        }
    }

    static func trace(_ message: @autoclosure () -> String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function) {
        log(message(), level: .trace, label: "🔍 TRACE", file: file, line: line, function: function)
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
