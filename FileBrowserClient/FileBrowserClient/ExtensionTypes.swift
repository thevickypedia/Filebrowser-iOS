//
//  ExtensionTypes.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/28/25.
//

struct ExtensionTypes {
    let imageExtensions: [String] = [
        ".png", ".jpg", ".jpeg", ".webp", ".avif", ".heif", ".heic", ".gif"
    ]
    let textExtensions: [String] = [
        ".txt", ".log", ".json", ".yaml", ".xml", ".yml", ".csv", ".tsv", ".ini", ".properties", ".sh",
        ".bat", ".ps1", ".psd", ".psb", ".text", ".rtf", ".doc", ".docx", ".xls", ".xlsx", ".ppt",
        ".py", ".scala", ".rb", ".swift", ".go", ".java", ".c", ".cpp", ".h", ".hpp", ".m", ".mm",
        ".java", ".css", ".rs", ".ts"
    ]
    let videoExtensions: [String] = [
        ".mp4", ".mov"
    ]
    let audioExtensions: [String] = [
        ".mp3", ".wav", ".aac", ".ogg", ".m4a"
    ]
    
    let mediaExtensions: [String]
    let previewExtensions: [String]
    let cacheExtensions: [String]

    // Custom initializer to safely combine properties
    init() {
        self.mediaExtensions = self.videoExtensions + self.audioExtensions
        self.previewExtensions = self.textExtensions + self.imageExtensions + [".pdf"]
        self.cacheExtensions = [".pdf"] + self.imageExtensions
    }
}
