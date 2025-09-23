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

enum LogOptions: String {
    case file
    case stdout
}

struct Log {
    static var currentLevel: LogLevel = .trace
    static var verboseMode: Bool = false
    static var logOption: LogOptions = .file

    private static func log(_ message: () -> String,
                            level: LogLevel,
                            label: String,
                            file: String = #fileID,
                            line: Int = #line,
                            function: String = #function) {
        guard level.rawValue >= currentLevel.rawValue else { return }
        // MARK: Only evaluated if level check passes
        let msg = message()
        let paddedLabel = label.padding(toLength: 10, withPad: " ", startingAt: 0)
        var finalLog: String
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
            finalLog = "\(paddedLabel) - \(timestamp()) - \(location) - \(msg)"
        } else {
            finalLog = "\(paddedLabel) - \(timestamp()) - \(msg)"
        }
        switch logOption {
        case .file:
            writeToFile(finalLog)
        case .stdout:
            print(finalLog)
        }
    }

    private static func writeToFile(_ message: String) {
        Task.detached(priority: .utility) {
            let fileManager = FileManager.default
            let logsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let dateString = formatter.string(from: Date())
            let logFileURL = logsDirectory.appendingPathComponent("filebrowser_\(dateString).log")

            let logMessage = message + "\n"

            if fileManager.fileExists(atPath: logFileURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                    fileHandle.seekToEndOfFile()
                    if let data = logMessage.data(using: .utf8) {
                        fileHandle.write(data)
                        fileHandle.closeFile()
                    }
                }
            } else {
                try? logMessage.write(to: logFileURL, atomically: true, encoding: .utf8)
            }
        }
    }

    static func trace(_ message: @autoclosure () -> String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function) {
        log(message, level: .trace, label: "🔍 TRACE", file: file, line: line, function: function)
    }

    static func debug(_ message: @autoclosure () -> String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function) {
        log(message, level: .debug, label: "🐛 DEBUG", file: file, line: line, function: function)
    }

    static func info(_ message: @autoclosure () -> String,
                     file: String = #fileID,
                     line: Int = #line,
                     function: String = #function) {
        log(message, level: .info, label: "ℹ️ INFO", file: file, line: line, function: function)
    }

    static func warn(_ message: @autoclosure () -> String,
                     file: String = #fileID,
                     line: Int = #line,
                     function: String = #function) {
        log(message, level: .warning, label: "⚠️ WARNING", file: file, line: line, function: function)
    }

    static func error(_ message: @autoclosure () -> String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function) {
        log(message, level: .error, label: "❌ ERROR", file: file, line: line, function: function)
    }

    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
