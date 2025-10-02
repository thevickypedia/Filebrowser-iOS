//
//  ShareManagementView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 10/1/25.
//

import SwiftUI

struct SharedItem: Codable, Identifiable, Hashable {
    let hash: String
    let path: String
    let userID: Int
    let expire: Int
    // Local-only ID for SwiftUI
    var id: String { hash }
}

struct ShareManagementView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var sharedContent: [SharedItem] = []
    @State private var toastMessage: ToastMessagePayload?

    private func fetchSharedContent() {
        guard let url = URL(string: "\(auth.serverURL)/api/shares") else {
            Log.error("Invalid server URL")
            toastMessage = ToastMessagePayload(text: "Invalid server URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(auth.token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Log.error("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    toastMessage = ToastMessagePayload(text: "Network error")
                }
                return
            }

            guard let data = data else {
                Log.error("No data received")
                DispatchQueue.main.async {
                    toastMessage = ToastMessagePayload(text: "No data received")
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([SharedItem].self, from: data)
                DispatchQueue.main.async {
                    sharedContent = decoded
                }
            } catch {
                Log.error("Failed to decode response: \(error)")
                DispatchQueue.main.async {
                    toastMessage = ToastMessagePayload(text: "Failed to decode response")
                }
            }
        }.resume()
    }

    private func deleteShared(_ link: SharedItem) {
        Log.info("Deleting \(link)")
    }

    var body: some View {
        NavigationView {
            List {
                // Section for file list or empty state
                Section {
                    if sharedContent.isEmpty {
                        Text("❌ No content shared")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach($sharedContent, id: \.self) { $sharedPath in
                            HStack {
                                Text(sharedPath.path)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    UIPasteboard.general.string = "\(auth.serverURL)/share/\(sharedPath.hash)"
                                    toastMessage = ToastMessagePayload(text: "📋 Copied to clipboard", color: .primary)
                                } label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                                .tint(.blue)
                            }
                        }
                        .onDelete { indexSet in
                            let filesToDelete = indexSet.map { sharedContent[$0] }
                            filesToDelete.forEach { deleteShared($0) }
                            sharedContent.remove(atOffsets: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("Shared Content")
            .modifier(ToastMessage(payload: $toastMessage))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        fetchSharedContent()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear {
                if sharedContent.isEmpty {
                    Log.debug("Updating shared content queue")
                    fetchSharedContent()
                }
            }
        }
    }
}
