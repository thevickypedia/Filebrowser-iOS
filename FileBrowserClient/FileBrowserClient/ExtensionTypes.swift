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
        ".bat", ".ps1", ".text", ".rtf", ".py", ".scala", ".rb", ".swift", ".go", ".java", ".c", ".cpp",
        ".h", ".hpp", ".m", ".mm", ".css", ".rs", ".ts", ".md", ".js", ".env",
        ".html", ".htm", ".php", ".sql", ".toml", ".conf", ".cfg", ".plist",
        ".asciidoc", ".adoc", ".tex", ".rst", ".lua", ".pl", ".dart", ".kts",
        ".jsx", ".tsx", ".jsonl", ".ndjson"
    ]
    let videoExtensions: [String] = [
        ".mp4", ".mov", ".m4v"
    ]
    let audioExtensions: [String] = [
        ".mp3", ".wav", ".aac", ".m4a", ".caf"
    ]

    let mediaExtensions: [String]
    let previewExtensions: [String]

    // Custom initializer to safely combine properties
    init() {
        self.mediaExtensions = self.videoExtensions + self.audioExtensions
        self.previewExtensions = self.textExtensions + self.imageExtensions + [".pdf"]
    }
}
