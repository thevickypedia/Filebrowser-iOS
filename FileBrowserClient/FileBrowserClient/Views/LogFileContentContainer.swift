//
//  LogFileContentContainer.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/23/25.
//

import SwiftUI

func logFileContentView(for logFile: URL) -> some View {
    LogFileContentContainer(logFile: logFile)
}

struct LogFileContentContainer: View {
    let logFile: URL
    @State private var content: String?
    @State private var isLoaded = false
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let content = content {
                ScrollView {
                    CopyableTextContainer(text: content)
                }
            } else if let error = errorMessage {
                VStack(spacing: 8) {
                    Text("Unable to load log file")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Button("Retry") {
                        loadContent()
                    }
                }
            } else {
                ProgressView("Loading log file...")
            }
        }
        .navigationTitle(logFile.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !isLoaded {
                loadContent()
            }
        }
    }

    private func loadContent() {
        isLoaded = true
        errorMessage = nil

        do {
            print("🔍 Loading file: \(logFile.lastPathComponent)")
            content = try String(contentsOf: logFile, encoding: .utf8)
            print("✅ Successfully loaded file, length: \(content?.count ?? 0)")
        } catch {
            print("❌ Error reading file: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}
