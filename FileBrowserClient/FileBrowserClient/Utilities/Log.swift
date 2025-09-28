//
//  Log.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/22/25.
//

import Foundation

enum LogLevel: Int, Equatable {
    case trace = 0
    case debug
    case info
    case warning
    case error
}

enum LogOptions: String, Equatable {
    case file
    case stdout
    case both
}

struct Log {
    static var currentLevel: LogLevel = .trace
    static var verboseMode: Bool = false
    static var logOption: LogOptions = .both
    private static let fileWriteQueue = DispatchQueue(label: "log.file.write", qos: .utility)

    static func initialize(logOption: LogOptions = .both,
                           logLevel: LogLevel = .trace,
                           verboseMode: Bool = false) {
        self.currentLevel = logLevel
        self.verboseMode = verboseMode
        self.logOption = logOption
    }

    private static func log(_ message: () -> String,
                            level: LogLevel,
                            label: String,
                            file: String = #fileID,
                            line: Int = #line,
                            function: String = #function) {
        guard level.rawValue >= currentLevel.rawValue else { return }
        // MARK: Only evaluated if level check passes
        let msg = message()
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
            finalLog = "\(timestamp()) - \(location) - \(msg)"
        } else {
            finalLog = "\(timestamp()) - \(msg)"
        }
        switch logOption {
        case .file:
            writeToFile(label: label, message: finalLog)
        case .stdout:
            writeToStdout(label: label, message: finalLog)
        case .both:
            writeToFile(label: label, message: finalLog)
            writeToStdout(label: label, message: finalLog)
        }
    }

    private static func writeToStdout(label: String, message: String) {
        let paddedLabel = label.padding(toLength: 10, withPad: " ", startingAt: 0)
        print("\(paddedLabel) - \(message)")
    }

    private static let logDirectoryURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()

    // Log-specific formatter
    private static let logFileDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = .current
        return formatter
    }()

    // Uses cached formatter instead of recreating one every time
    private static var currentLogFileURL: URL {
        let dateString = logFileDateFormatter.string(from: Date())
        return logDirectoryURL.appendingPathComponent("filebrowser_\(dateString).log")
    }

    private static func writeToFile(label: String, message: String) {
        fileWriteQueue.async {
            let logMessage = "\(label) - \(message)\n"
            let logFileURL = currentLogFileURL

            do {
                if FileManager.default.fileExists(atPath: logFileURL.path) {
                    // Append to existing file
                    let fileHandle = try FileHandle(forWritingTo: logFileURL)
                    defer { fileHandle.closeFile() } // Ensure it's always closed
                    fileHandle.seekToEndOfFile()
                    if let data = logMessage.data(using: .utf8) {
                        fileHandle.write(data)
                    }
                } else {
                    // Create new file
                    try logMessage.write(to: logFileURL, atomically: true, encoding: .utf8)
                }
            } catch {
                // Fallback: print to console if file writing fails
                print("Log file write failed: \(error)")
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
