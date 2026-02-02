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

struct ServerResponse {
    let success: Bool
    let text: String
    var statusCode: Int = 0
}

func convertStringToHex(_ str: String) -> String {
    return str.unicodeScalars.map {
        let hex = String($0.value, radix: 16)
        return String(repeating: "0", count: 4 - hex.count) + hex
    }.joined(separator: "\\u")
}

func sanitizer(_ input: String, replacement: Character = "_") -> String {
    let allowed = CharacterSet.alphanumerics
    let replaced = input.map { char in
        String(char).rangeOfCharacter(from: allowed) != nil ? char : replacement
    }
    let collapsed = String(replaced)
        .replacingOccurrences(of: "\(replacement)+", with: String(replacement), options: .regularExpression)
        .trimmingCharacters(in: CharacterSet(charactersIn: String(replacement)))
    return collapsed
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
    formatter.allowedUnits = [.useAll]
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
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")

    for format in Constants.dateTimeFormats {
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

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")

    for format in Constants.dateTimeFormats {
        formatter.dateFormat = format
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    }
    Log.error("Invalid date format: \(String(describing: dateString))")
    return defaultResult
}

func calculateTimeDifference(dateString: String? = nil, timeInterval: TimeInterval? = nil) -> [String: Double] {
    let defaultResult: [String: Double] = [
        "seconds": 0.0,
        "minutes": 0.0,
        "hours": 0.0,
        "days": 0.0,
        "weeks": 0.0,
        "months": 0.0,
        "years": 0.0
    ]

    var finalInterval: TimeInterval

    if let dateString = dateString {
        do {
            let date = try parseDateTime(from: dateString)
            let now = Date()
            finalInterval = abs(now.timeIntervalSince(date))
        } catch {
            Log.error("Invalid date format: \(dateString)")
            return defaultResult
        }
    } else if let interval = timeInterval {
        finalInterval = abs(interval)
    } else {
        Log.warn("Both dateString and timeInterval are nil.")
        return defaultResult
    }

    return [
        "seconds": finalInterval,
        "minutes": finalInterval / 60,
        "hours": finalInterval / 3600,
        "days": finalInterval / (24 * 3600),
        "weeks": finalInterval / (7 * 24 * 3600),
        "months": finalInterval / (30 * 24 * 3600), // Approximate
        "years": finalInterval / (365 * 24 * 3600)  // Approximate
    ]
}

func systemIcon(for fileName: String, extensionTypes: ExtensionTypes) -> String? {
    let lower = fileName.lowercased()
    let ext = "." + URL(fileURLWithPath: lower).pathExtension

    // 1) Exact map hit first
    if let icon = fileExtensionToIconMap[ext] { return icon }

    // 2) Match against audio/video/image extensions in ExtensionTypes
    if extensionTypes.audioExtensions.contains(where: lower.hasSuffix) {
        return "waveform"
    }

    if extensionTypes.videoExtensions.contains(where: lower.hasSuffix) {
        return "film"
    }

    if extensionTypes.imageExtensions.contains(where: lower.hasSuffix) {
        return "photo"
    }

    return nil
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
    let dateFormatExact = auth.tokenPayload?.user.dateFormat ?? false
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

func decodeJWT(jwt: String) -> JWTPayload? {
    let segments = jwt.components(separatedBy: ".")
    guard segments.count == 3 else {
        Log.error("Invalid JWT token")
        return nil
    }

    let payloadSegment = segments[1]

    // Add padding if necessary
    var base64 = payloadSegment
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

    let requiredLength = 4 * ((base64.count + 3) / 4)
    base64 = base64.padding(toLength: requiredLength, withPad: "=", startingAt: 0)

    guard let payloadData = Data(base64Encoded: base64) else {
        Log.error("Failed to decode base64")
        return nil
    }

    do {
        let decoder = JSONDecoder()
        let payload = try decoder.decode(JWTPayload.self, from: payloadData)
        return payload
    } catch {
        Log.error("Failed to parse JWT: \(error.localizedDescription)")
        return nil
    }

//    guard let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
//          let payload = json as? [String: Any] else {
//        Log.error("Failed to parse JSON")
//        return nil
//    }
//
//    return payload
}

func timeStampToString(from timestamp: TimeInterval?) -> String {
    guard let timestamp = timestamp else {
        return "Unknown"
    }
    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, yyyy hh:mm a zzz"
    formatter.timeZone = Constants.timezone
    return formatter.string(from: date)
}

func pluralize(_ count: Int, _ identifier: String) -> String {
    return "\(count) \(identifier)\(count == 1 ? "" : "s")"
}

func timeLeftString(until timestamp: TimeInterval?, asString: Bool = true, limit: Int = 2) -> String {
    guard let timestamp = timestamp else {
        return "Unknown"
    }

    let remaining = Int(timestamp - Date().timeIntervalSince1970)

    guard remaining > 0 else {
        return "Expired"
    }

    let secondsInYear = 365 * 24 * 3600
    let secondsInMonth = 30 * 24 * 3600
    let secondsInWeek = 7 * 24 * 3600
    let secondsInDay = 24 * 3600
    let secondsInHour = 3600
    let secondsInMinute = 60

    let years = remaining / secondsInYear
    let months = (remaining % secondsInYear) / secondsInMonth
    let weeks = (remaining % secondsInMonth) / secondsInWeek
    let days = (remaining % secondsInWeek) / secondsInDay
    let hours = (remaining % secondsInDay) / secondsInHour
    let minutes = (remaining % secondsInHour) / secondsInMinute
    let seconds = remaining % secondsInMinute

    if asString {
        var components: [String] = []
        if years > 0 {
            components.append(pluralize(years, "year"))
        }
        if months > 0 {
            components.append(pluralize(months, "month"))
        }
        if weeks > 0 {
            components.append(pluralize(weeks, "week"))
        }
        if days > 0 {
            components.append(pluralize(days, "day"))
        }
        if hours > 0 {
            components.append(pluralize(hours, "hour"))
        }
        if minutes > 0 {
            components.append(pluralize(minutes, "minute"))
        }
        if components.isEmpty {
            // If seconds is the only option
            components.append(pluralize(seconds, "second"))
        }
        return components.prefix(limit).joined(separator: ", ")
    } else {
        // Digital format: hh:mm:ss (as before)
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
    Log.debug("Copied text [\(text)] to clipboard!")
}

func logJsonData(data: Data, parseJSON: Bool = false) -> Bool {
    if let jsonString = String(data: data, encoding: .utf8) {
        Log.info("JSON string: \(jsonString)")
        if parseJSON {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                Log.info("Parsed JSON: \(jsonObject)")
            } catch {
                Log.error("Failed to parse JSON: \(error)")
                return false
            }
        }
        return true
    } else {
        Log.error("Failed to convert data to UTF-8 string")
        return false
    }
}

func unsafeFileSize(byteSize: Int?) -> String? {
    if let fileSize = byteSize {
        let formattedSizeLimit = formatBytes(Int64(Constants.previewSizeLimit))
        let formattedFileSize = formatBytes(Int64(fileSize))
        if fileSize < Constants.previewSizeLimit {
            Log.debug("✅ File size [\(formattedFileSize)] within limit \(formattedSizeLimit)")
            return nil
        }
        let warning = "⚠️ File size [\(formattedFileSize)] exceeded preview limit \(formattedSizeLimit)"
        Log.warn(warning)
        return warning
    } else {
        let warning = "⚠️ Unable to get file size, preview not available."
        Log.warn(warning)
        return warning
    }
}

func getTimeStamp(from date: Date? = nil, as customFormat: String = "MMddyyyy_HHmmss") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = customFormat
    formatter.timeZone = Constants.timezone
    if let customDate = date {
        return formatter.string(from: customDate)
    }
    return formatter.string(from: Date())
}

func getServerVersion(baseRequest: Request) async -> ServerResponse {
    guard let preparedRequest = baseRequest.prepare(
        pathComponents: ["api", "version"],
        method: .post
    ) else {
        return ServerResponse(success: false, text: "Failed to prepare request for: /version")
    }

    do {
        let (data, response) = try await preparedRequest.session.data(for: preparedRequest.request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return ServerResponse(success: false, text: "Invalid response")
        }
        let responseText = formatHttpResponse(httpResponse)
        guard httpResponse.statusCode == 200 else {
            return ServerResponse(success: false, text: responseText)
        }
        guard let responseData = String(data: data, encoding: .utf8) else {
            return ServerResponse(success: false, text: responseText)
        }
        return ServerResponse(success: true, text: responseData)
    } catch {
        return ServerResponse(success: false, text: error.localizedDescription)
    }
}

func checkServerHealth(baseRequest: Request) async -> ServerResponse {
    guard let preparedRequest = baseRequest.prepare(pathComponents: ["health"]) else {
        return ServerResponse(success: false, text: "Failed to prepare request for: /health")
    }

    do {
        let (data, response) = try await preparedRequest.session.data(for: preparedRequest.request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return ServerResponse(success: false, text: "Invalid response")
        }
        let responseText = formatHttpResponse(httpResponse)
        guard httpResponse.statusCode == 200 else {
            return ServerResponse(success: false, text: responseText, statusCode: httpResponse.statusCode)
        }
        guard let responseData = String(data: data, encoding: .utf8) else {
            return ServerResponse(success: true, text: responseText, statusCode: httpResponse.statusCode)
        }
        return ServerResponse(success: true, text: responseData, statusCode: httpResponse.statusCode)
    } catch {
        return ServerResponse(success: false, text: error.localizedDescription)
    }
}

func processFileExporterResponse(fileURL: URL, exportResult: FileExportResult) -> ToastMessagePayload {
    if exportResult.completed {
        var msg = "✔️ Export successful"
        if let activityType = exportResult.activityType?.rawValue {
            msg += " through \(activityType.components(separatedBy: ".").last ?? activityType)"
        }
        Log.debug(msg + ": [\(fileURL.lastPathComponent)]")
        return ToastMessagePayload(text: msg, color: .green)
    } else if let error = exportResult.error {
        let msg = "✖️ Failed to export - \(error.localizedDescription)"
        Log.error(msg + ": [\(fileURL.lastPathComponent)]")
        return ToastMessagePayload(text: msg, color: .red)
    } else {
        let msg = "➖ Export cancelled"
        Log.warn(msg + ": [\(fileURL.lastPathComponent)]")
        return ToastMessagePayload(text: msg, color: .yellow)
    }
}

func formatHttpResponse(_ httpResponse: HTTPURLResponse) -> String {
    return "[\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
}
