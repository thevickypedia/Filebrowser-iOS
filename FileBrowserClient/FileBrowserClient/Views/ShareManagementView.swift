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
    let expire: TimeInterval
    let passwordHash: String?
    let token: String?

    var id: String { hash }

    private enum CodingKeys: String, CodingKey {
        case hash
        case path
        case userID
        case expire
        case passwordHash = "password_hash"
        case token
    }
}

struct ShareManagementView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var sharedContent: [SharedItem] = []
    @State private var toastMessage: ToastMessagePayload?
    @State private var errorTitle: String?
    @State private var errorMessage: String?
    @State private var expandedPaths: Set<String> = []

    private func fetchSharedContent() {
        let baseRequest = Request(auth: auth)
        guard let preparedRequest = baseRequest.prepare(path: "/api/shares") else {
            errorTitle = "Internal Error"
            errorMessage = "Invalid Server URL: \(auth.serverURL)/api/shares"
            return
        }

        preparedRequest.session.dataTask(with: preparedRequest.request) { data, _, error in
            if let error = error {
                Log.error("Network error: \(error.localizedDescription)")
                errorTitle = "Network Error"
                errorMessage = error.localizedDescription
                return
            }

            guard let data = data else {
                Log.error("No data received")
                errorTitle = "Network Error"
                errorMessage = "No data received"
                return
            }

            do {
                let decoded = try JSONDecoder().decode([SharedItem].self, from: data)
                DispatchQueue.main.async {
                    sharedContent = decoded
                }
            } catch {
                Log.error("Failed to decode response: \(error)")
                errorTitle = "Internal Error"
                errorMessage = "Failed to decode response"
            }
        }.resume()
    }

    private func deleteShared(_ item: SharedItem) {
        Log.info("Deleting share with hash: \(item.hash)")
        let baseRequest = Request(auth: auth)
        guard let preparedRequest = baseRequest.prepare(path: "/api/share/\(item.hash)", method: RequestMethod.delete) else {
            errorTitle = "Internal Error"
            errorMessage = "Invalid Server URL: \(auth.serverURL)/api/share/\(item.hash)"
            return
        }

        preparedRequest.session.dataTask(with: preparedRequest.request) { _, response, error in
            if let error = error {
                Log.error("Delete request failed: \(error.localizedDescription)")
                errorTitle = "Network Error"
                errorMessage = error.localizedDescription
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                Log.error("Invalid response during delete")
                errorTitle = "Network Error"
                errorMessage = "Invalid response during delete"
                return
            }

            if httpResponse.statusCode == 200 {
                Log.info("Successfully deleted share: \(item.hash)")
                DispatchQueue.main.async {
                    // Remove the deleted item from the local list
                    sharedContent.removeAll { $0.hash == item.hash }
                    toastMessage = ToastMessagePayload(text: "Deleted Share", color: .yellow)
                }
            } else {
                Log.error("Delete failed with status: \(httpResponse.statusCode)")
                errorTitle = "Network Error"
                errorMessage = "Delete Failed: \(formatHttpResponse(httpResponse))"
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
                        ForEach(sharedContent, id: \.self) { sharedPath in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(sharedPath.path)
                                        .lineLimit(expandedPaths.contains(sharedPath.path) ? nil : 1)
                                        .foregroundColor(.primary)
                                        .truncationMode(.middle)
                                        .onTapGesture {
                                            if expandedPaths.contains(sharedPath.path) {
                                                expandedPaths.remove(sharedPath.path)
                                            } else {
                                                expandedPaths.insert(sharedPath.path)
                                            }
                                        }
                                    Spacer()
                                    Text("Duration: \(timeLeftString(until: sharedPath.expire))")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    copyToClipboard("\(auth.serverURL)/share/\(sharedPath.hash)")
                                    toastMessage = ToastMessagePayload(text: "📋 Copied to clipboard", color: .green)
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
            .modifier(ErrorAlert(title: $errorTitle, message: $errorMessage))
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
            .onDisappear {
                expandedPaths.removeAll()
            }
        }
    }
}
