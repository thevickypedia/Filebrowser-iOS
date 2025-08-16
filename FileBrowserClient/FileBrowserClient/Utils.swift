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

func parseDateTime(from dateString: String, defaultResult: Date? = nil) throws -> Date {
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

func parseGridSize(from fileSize: Int?) -> String? {
    guard let fileSize = fileSize else {
        return "—"
    }
    return sizeConverter(fileSize)
}

func parseGridDate(from dateString: String?, defaultResult: String = "") -> String {
    guard let dateString = dateString else {
        return defaultResult
    }

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
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    }
    Log.error("Invalid date format: \(String(describing: dateString))")
    return defaultResult
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
        let date = try parseDateTime(from: dateString)
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
    let ext = "." + URL(fileURLWithPath: fileName).pathExtension.lowercased()

    // Direct lookup from dictionary
    if let icon = fileExtensionToIconMap[ext] {
        return icon
    }

    // Match against audio/video/image extensions in ExtensionTypes
    if extensionTypes.audioExtensions.contains(where: fileName.hasSuffix) {
        return "waveform"
    }

    if extensionTypes.videoExtensions.contains(where: fileName.hasSuffix) {
        return "film"
    }

    if extensionTypes.imageExtensions.contains(where: fileName.hasSuffix) {
        return "photo"
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
    let fileExtnRaw = metadata?.fileExtension
        ?? file.extension
        ?? URL(fileURLWithPath: file.name).pathExtension
    let fileExtnMeta = fileExtnRaw.trimmingCharacters(in: CharacterSet(charactersIn: ".")).uppercased()
    return FileInfo(
        name: fileNameMeta,
        path: filePathMeta,
        modified: fileModifiedMeta,
        size: fileSizeMeta,
        extension: fileExtnMeta
    )
}

func decodeJWT(jwt: String) -> [String: Any]? {
    let segments = jwt.split(separator: ".")
    guard segments.count == 3 else {
        Log.error("Invalid JWT")
        return nil
    }

    let payloadSegment = segments[1]

    // Pad the base64 string if needed
    var base64String = String(payloadSegment)
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

    // Pad with '=' if needed
    while base64String.count % 4 != 0 {
        base64String += "="
    }

    guard let payloadData = Data(base64Encoded: base64String) else {
        Log.error("Invalid base64 payload")
        return nil
    }

    do {
        let jsonObject = try JSONSerialization.jsonObject(with: payloadData, options: [])
        return jsonObject as? [String: Any]
    } catch {
        Log.error("Error decoding JSON: \(error)")
        return nil
    }
}

func timeStampToString(from timestamp: TimeInterval?) -> String {
    guard let timestamp = timestamp else {
        return "Unknown"
    }
    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, yyyy hh:mm a zzz"
    formatter.timeZone = .current
    return formatter.string(from: date)
}

func timeLeftString(until timestamp: TimeInterval?, asString: Bool = true) -> String {
    guard let timestamp = timestamp else {
        return "Unknown"
    }

    let remaining = Int(timestamp - Date().timeIntervalSince1970)

    guard remaining > 0 else {
        return "Expired"
    }

    let hours = remaining / 3600
    let minutes = (remaining % 3600) / 60
    let seconds = remaining % 60

    if asString {
        return "\(hours) hour\(hours == 1 ? "" : "s"), \(minutes) minute\(minutes == 1 ? "" : "s")"
    } else {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

func deleteSessionMessage(includeKnownServers: Bool) -> Text {
    if includeKnownServers {
        return Text("""
        Continuing will

        1. Clear the list of known servers
        2. Log out the current session
        3. Require a password to log in again
        """)
    } else {
        return Text("""
        Continuing will

        1. Log out the current session
        2. Require a password to log in again
        """)
    }
}

func copyToClipboard(_ text: String) {
    UIPasteboard.general.string = text
    // Replace with your custom alert if needed
    print("Copied text [\(text)] to clipboard!")
}

func urlPath(_ url: URL) -> String {
    var result = url.path
    if let query = url.query, !query.isEmpty {
        result += "?" + query
    }
    return result
}

func buildAPIURL(base: String, pathComponents: [String], queryItems: [URLQueryItem]? = nil) -> URL? {
    guard var url = URL(string: base) else { return nil }

    for component in pathComponents {
        url = url.appendingPathComponent(component.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
    }

    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    if let qItems = queryItems {
        components?.queryItems = qItems
    }

    return components?.url
}
