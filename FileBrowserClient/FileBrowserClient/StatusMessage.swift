//
//  StatusMessage.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/7/25.
//


import SwiftUI

struct StatusPayload {
    var text: String?
    var color: Color = .green
    var duration: TimeInterval = 2.5
}

struct StatusMessage: ViewModifier {
    @Binding var payload: StatusPayload?

    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if let text = payload?.text {
                Text(text)
                    .font(.caption)
                    .foregroundColor(payload?.color ?? .green)
                    .padding()
                    .background(Color(.systemBackground).opacity(0.9))
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .padding(.bottom, 20)
                    .transition(.opacity)
                    .animation(.easeInOut, value: text)
                    .onTapGesture {
                        withAnimation {
                            cancelAutoDismiss()
                            payload?.text = nil
                        }
                    }
                    .onAppear {
                        scheduleAutoDismiss()
                    }
                    .onChange(of: text) { _ in
                        scheduleAutoDismiss()
                    }
            }
        }
        .onDisappear {
            cancelAutoDismiss()
        }
    }

    private func scheduleAutoDismiss() {
        cancelAutoDismiss()
        guard payload?.text != nil else { return }

        let task = DispatchWorkItem {
            withAnimation {
                payload?.text = nil
            }
        }
        workItem = task
        
        let duration = payload?.duration ?? 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }

    private func cancelAutoDismiss() {
        workItem?.cancel()
        workItem = nil
    }
}
