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

    // Check if size has fractional part
    if size.truncatingRemainder(dividingBy: 1) == 0 {
        return String(format: "%.0f %@", size, sizeNames[index])
    } else {
        return String(format: "%.2f %@", size, sizeNames[index])
    }
}

func formatBytes(_ bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useTB, .useGB, .useMB, .useKB]
    formatter.countStyle = .file
    return formatter.string(fromByteCount: bytes)
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
    if fileName.hasSuffix(".md") || fileName.hasSuffix(".markdown") { return "text.alignleft" }
    if fileName.hasSuffix(".csv") || fileName.hasSuffix(".tsv") { return "tablecells" }
    if fileName.hasSuffix(".json") { return "curlybraces" }
    if fileName.hasSuffix(".xml") || fileName.hasSuffix(".plist") { return "chevron.left.slash.chevron.right" }
    if fileName.hasSuffix(".html") || fileName.hasSuffix(".htm") { return "globe" }
    if fileName.hasSuffix(".js") || fileName.hasSuffix(".ts") { return "curlybraces.square" }
    if fileName.hasSuffix(".swift") { return "swift" }
    if fileName.hasSuffix(".py") { return "chevron.left.slash.chevron.right" }
    if fileName.hasSuffix(".sh") || fileName.hasSuffix(".bash") { return "terminal" }
    if fileName.hasSuffix(".rb") { return "diamond.fill" }
    if fileName.hasSuffix(".go") { return "tortoise.fill" }
    if fileName.hasSuffix(".java") { return "cup.and.saucer" }
    if fileName.hasSuffix(".c") || fileName.hasSuffix(".cpp") || fileName.hasSuffix(".h") || fileName.hasSuffix(".hpp") {
        return "hammer"
    }
    if fileName.hasSuffix(".rs") { return "gearshape.2" }
    if fileName.hasSuffix(".scala") { return "square.stack.3d.forward.dottedline" }
    if fileName.hasSuffix(".php") { return "chevron.left.slash.chevron.right" }
    if fileName.hasSuffix(".css") { return "paintbrush" }
    if fileName.hasSuffix(".scss") || fileName.hasSuffix(".sass") { return "scissors" }
    if fileName.hasSuffix(".yml") || fileName.hasSuffix(".yaml") { return "list.bullet.rectangle.portrait" }
    if fileName.hasSuffix(".ini") || fileName.hasSuffix(".config") || fileName.hasSuffix(".conf") { return "gearshape" }
    if fileName.hasSuffix(".log") { return "doc.append" }
    if fileName.hasSuffix(".env") { return "leaf" }
    if fileName.hasSuffix(".bat") || fileName.hasSuffix(".ps1") { return "terminal.fill" }

    // 📚 Office Documents
    if fileName.hasSuffix(".pdf") { return "doc.richtext" }
    if fileName.hasSuffix(".doc") || fileName.hasSuffix(".docx") { return "doc.plaintext" }
    if fileName.hasSuffix(".ppt") || fileName.hasSuffix(".pptx") { return "chart.bar.doc.horizontal" }
    if fileName.hasSuffix(".xls") || fileName.hasSuffix(".xlsx") { return "tablecells.badge.ellipsis" }
    if fileName.hasSuffix(".rtf") || fileName.hasSuffix(".text") { return "doc.text.fill" }

    // 🗜 Archives
    if fileName.hasSuffix(".zip") || fileName.hasSuffix(".tar") || fileName.hasSuffix(".gz") ||
       fileName.hasSuffix(".rar") || fileName.hasSuffix(".7z") || fileName.hasSuffix(".bz2") ||
       fileName.hasSuffix(".xz") || fileName.hasSuffix(".lz") || fileName.hasSuffix(".lzma") {
        return "archivebox"
    }

    // 🎵 Audio
    if extensionTypes.audioExtensions.contains(where: fileName.hasSuffix) {
        return "waveform"
    }
    if fileName.hasSuffix(".flac") || fileName.hasSuffix(".ogg") || fileName.hasSuffix(".oga") {
        return "waveform.circle"
    }
    if fileName.hasSuffix(".mid") || fileName.hasSuffix(".midi") {
        return "music.note"
    }

    // 🎬 Video
    if extensionTypes.videoExtensions.contains(where: fileName.hasSuffix) {
        return "film"
    }
    if fileName.hasSuffix(".avi") || fileName.hasSuffix(".mkv") || fileName.hasSuffix(".flv") || fileName.hasSuffix(".wmv") {
        return "film.stack"
    }

    // 🖼️ Images
    if extensionTypes.imageExtensions.contains(where: fileName.hasSuffix) {
        return "photo"
    }
    if fileName.hasSuffix(".svg") { return "scribble" }
    if fileName.hasSuffix(".ico") || fileName.hasSuffix(".bmp") || fileName.hasSuffix(".tiff") || fileName.hasSuffix(".tif") {
        return "photo.on.rectangle"

    }

    // 🔐 Security
    if fileName.hasSuffix(".pem") || fileName.hasSuffix(".crt") || fileName.hasSuffix(".cer") || fileName.hasSuffix(".key") {
        return "lock.shield"
    }
    if fileName.hasSuffix(".p12") || fileName.hasSuffix(".pfx") {
        return "lock.square.stack"
    }

    // 📦 Package / Installers
    if fileName.hasSuffix(".dmg") || fileName.hasSuffix(".pkg") || fileName.hasSuffix(".msi") || fileName.hasSuffix(".exe") {
        return "shippingbox"
    }
    if fileName.hasSuffix(".app") { return "app" }

    // 🎮 Game-related
    if fileName.hasSuffix(".nes") || fileName.hasSuffix(".sfc") || fileName.hasSuffix(".smc") || fileName.hasSuffix(".gba") {
        return "gamecontroller"
    }

    // 📱 Mobile Assets
    if fileName.hasSuffix(".ipa") || fileName.hasSuffix(".apk") { return "app.badge" }

    // 🧩 Plugins, Extensions, Modules
    if fileName.hasSuffix(".plugin") || fileName.hasSuffix(".bundle") || fileName.hasSuffix(".framework") {
        return "puzzlepiece.extension"
    }

    // ⚙️ Dev Build Files
    if fileName.hasSuffix(".xcodeproj") || fileName.hasSuffix(".xcworkspace") {
        return "hammer.fill"
    }

    // ☁️ Cloud & Sync
    if fileName.hasSuffix(".icloud") {
        return "icloud"
    }

    // 🧪 Others & Catch-All
    if fileName.hasSuffix(".bak") || fileName.hasSuffix(".old") {
        return "clock.arrow.circlepath"
    }
    if fileName.hasSuffix(".tmp") || fileName.hasSuffix(".temp") {
        return "exclamationmark.triangle"
    }

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
    let fileExtnMeta = metadata?.fileExtension ?? file.extension ?? "None"
    return FileInfo(
        name: fileNameMeta,
        path: filePathMeta,
        modified: fileModifiedMeta,
        size: fileSizeMeta,
        extension: fileExtnMeta
    )
}
