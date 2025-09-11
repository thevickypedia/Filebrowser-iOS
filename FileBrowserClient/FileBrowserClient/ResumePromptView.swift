//
//  ResumePromptView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/11/25.
//

import SwiftUI

struct ResumePromptView: View {
    let resumeTimeFormatted: String
    let onSelection: (Bool) -> Void  // true = from beginning, false = resume

    init(resumeTimeFormatted: String, onSelection: @escaping (Bool) -> Void) {
        self.resumeTimeFormatted = resumeTimeFormatted
        self.onSelection = onSelection
        Log.debug("🧪 ResumePromptView initialized with time: \(resumeTimeFormatted)")
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Resume Playback?")
                .font(.headline)
            Text("Would you like to resume from \(resumeTimeFormatted) or start from the beginning?")
                .multilineTextAlignment(.center)

            HStack {
                Button("Start Over") {
                    onSelection(true)
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)

                Button("Resume from \(resumeTimeFormatted)") {
                    onSelection(false)
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
    }
}
