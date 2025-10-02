//
//  ShareManagementView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 10/1/25.
//

import SwiftUI

struct ShareManagementView: View {
    @State private var sharedContent: [String] = []
    @State private var toastMessage: ToastMessagePayload?

    private func fetchSharedContent() -> [String] {
        return ["hello-world"]
    }

    private func deleteShared(_ link: String) {
        Log.info("Deleting \(link)")
    }

    private var sharedFilesListView: some View {
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
                        ForEach(sharedContent, id: \.self) { sharedFile in
                            HStack {
                                Text(sharedFile)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                        }
                        .onDelete { indexSet in
                            let filesToDelete = indexSet.map { sharedContent[$0] }
                            filesToDelete.forEach { deleteShared($0) }
                        }
                    }
                }
            }
            .navigationTitle("Shared Content")
            .modifier(ToastMessage(payload: $toastMessage))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        sharedContent = fetchSharedContent()
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
                    Log.debug("Updating localFiles queue")
                    sharedContent = fetchSharedContent()
                }
            }
        }
    }

    var body: some View {
        sharedFilesListView
    }
}
