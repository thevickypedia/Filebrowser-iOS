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
    let password_hash: String?
    let token: String?
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

    private func deleteShared(_ item: SharedItem) {
        Log.info("Deleting share with hash: \(item.hash)")

        guard let url = URL(string: "\(auth.serverURL)/api/share/\(item.hash)") else {
            Log.error("Invalid delete URL")
            toastMessage = ToastMessagePayload(text: "Invalid delete URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(auth.token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Log.error("Delete request failed: \(error)")
                DispatchQueue.main.async {
                    toastMessage = ToastMessagePayload(text: "Delete failed")
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                Log.error("Invalid response during delete")
                DispatchQueue.main.async {
                    toastMessage = ToastMessagePayload(text: "Invalid server response")
                }
                return
            }

            if httpResponse.statusCode == 200 {
                Log.info("Successfully deleted share: \(item.hash)")
                DispatchQueue.main.async {
                    // Remove the deleted item from the local list
                    sharedContent.removeAll { $0.hash == item.hash }
                    toastMessage = ToastMessagePayload(text: "Deleted share")
                }
            } else {
                Log.error("Delete failed with status: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    toastMessage = ToastMessagePayload(text: "Delete failed (\(httpResponse.statusCode))")
                }
            }
        }.resume()
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
