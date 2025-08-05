//
//  Utils.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/29/25.
//

import SwiftUI

enum ValidationError: Error {
    case invalidDateFormat
}

func sizeConverter(_ byteSize: Int?) -> String {
    guard let byteSize = byteSize, byteSize >= 0 else {
        return "Unknown"
    }

    let sizeNames = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
    var index = 0
    var size = Double(byteSize)

    while size >= 1024.0 && index < sizeNames.count - 1 {
        size /= 1024.0
        index += 1
    }

    return String(format: "%.2f %@", size, sizeNames[index])
}

func timeAgoString(from diff: [String: Double]) -> String {
    let seconds = Int(diff["seconds"] ?? 0)
    let minutes = Int(diff["minutes"] ?? 0)
    let hours = Int(diff["hours"] ?? 0)
    let days = Int(diff["days"] ?? 0)
    let weeks = Int(diff["weeks"] ?? 0)
    // let months = Int(diff["months"] ?? 0)
    // let years = Int(diff["years"] ?? 0)

    switch true {
    // case years >= 1:
    //    return "\(years) year\(years == 1 ? "" : "s") ago"
    // case months >= 1:
    //    return "\(months) month\(months == 1 ? "" : "s") ago"
    case weeks >= 1:
        return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
    case days >= 1:
        return "\(days) day\(days == 1 ? "" : "s") ago"
    case hours >= 1:
        return "\(hours) hour\(hours == 1 ? "" : "s") ago"
    case minutes >= 1:
        return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
    case seconds >= 10:
        return "\(seconds) seconds ago"
    case seconds >= 1:
        return "Just now"
    default:
        return "Unknown"
    }
}

func parseDate(from dateString: String, defaultResult: Date? = nil) throws -> Date {
    let formats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX",  // SSSSSS → 6 digits of fractional seconds
        "yyyy-MM-dd'T'HH:mm:ssXXXXX",         // ISO 8601 with timezone
        "yyyy-MM-dd'T'HH:mm:ssZ",             // ISO 8601 with Z
        "yyyy-MM-dd HH:mm:ss",                // Common DB format
        "yyyy/MM/dd HH:mm:ss",
        "MM/dd/yyyy HH:mm:ss",
        "dd-MM-yyyy HH:mm:ss",
        "yyyy-MM-dd",
        "MM/dd/yyyy",
        "dd-MM-yyyy"
    ]

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")

    for format in formats {
        formatter.dateFormat = format
        if let date = formatter.date(from: dateString) {
            return date
        }
    }

    guard let date = defaultResult else {
        throw ValidationError.invalidDateFormat
    }
    return date
}

func calculateTimeDifference(dateString: String?) -> [String: Double] {
    let defaultResult: [String: Double] = [
        "seconds": 0.0,
        "minutes": 0.0,
        "hours": 0.0,
        "days": 0.0,
        "weeks": 0.0,
        "months": 0.0,
        "years": 0.0
    ]

    guard let dateString = dateString else {
        Log.warn("Input dateString is nil.")
        return defaultResult
    }

    do {
        let date = try parseDate(from: dateString)
        let now = Date()
        let timeInterval = abs(now.timeIntervalSince(date)) // in seconds

        return [
            "seconds": timeInterval,
            "minutes": timeInterval / 60,
            "hours": timeInterval / 3600,
            "days": timeInterval / (24 * 3600),
            "weeks": timeInterval / (7 * 24 * 3600),
            "months": timeInterval / (30 * 24 * 3600), // Approximate
            "years": timeInterval / (365 * 24 * 3600) // Approximate
        ]
    } catch {
        Log.error("Invalid date format: \(dateString)")
        return defaultResult
    }
}

func systemIcon(for fileName: String, extensionTypes: ExtensionTypes) -> String? {
    // 📄 Text & Code
    if fileName.hasSuffix(".txt") { return "doc.text" }
    if fileName.hasSuffix(".md") { return "text.alignleft" }
    if fileName.hasSuffix(".csv") { return "tablecells" }
    if fileName.hasSuffix(".json") { return "curlybraces" }
    if fileName.hasSuffix(".xml") { return "chevron.left.slash.chevron.right" }
    if fileName.hasSuffix(".html") || fileName.hasSuffix(".htm") {
        return "globe"
    }
    if fileName.hasSuffix(".js") || fileName.hasSuffix(".ts") {
        return "curlybraces.square"
    }
    if fileName.hasSuffix(".swift") { return "swift" }
    if fileName.hasSuffix(".py") { return "chevron.left.slash.chevron.right" }
    if fileName.hasSuffix(".sh") { return "terminal" }

    // 📚 Documents
    if fileName.hasSuffix(".pdf") { return "doc.richtext" }
    if fileName.hasSuffix(".doc") || fileName.hasSuffix(".docx") {
        return "doc.plaintext"
    }
    if fileName.hasSuffix(".ppt") || fileName.hasSuffix(".pptx") {
        return "chart.bar.doc.horizontal"
    }
    if fileName.hasSuffix(".xls") || fileName.hasSuffix(".xlsx") {
        return "tablecells.badge.ellipsis"
    }

    // 🗜 Archives
    if fileName.hasSuffix(".zip") || fileName.hasSuffix(".tar") || fileName.hasSuffix(".gz") || fileName.hasSuffix(".rar") {
        return "archivebox"
    }

    // 🎵 Audio
    if extensionTypes.audioExtensions.contains(where: fileName.hasSuffix) {
        return "waveform"
    }

    // 🎬 Video
    if extensionTypes.videoExtensions.contains(where: fileName.hasSuffix) {
        return "film"
    }

    // 🖼️ Images
    if extensionTypes.imageExtensions.contains(where: fileName.hasSuffix) {
        return "photo"
    }
    if fileName.hasSuffix(".svg") { return "scribble" }

    // 🔐 Certs & Keys
    if fileName.hasSuffix(".pem") || fileName.hasSuffix(".crt") || fileName.hasSuffix(".key") {
        return "lock.shield"
    }

    // 🧪 Misc
    if fileName.hasSuffix(".log") { return "doc.append" }
    if fileName.hasSuffix(".conf") { return "gearshape" }
    if fileName.hasSuffix(".env") { return "leaf" }

    return nil
}

func removePrefix(urlPath: String) -> String {
    return urlPath.hasPrefix("/") ? String(urlPath.dropFirst()) : urlPath
}

func getCacheExtensions(advancedSettings: AdvancedSettings, extensionTypes: ExtensionTypes) -> [String] {
    var cacheExtensions: [String] = []
    if advancedSettings.cachePDF {
        cacheExtensions.append(".pdf")
    }
    if advancedSettings.cacheImage {
        cacheExtensions.append(contentsOf: extensionTypes.imageExtensions)
    }
    if advancedSettings.cacheText {
        cacheExtensions.append(contentsOf: extensionTypes.textExtensions)
    }
    return cacheExtensions
}

struct FileInfo {
    let name: String
    let path: String
    let modified: String
    let size: String
    let `extension`: String
}

func getFileInfo(metadata: ResourceMetadata?, file: FileItem, auth: AuthManager) -> FileInfo {
    let fileNameMeta = metadata?.name ?? file.name
    let filePathMeta = metadata?.path ?? file.path
    let modified = metadata?.modified ?? file.modified
    let dateFormatExact = auth.userAccount?.dateFormat ?? false
    let fileModifiedMeta = dateFormatExact
        ? (modified ?? "Unknown")
        : timeAgoString(from: calculateTimeDifference(dateString: modified))
    let fileSizeMeta = sizeConverter(metadata?.size ?? file.size)
    let fileExtnMeta = metadata?.extension_ ?? file.extension ?? "None"
    return FileInfo(
        name: fileNameMeta,
        path: filePathMeta,
        modified: fileModifiedMeta,
        size: fileSizeMeta,
        extension: fileExtnMeta
    )
}
