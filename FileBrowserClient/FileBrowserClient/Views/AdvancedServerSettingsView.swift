//
//  AdvancedServerSettingsView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 10/1/25.
//

import SwiftUI

struct AdvancedServerSettingsView: View {
    @EnvironmentObject var auth: AuthManager

    let logoutHandler: (Bool) -> Void

    let extensionTypes: ExtensionTypes
    let backgroundLogin: BackgroundLogin

    @State private var fileCacheSize: Int64 = 0

    @State private var showDeleteOptionsSS = false
    @State private var showDeleteConfirmationSS = false
    @State private var removeKnownServers = false

    @State private var knownServers: [String] = KeychainHelper.loadKnownServers()
    @State private var showDeleteOptionsKS = false

    @State private var localFiles: [URL] = []
    @State private var showOnlyLogFiles: Bool = true
    @State private var rotatingLogs: Bool = false
    @State private var showLocalFilePicker: Bool = false
    @State private var showLocalFileContent: Bool = false
    @State private var selectedLocalFile: URL?

    @State private var showDeviceMetrics: Bool = false

    // Display as alerts
    @State private var errorTitle: String?
    @State private var errorMessage: String?

    // Display as disappearing labels
    @State private var settingsMessage: ToastMessagePayload?
    @State private var localFilesMessage: ToastMessagePayload?

    func fetchClientStorageInfo() {
        fileCacheSize = FileCache.shared.diskCacheSize()
    }

    func clearSession() {
        Log.info("Removing stored session information")
        KeychainHelper.deleteSession()
        var message = "🗑️ Session cleared, logging out..."
        if self.removeKnownServers {
            Log.info("Removing known server list")
            KeychainHelper.deleteKnownServers()
            message = "🗑️ Session cleared and known servers deleted, logging out..."
        }
        settingsMessage = ToastMessagePayload(text: message, color: .red, duration: 3.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            logoutHandler(self.removeKnownServers)
        }
    }

    private var deleteOptionsKSStack: some View {
        VStack(spacing: 20) {
            Text("Delete Known Servers")
                .font(.title2)
                .bold()

            // Wrap the list in a ScrollView to allow scrolling
            // With current limits scroll bar is not required
            /* Commit SHAs
             Scroll: 819e917
             Limitter: bca5ec2
             Button disabled: d9b1bc0
             */
            ScrollView {
                ForEach(knownServers, id: \.self) { knownServerURL in
                    HStack {
                        // Ensure you don't display the current authenticated server
                        if knownServerURL != auth.serverURL {
                            Text(knownServerURL)
                                .lineLimit(1) // To prevent text from overflowing
                                .truncationMode(.tail) // Ensure long URLs are truncated

                            Spacer() // Push the trash icon to the right

                            Button(action: {
                                // Delete the server from the Keychain
                                KeychainHelper.deleteKnownServer(knownServerURL)

                                // Update the state to reflect the deletion
                                knownServers.removeAll { $0 == knownServerURL }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red) // Color for trash icon
                            }
                            .padding(.trailing, 10) // Trail space on the right
                        }
                    }
                    .padding(.vertical, 4) // Vertical spacing between each element in the list
                }
            }
            .presentationDetents([.fraction(0.3)]) // 30% of the screen height
        }
    }

    private var deleteStoredSessionSheet: some View {
        VStack(spacing: 20) {
            Text("Delete Session")
                .font(.title2)
                .bold()

            Toggle("Include known servers", isOn: $removeKnownServers)
                .padding()

            HStack {
                Button("Cancel") {
                    showDeleteOptionsSS = false
                }
                .padding()

                Spacer()

                Button(role: .destructive) {
                    showDeleteOptionsSS = false
                    showDeleteConfirmationSS = true
                } label: {
                    Text("Continue")
                }
                .padding()
            }
        }
        .padding()
        .presentationDetents([.fraction(0.3)]) // 30% of the screen height
    }

    private var filteredLocalFiles: [URL] {
        if showOnlyLogFiles {
            return localFiles.filter { $0.pathExtension == "log" }
        } else {
            return localFiles
        }
    }

    private func fetchLocalFiles() -> [URL] {
        let fileManager = FileManager.default
        let filesDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let allFiles = try fileManager.contentsOfDirectory(at: filesDirectory, includingPropertiesForKeys: nil)
            Log.debug("filesDirectory contents: \(allFiles)")
            return allFiles
        } catch {
            errorTitle = "Fetch Error"
            errorMessage = "❌ Error fetching files: \(error.localizedDescription)"
            return []
        }
    }

    private func deleteLocalFile(_ localFile: URL) {
        do {
            try FileManager.default.removeItem(at: localFile)
            // Remove from the state array
            localFiles.removeAll { $0 == localFile }
            Log.info("🗑️ Deleted file: \(localFile.lastPathComponent)")
        } catch {
            errorTitle = "Delete Failed"
            errorMessage = "❌ Failed to delete \(localFile.lastPathComponent)\n\(error.localizedDescription)"
        }
    }

    private var showDeviceMetricsView: some View {
        NavigationView {
            MetricsView()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.95)
                .navigationTitle("Device Metrics")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            showDeviceMetrics = false
                        }
                    }
                }
        }
    }

    private var localFilesListView: some View {
        NavigationView {
            List {
                // Section with toggle and rollover logs button
                Section {
                    Toggle("Show only .log files", isOn: $showOnlyLogFiles)

                    Button(action: {
                        rotatingLogs = true
                        Log.forceLogRotationCheck { result in
                            DispatchQueue.main.async {
                                if let url = result {
                                    localFilesMessage = ToastMessagePayload(
                                        text: "Stored logs until now to: \(url.lastPathComponent)",
                                        color: .green
                                    )
                                    localFiles = fetchLocalFiles()
                                } else {
                                    localFilesMessage = ToastMessagePayload(
                                        text: "Failed to rotate logs.", color: .red
                                    )
                                }
                                rotatingLogs = false
                            }
                        }
                    }) {
                        Label("Rollover Logs", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .disabled(rotatingLogs)
                }

                // Section for file list or empty state
                Section {
                    if filteredLocalFiles.isEmpty {
                        Text(showOnlyLogFiles ? "❌ No .log files found in sandbox" : "❌ No files found in sandbox")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(filteredLocalFiles, id: \.self) { localFile in
                            let fileSize = (try? FileManager.default.attributesOfItem(atPath: localFile.path))?[.size] as? Int
                            NavigationLink(
                                destination: LocalFileContentContainer(
                                    localFile: localFile,
                                    fileSize: fileSize,
                                    extensionTypes: extensionTypes
                                )
                            ) {
                                HStack {
                                    Text(localFile.lastPathComponent)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if let size = fileSize {
                                        Text(formatBytes(Int64(size)))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            let filesToDelete = indexSet.map { filteredLocalFiles[$0] }
                            filesToDelete.forEach { deleteLocalFile($0) }
                        }
                    }
                }
            }
            .navigationTitle("Sandbox Files")
            .modifier(ToastMessage(payload: $localFilesMessage))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        showLocalFilePicker = false
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        localFiles = fetchLocalFiles()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear {
                if localFiles.isEmpty {
                    Log.debug("Updating localFiles queue")
                    localFiles = fetchLocalFiles()
                }
            }
        }
    }

    var body: some View {
        Form {
            Section {
                Button {
                    showLocalFilePicker = true
                } label: {
                    Label("Sandbox Files", systemImage: "internaldrive")
                }
            }
            .fullScreenCover(isPresented: $showLocalFilePicker) {
                localFilesListView
            }
            
            Section {
                Button {
                    showDeviceMetrics = true
                } label: {
                    Label("Device Metrics", systemImage: "cpu")
                }
            }
            .fullScreenCover(isPresented: $showDeviceMetrics) {
                showDeviceMetricsView
            }
            
            Section {
                Button {
                    Task {
                        let response = await backgroundLogin.attemptLogin()
                        settingsMessage = ToastMessagePayload(text: response.text, color: response.ok ? .green : .red)
                    }
                } label: {
                    Label("Renew Authentication", systemImage: "exclamationmark.triangle")
                }
            }

            Section(header: Text("Client Storage")) {
                SelectableTextView(text: "File Cache: \(formatBytes(fileCacheSize))")
            }

            Section {
                Button(role: .destructive) {
                    GlobalThumbnailLoader.shared.clearFailedPath()
                    FileCache.shared.clearDiskCache(auth.serverURL)
                    fetchClientStorageInfo()
                    settingsMessage = ToastMessagePayload(text: "🗑️ Cache cleared", color: .yellow)
                } label: {
                    Label("Clear Local Cache", systemImage: "trash")
                }
            }

            // Delete Known Servers Section
            Section {
                Button(role: .destructive) {
                    showDeleteOptionsKS = true
                } label: {
                    Label("Delete Known Servers", systemImage: "trash")
                }
            }
            .sheet(isPresented: $showDeleteOptionsKS) {
                deleteOptionsKSStack
                    .padding()
            }
            
            // Delete Stored Session (will logout)
            Section {
                Button(role: .destructive) {
                    showDeleteOptionsSS = true
                } label: {
                    Label("Delete Stored Session", systemImage: "trash")
                }
            }
            .sheet(isPresented: $showDeleteOptionsSS) {
                deleteStoredSessionSheet
            }
            .alert("Are you sure?", isPresented: $showDeleteConfirmationSS) {
                Button("Delete", role: .destructive) {
                    clearSession()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                deleteSessionMessage(includeKnownServers: removeKnownServers)
            }

            // Session information
            Section(
                footer: VStack(alignment: .leading) {
                    Text("ServerURL: \(auth.serverURL)").textSelection(.enabled)
                    Text("Username: \(auth.username)").textSelection(.enabled)
                    Text("Issuer: \(auth.tokenPayload?.iss ?? "Unknown")").textSelection(.enabled)
                    Text("Issued: \(timeStampToString(from: auth.tokenPayload?.iat))").textSelection(.enabled)
                    Text("Expiration: \(timeStampToString(from: auth.tokenPayload?.exp))").textSelection(.enabled)
                    Text("Time Left: \(timeLeftString(until: auth.tokenPayload?.exp))").textSelection(.enabled)
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .center)
            ) {
                EmptyView()
            }
        }
        .modifier(ErrorAlert(title: $errorTitle, message: $errorMessage))
        .modifier(ToastMessage(payload: $settingsMessage))
        .onAppear {
            fetchClientStorageInfo()
        }
        // MARK: Disappear check should be for showSettingsSheet, because localFilesListView will close when opening a file
        .onDisappear {
            Log.debug("Clearing localFiles queue")
            localFiles.removeAll()
        }
    }
}
