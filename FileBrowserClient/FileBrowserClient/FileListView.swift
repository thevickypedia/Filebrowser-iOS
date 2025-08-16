//
//  FileListView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI

enum SortOption {
    case nameAsc, nameDesc, sizeAsc, sizeDesc, modifiedAsc, modifiedDesc
}

struct FileListView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var viewModel: FileListViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) private var dismiss

    @State private var showCreateFile = false
    @State private var showCreateFolder = false
    @State private var newResourceName = ""

    @State private var selectionMode = false
    @State private var selectedItems: Set<FileItem> = []
    @State private var showingDeleteConfirm = false

    @State private var isRenaming = false
    @State private var renameInput = ""

    @State private var isSharing = false
    @State private var isShareInProgress = false
    @State private var durationDigit = ""
    @State private var shareDuration = "hours"
    @State private var sharePassword = ""
    // TODO: Redundant - can be replaced with selectedItems
    @State private var sharePath: String?
    let shareDurationOptions = ["seconds", "minutes", "hours", "days"]
    @State private var unsignedURL: URL?
    @State private var preSignedURL: URL?

    @State private var hideDotfiles = false
    @State private var showingSettings = false
    @State private var dateFormatExact = false

    @State private var showFileImporter = false
    @State private var showPhotoPicker = false

    @State private var uploadQueue: [URL] = []
    @State private var currentUploadIndex = 0
    @State private var uploadProgress: Double = 0.0
    @State private var uploadProgressPct: Int = 0

    // This is a required redundancy since the combination is used to show preparation stage
    @State private var isUploading = false
    @State private var isPreparingUpload = false

    @State private var showDeleteOptionsSS = false
    @State private var showDeleteConfirmationSS = false
    @State private var removeKnownServers = false

    @State private var knownServers: [String] = KeychainHelper.loadKnownServers()
    @State private var showDeleteOptionsKS = false

    @State private var uploadTask: URLSessionUploadTask?
    @State private var isUploadCancelled = false
    @State private var currentUploadSpeed: Double = 0.0
    @State private var currentUploadFile: String?
    @State private var currentUploadFileIcon: String?
    @State private var currentUploadFileSize: String?
    @State private var currentUploadedFileSize: String?

    @State private var usageInfo: (used: Int64, total: Int64)?
    @State private var fileCacheSize: Int64 = 0

    @State private var sortOption: SortOption = .nameAsc
    @AppStorage("viewMode") private var viewModeRawValue: String = ViewMode.list.rawValue

    @State private var loadingFiles: [String: Bool] = [:] // Track loading state by file path

    private var viewMode: ViewMode {
        get { ViewMode(rawValue: viewModeRawValue) ?? .list }
        set { viewModeRawValue = newValue.rawValue }
    }

    // Display as alerts
    @State private var errorTitle: String?
    @State private var errorMessage: String?

    // Display as disappearing labels
    @State private var statusMessage: StatusPayload?
    @State private var settingsMessage: StatusPayload?
    @State private var shareMessage: StatusPayload?

    // Specific for Grid view
    @State private var selectedFileIndex: Int?
    @State private var selectedFileList: [FileItem] = []

    // Search functionality
    @State private var searchClicked = false
    @State private var searchInProgress = false
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var searchType: SearchType = .files
    @State private var previousPathStack: [String] = []

    @Binding var isLoggedIn: Bool
    @Binding var pathStack: [String]
    private var currentPath: String {
        pathStack.last ?? "/"
    }

    let logoutHandler: (Bool) -> Void

    let extensionTypes: ExtensionTypes
    let advancedSettings: AdvancedSettings
    let cacheExtensions: [String]

    @State private var serverURL: String = ""
    @State private var token: String = ""
    @State private var userAccount: UserAccount?
    @State private var isAuthValid: Bool = false

    init(
        isLoggedIn: Binding<Bool>,
        pathStack: Binding<[String]>,
        logoutHandler: @escaping (Bool) -> Void,
        extensionTypes: ExtensionTypes,
        advancedSettings: AdvancedSettings,
        cacheExtensions: [String]
    ) {
        self._isLoggedIn = isLoggedIn
        self._pathStack = pathStack
        self.logoutHandler = logoutHandler
        self.extensionTypes = extensionTypes
        self.advancedSettings = advancedSettings
        self.cacheExtensions = cacheExtensions
    }

    // Add this validation function that should be called in onAppear
    private func validateAuth() {
        guard let serverURL = auth.serverURL,
              let token = auth.token,
              let userAccount = auth.userAccount else {
            Log.error("❌ Missing authentication credentials")
            isAuthValid = false
            errorMessage = "Invalid authorization. Please log out and log back in."
            return
        }

        self.serverURL = serverURL
        self.token = token
        self.userAccount = userAccount
        self.isAuthValid = true
        Log.info("✅ Auth validation successful")
    }

    private var homeStack: some View {
        HStack {
            Button(action: {
                pathStack = []
                Log.info("🔙 Dismissing to root directory")
                viewModel.fetchFiles(at: "/")
            }) {
                Image(systemName: "house")
            }
        }
    }

    private var preparingUploadStack: some View {
        ZStack {
            ProgressView("Preparing for upload...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .padding(24)
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var searchingStack: some View {
        VStack {
            HStack {
                // Only the search text field should be interactive
                TextField("Search...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 8)
                    .submitLabel(.go)
                    .onSubmit {
                        guard !searchText.isEmpty else { return }
                        searchTask = Task {
                            searchInProgress = true
                            await searchFiles(query: searchText)
                            searchTask = nil
                        }
                    }

                Spacer()

                // Cancel button for search
                Button(action: {
                    if let task = searchTask {
                        Log.debug("🔙 Search cancelled mid request")
                        task.cancel()
                        statusMessage = StatusPayload(
                            text: "✖️ Search cancelled",
                            color: .yellow,
                            duration: 3.5
                        )
                    } else {
                        Log.debug("🔙 Search cancelled - no task in flight")
                    }
                    searchClicked = false
                    searchInProgress = false
                    viewModel.searchResults.removeAll()
                    pathStack = previousPathStack
                    viewModel.fetchFiles(at: pathStack.last ?? "/")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                }
                .padding(.trailing, 0)
            }
            .padding(.horizontal)

            HStack(spacing: 20) {
                // Display icons only for image, audio, video and pdf
                ForEach(SearchType.allCases.filter { $0 != .files }, id: \.self) { type in
                    Button(action: {
                        searchType = (searchType == type) ? .files : type
                    }) {
                        Image(systemName: type.iconName)
                            .foregroundColor(searchType == type ? .green : .blue)
                            .font(.system(size: 40))
                            .padding()
                            .background(searchType == type ? Color.blue.opacity(0.2) : Color.clear)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private var uploadingStack: some View {
        VStack(alignment: .leading, spacing: 16) {

            // 🗂️ File Info
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: currentUploadFileIcon ?? "doc.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentUploadFile ?? "Unknown")
                        .font(.headline)
                    Text("\(currentUploadedFileSize ?? "0.0 MB") / \(currentUploadFileSize ?? "0.0 MB")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            // 🔄 Queue
            HStack(spacing: 12) {
                Image(systemName: "list.number")
                    .foregroundColor(.indigo)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Queue")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(currentUploadIndex + 1) of \(uploadQueue.count)")
                        .font(.body)
                }
            }

            // 🚀 Speed
            HStack(spacing: 12) {
                Image(systemName: "speedometer")
                    .foregroundColor(.green)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Speed")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(String(format: "%.2f MB/s", currentUploadSpeed))
                        .font(.body)
                }
            }

            // 📤 Chunk Size
            HStack(spacing: 12) {
                Image(systemName: "square.stack.3d.up")
                    .foregroundColor(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Chunk Size")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(advancedSettings.chunkSize) MB")
                        .font(.body)
                }
            }

            // 📊 Progress Bar
            ProgressView(value: uploadProgress, total: 1.0) {
                EmptyView() // No label
            } currentValueLabel: {
                Text("\(uploadProgressPct)%")
            }
            .progressViewStyle(LinearProgressViewStyle())
            .padding(.top, 8)
        }
    }

    private var actionsTabStack: some View {
        return Menu {
            if auth.permissions?.create == true {
                Button("Create File", systemImage: "doc.badge.plus", action: {
                    showCreateFile = true
                })
                Button("Create Folder", systemImage: "folder.badge.plus", action: {
                    showCreateFolder = true
                })
            }
            Button("Settings", systemImage: "gearshape", action: {
                showingSettings = true
            })
            Menu("Upload File", systemImage: "square.and.arrow.up") {
                Button("From Files", systemImage: Icons.doc, action: {
                    showFileImporter = true
                    showPrepareUpload()
                })
                Button("From Photos", systemImage: "photo", action: {
                    showPhotoPicker = true
                    showPrepareUpload()
                })
            }
        } label: {
            Label("Actions", systemImage: "person.circle")
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
    }

    private var selectionStack: some View {
        return Menu {
            if !viewModel.files.isEmpty {
                Button(action: { selectionMode = true }) {
                    Label("Select", systemImage: "checkmark.circle")
                }
            }

            Button(action: {
                previousPathStack = pathStack
                searchText = ""
                searchClicked = true       // show the search UI
                searchInProgress = false   // not searching yet
            }) {
                Label("Search", systemImage: "magnifyingglass")
            }

            Menu {
                Picker("View mode", selection: $viewModeRawValue) {
                    Label("List", systemImage: "list.bullet").tag(ViewMode.list.rawValue)
                    Label("Grid", systemImage: "square.grid.2x2").tag(ViewMode.grid.rawValue)
                    Label("Module", systemImage: "square.grid.3x3").tag(ViewMode.module.rawValue)
                }
            } label: {
                Label("View Options", systemImage: "arrow.up.arrow.down.square")
            }

            if viewModel.files.count > 1 {
                Menu {
                    Picker("Sort by", selection: $sortOption) {
                        Label("Name ↑", systemImage: "arrow.up").tag(SortOption.nameAsc)
                        Label("Name ↓", systemImage: "arrow.down").tag(SortOption.nameDesc)
                        Label("Size ↑", systemImage: "arrow.up").tag(SortOption.sizeAsc)
                        Label("Size ↓", systemImage: "arrow.down").tag(SortOption.sizeDesc)
                        Label("Modified ↑", systemImage: "arrow.up").tag(SortOption.modifiedAsc)
                        Label("Modified ↓", systemImage: "arrow.down").tag(SortOption.modifiedDesc)
                    }
                } label: {
                    Label("Sort Options", systemImage: "arrow.up.arrow.down.square")
                }
            }
        } label: {
            Label("Options", systemImage: "ellipsis.circle")
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
                        if knownServerURL != self.serverURL {
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

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                if searchClicked {
                    searchingStack
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)").foregroundColor(.red)
                    } else if viewModel.searchResults.isEmpty {
                        Text("No results").foregroundColor(.gray)
                    } else {
                        searchListView(for: viewModel.searchResults)
                    }
                } else if !viewModel.searchResults.isEmpty {
                    searchingStack
                    searchListView(for: viewModel.searchResults)
                } else {
                    if isPreparingUpload {
                        preparingUploadStack
                    }
                    if isUploading {
                        uploadingStack
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                        Button(action: {
                            isUploadCancelled = true
                            uploadTask?.cancel()
                            uploadTask = nil
                            uploadQueue = []
                            currentUploadIndex = 0
                            uploadProgress = 0.0
                            isUploading = false
                            Log.info("❌ Upload cancelled by user.")
                        }) {
                            Label("Cancel Upload", systemImage: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                        .padding(.top, 8)
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)").foregroundColor(.red)
                    } else {
                        let sortedFiles = viewModel.sortedFiles(by: sortOption)
                        Group {
                            if viewMode == .list {
                                listView(for: sortedFiles)
                            } else {
                                gridView(for: sortedFiles, module: viewMode == .module)
                            }
                        }
                        if viewModel.files.isEmpty && !viewModel.isLoading {
                            Text("No files found").foregroundColor(.gray)
                        }
                    }
                }
            }

            // 🌗 Floating Theme Toggle
            Button(action: {
                themeManager.colorScheme = themeManager.colorScheme == .dark ? .light : .dark
            }) {
                Image(systemName: themeManager.colorScheme == .dark ? "sun.max.fill" : "moon.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 30)
        }
        .navigationTitle(getNavigationTitle())
        .navigationBarTitleDisplayMode(.large)
        .navigationBarHidden(false)
        .toolbar {
            // Left: Refresh button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { refreshFolder() }) {
                    Image(systemName: "arrow.clockwise")
                }
            }

            // Center: Home button
            ToolbarItem(placement: .principal) {
                if !selectionMode {
                    homeStack
                }
            }

            // Right: Create and Logout buttons
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !selectionMode {
                    actionsTabStack
                    selectionStack
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if selectionMode {
                    // 🗑️ Delete
                    Button(action: {
                        if selectedItems.isEmpty { return }
                        showingDeleteConfirm = true
                    }) {
                        Image(systemName: "trash")
                    }

                    // 📝 Rename — only when exactly 1 item is selected
                    if selectedItems.count == 1 {
                        Button(action: {
                            if let item = selectedItems.first {
                                renameInput = item.name
                                isRenaming = true
                            }
                        }) {
                            Image(systemName: "pencil")
                        }
                        Button(action: {
                            if let item = selectedItems.first {
                                sharePath = item.name
                                isSharing = true
                            }
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }

                    // ✅ Select All / Deselect All
                    Button(action: toggleSelectAll) {
                        Image(systemName:
                            selectedItems.count == viewModel.files.count
                            ? "square.dashed"
                            : "checkmark.square"
                        )
                    }

                    // ❌ Cancel
                    Button(action: {
                        selectedItems.removeAll()
                        selectionMode = false
                    }) {
                        Image(systemName: "xmark.circle")
                    }
                }
                Button(action: {
                    Log.info("Logged out!")
                    logoutHandler(false)
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .id("filelist-\(currentPath)-\(pathStack.count)")
        // MARK: Messages on any listing page (behind all sheets)
        .modifier(StatusMessage(payload: $statusMessage))
        .modifier(ErrorAlert(title: $errorTitle, message: $errorMessage))
        .modifier(CreateFileAlert(
            createFile: $showCreateFile,
            fileName: $newResourceName,
            action: { createResource(isDirectory: false) }
        ))
        .modifier(CreateFolderAlert(
            createFolder: $showCreateFolder,
            folderName: $newResourceName,
            action: { createResource(isDirectory: true) }
        ))
        .modifier(DeleteConfirmAlert(
            isPresented: $showingDeleteConfirm,
            selectedCount: selectedItems.count,
            deleteAction: { deleteSelectedItems() }
        ))
        .modifier(RenameAlert(
            isPresented: $isRenaming,
            renameInput: $renameInput,
            renameAction: renameSelectedItem
        ))
        .onAppear {
            validateAuth()
            guard isAuthValid else { return }
            if !searchClicked && !searchInProgress {
                Log.debug("📂 FileListView appeared for path: \(currentPath)")
                viewModel.fetchFiles(at: currentPath)
            }
        }
        .onChange(of: pathStack) { newStack in
            if !searchClicked && !searchInProgress {
                let newPath = newStack.last ?? "/"
                Log.debug("📂 Path changed: \(newPath)")
                viewModel.fetchFiles(at: newPath)
            }
        }
        .sheet(isPresented: $isSharing) {
            NavigationView {
                Form {
                    if isShareInProgress {
                        ProgressView("Generating link...")
                    }
                    // MARK: - Generated Links
                    if let unsigned = unsignedURL, let preSigned = preSignedURL {
                        Section(header: Text("Links")) {
                            ShareLinkRow(title: "Unsigned URL", url: unsigned) { payload in
                                shareMessage = payload
                            }
                            ShareLinkRow(title: "Pre-Signed URL", url: preSigned) { payload in
                                shareMessage = payload
                            }
                        }
                    }
                    Section(header: Text("Share Duration")) {
                        HStack {
                            TextField("0", text: $durationDigit)
                                .keyboardType(.numberPad)
                                .frame(width: 80)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Picker(selection: $shareDuration, label: Text("")) {
                                ForEach(shareDurationOptions, id: \.self) { duration in
                                    Text(duration.capitalized).tag(duration)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    Section(header: Text("Optional Password")) {
                        SecureField("Enter password", text: $sharePassword)
                    }
                    Section {
                        HStack {
                            Spacer()
                            Button("Cancel") {
                                isSharing = false
                            }
                            .foregroundColor(.red)
                            .disabled(isShareInProgress)
                            Spacer()
                            Button("Share") {
                                if let time = Int(durationDigit), time > 0 {
                                    isSharing = true
                                    submitShare()
                                    isSharing = true
                                } else {
                                    isSharing = true
                                    shareMessage = StatusPayload(
                                        text: "Input time should be more than 0",
                                        color: .red,
                                        duration: 3
                                    )
                                }
                            }
                            .disabled(isShareInProgress)
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle("Share", displayMode: .inline)
                // MARK: Messages within share sheet
                .modifier(StatusMessage(payload: $shareMessage))
            }
        }
        .sheet(isPresented: $showingSettings) {
            Form {
                Toggle("Hide dotfiles", isOn: $hideDotfiles)
                Toggle("Set exact date format", isOn: $dateFormatExact)
                Button("Save", action: saveSettings)
                if let usage = usageInfo {
                    Section(header: Text("Server Capacity")) {
                        VStack(alignment: .leading) {
                            SelectableTextView(text: "Used: \(formatBytes(usage.used))")
                            SelectableTextView(text: "Total: \(formatBytes(usage.total))")
                            ProgressView(value: Double(usage.used), total: Double(usage.total))
                        }
                    }
                } else {
                    Section(header: Text("Server Capacity")) {
                        Text("Loading...")
                    }
                }
                Section(header: Text("Client Storage")) {
                    SelectableTextView(text: "File Cache: \(formatBytes(fileCacheSize))")
                }
                Section {
                    Button(role: .destructive) {
                        FileCache.shared.clearDiskCache(self.serverURL)
                        fetchClientStorageInfo()
                        settingsMessage = StatusPayload(text: "🗑️ Cache cleared", color: .yellow)
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
                .alert("Are you sure?", isPresented: $showDeleteConfirmationSS) {
                    Button("Delete", role: .destructive) {
                        clearSession()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    deleteSessionMessage(includeKnownServers: removeKnownServers)
                }

                Section(
                    footer: VStack(alignment: .leading) {
                        Text("Issuer: \(auth.iss ?? "Unknown")").textSelection(.enabled)
                        Text("Issued: \(timeStampToString(from: auth.iat))").textSelection(.enabled)
                        Text("Expiration: \(timeStampToString(from: auth.exp))").textSelection(.enabled)
                        Text("Time Left: \(timeLeftString(until: auth.exp))").textSelection(.enabled)
                    }
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity, alignment: .center)
                ) {
                    EmptyView()
                }
            }
            // MARK: Messages within the settings sheet
            .modifier(StatusMessage(payload: $settingsMessage))
            .onAppear {
                hideDotfiles = self.userAccount?.hideDotfiles ?? false
                dateFormatExact = self.userAccount?.dateFormat ?? false
                fetchUsageInfo()
                fetchClientStorageInfo()
            }
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPicker { urls in
                uploadQueue = urls
                currentUploadIndex = 0
                uploadNextInQueue()
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                uploadQueue = urls
                currentUploadIndex = 0
                uploadNextInQueue()
            case .failure(let error):
                Log.error("❌ File selection failed: \(error.localizedDescription)")
            }
        }
        .navigationDestination(isPresented: Binding<Bool>(
            get: { selectedFileIndex != nil },
            set: { if !$0 { selectedFileIndex = nil } }
        )) {
            if let index = selectedFileIndex {
                detailView(for: selectedFileList[index], index: index, sortedFiles: selectedFileList)
            }
        }
    }

    func submitShare() {
        isShareInProgress = true
        guard let expiryTime = Int(durationDigit), expiryTime > 0 else {
            shareMessage = StatusPayload(
                text: "Input time should be more than 0",
                color: .red,
                duration: 3
            )
            return
        }

        guard let shareTarget = sharePath,
              let shareURL = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "share", shareTarget],
            queryItems: [
                URLQueryItem(name: "expires", value: String(expiryTime)),
                URLQueryItem(name: "unit", value: shareDuration)
            ]
        ) else {
            Log.error("❌ Failed to determine share item")
            return
        }
        Log.debug("Share URL: \(shareURL)")

        var request = URLRequest(url: shareURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        let body: [String: String] = [
            "password": sharePassword,
            "expires": String(expiryTime),
            "unit": shareDuration
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            Log.error("❌ Failed to encode JSON body: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                defer {
                    isShareInProgress = false  // ✅ re-enable buttons after response
                }
                self.errorTitle = "Server Error"
                guard error == nil, let data = data else {
                    Log.error("❌ Request failed: \(error?.localizedDescription ?? "Unknown error")")
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    self.errorMessage = "Response was not HTTPURLResponse"
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    Log.error("❌ Server error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                    self.errorMessage = "[\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        Log.info("✅ JSON Data: \(json)")
                        let sharedLink = try JSONDecoder().decode(ShareResponse.self, from: data)
                        let unsigned = buildAPIURL(
                            base: serverURL,
                            pathComponents: ["share", sharedLink.hash]
                        )
                        var preSigned: URL?
                        if let token = sharedLink.token {
                            preSigned = buildAPIURL(
                                base: serverURL,
                                pathComponents: ["api", "public", "dl", sharedLink.hash, shareTarget],
                                queryItems: [URLQueryItem(name: "token", value: token)]
                            )
                        } else {
                            preSigned = buildAPIURL(
                                base: serverURL,
                                pathComponents: ["api", "public", "dl", sharedLink.hash, shareTarget]
                            )
                        }
                        self.unsignedURL = unsigned
                        self.preSignedURL = preSigned
                    } else {
                        Log.error("❌ Malformed /api/share/ response")
                    }
                } catch {
                    Log.error("❌ JSON parse error for share: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func getSearchURL(serverURL: String, query: String) -> URL? {
        var finalQuery = query
        if let prefix = searchType.queryPrefix {
            Log.debug("🔎 Search type: \(searchType.displayName)")
            finalQuery = "\(prefix) \(finalQuery)"
        }

        let searchLocation: String
        if pathStack.isEmpty || currentPath == "/" {
            // No extra path component, search at /api/search
            searchLocation = ""
            statusMessage = StatusPayload(
                text: "⚠️ Searching from the home page may take longer and be inaccurate",
                color: .yellow,
                duration: 3.5
            )
        } else {
            searchLocation = currentPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }

        var pathComponents = ["api", "search"]
        if !searchLocation.isEmpty {
            pathComponents.append(searchLocation)
        }

        return buildAPIURL(
            base: serverURL,
            pathComponents: pathComponents,
            queryItems: [
                URLQueryItem(name: "query", value: finalQuery)  // pass raw query string
            ]
        )
    }

    func searchFiles(query: String) async {
        Log.debug("🔍 Searching for: \(query)")
        guard isAuthValid else {
            Log.error("❌ Auth not validated")
            errorMessage = "Invalid authorization. Please log out and log back in."
            return
        }

        guard let url = getSearchURL(serverURL: serverURL, query: query) else {
            await MainActor.run {
                errorMessage = "Invalid search: \(query)"
                searchInProgress = false
            }
            Log.error("❌ Failed to generate search URL")
            return
        }

        Log.debug("🔍 Search URL: \(urlPath(url))")

        await MainActor.run {
            viewModel.isLoading = true
            errorMessage = nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                await MainActor.run {
                    self.searchInProgress = false
                    self.errorMessage = "Server error: Invalid response"
                }
                Log.error("❌ Server error: Response was not HTTPURLResponse")
                return
            }

            guard httpResponse.statusCode == 200 else {
                await MainActor.run {
                    self.searchInProgress = false
                    self.errorMessage = "Server error: [\(httpResponse.statusCode)]: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                }
                Log.error("❌ Server error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                return
            }

            guard !Task.isCancelled else {
                Log.debug("⚠️ Search task was cancelled before decoding")
                return
            }

            do {
                let results = try JSONDecoder().decode([FileItemSearch].self, from: data)

                await MainActor.run {
                    viewModel.isLoading = false
                    searchInProgress = false

                    if results.isEmpty {
                        viewModel.errorMessage = "No \(searchType.displayName) found for: \(query)"
                        Log.info("🔍 No results for \(searchType.displayName): \(query)")
                    } else {
                        viewModel.searchResults = results
                        Log.info("🔍 Search returned \(results.count) \(searchType.displayName)")
                    }
                }
            } catch let decodingError as DecodingError {
                await MainActor.run {
                    errorMessage = "Failed to parse search results"
                    viewModel.isLoading = false
                    searchInProgress = false
                }
                Log.error("❌ Search decode error: \(decodingError.localizedDescription)")
            }
        } catch is CancellationError {
            Log.debug("❌ Search was cancelled")
        } catch {
            // Handles things like timeouts, no internet, etc.
            await MainActor.run {
                viewModel.isLoading = false
                searchInProgress = false
            }
            if error.localizedDescription != "cancelled" {
                errorMessage = error.localizedDescription
                Log.error("❌ Search request failed: \(error.localizedDescription)")
            }
        }
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
        settingsMessage = StatusPayload(text: message, color: .red, duration: 3.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            logoutHandler(self.removeKnownServers)
        }
    }

    @ViewBuilder
    func detailView(for file: FileItem, index: Int, sortedFiles: [FileItem]) -> some View {
        FileDetailView(
            currentIndex: index,
            files: sortedFiles,
            serverURL: self.serverURL,
            token: self.token,
            // MARK: Pass a callback reference to fetchClientStorageInfo func
            onFileCached: { fetchClientStorageInfo() },
            extensionTypes: extensionTypes,
            cacheExtensions: getCacheExtensions(
                advancedSettings: advancedSettings,
                extensionTypes: extensionTypes
            ),
            animateGIF: advancedSettings.animateGIF
        )
    }

    @ViewBuilder
    func thumbnailOrIcon(for file: FileItem, style: GridStyle? = nil) -> some View {
        let fileName = file.name.lowercased()
        let useThumbnail = advancedSettings.displayThumbnail &&
            extensionTypes.thumbnailExtensions.contains(where: fileName.hasSuffix)

        if useThumbnail {
            RemoteThumbnail(
                file: file,
                serverURL: self.serverURL,
                token: self.token,
                advancedSettings: advancedSettings,
                extensionTypes: extensionTypes,
                width: style?.gridHeight ?? ViewStyle.listIconSize,
                height: style?.gridHeight ?? ViewStyle.listIconSize,
                loadingFiles: $loadingFiles
            )
            .scaledToFill()
            .frame(
                width: style?.gridHeight ?? ViewStyle.listIconSize,
                height: style?.gridHeight ?? ViewStyle.listIconSize
            )
            .clipped()
            .id(file.path)
        } else {
            Image(systemName: file.isDir
                  ? Icons.folder
                  : systemIcon(for: fileName, extensionTypes: extensionTypes) ?? Icons.doc)
                .resizable()
                .scaledToFit()
                .frame(height: style?.iconSize ?? ViewStyle.listIconSize)
                .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
        }
    }

    @ViewBuilder
    func listView(for fileList: [FileItem]) -> some View {
        ForEach(Array(fileList.enumerated()), id: \.element.id) { index, file in
            if selectionMode {
                HStack {
                    Image(systemName: selectedItems.contains(file) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedItems.contains(file) ? .blue : .gray)
                    thumbnailOrIcon(for: file)
                        .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)
                    Text(file.name)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture { toggleSelection(for: file) }
            } else {
                if file.isDir {
                    NavigationLink(value: fullPath(for: file)) {
                        HStack {
                            thumbnailOrIcon(for: file)
                                .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)
                            Text(file.name)
                        }
                    }
                } else {
                    NavigationLink(destination: detailView(for: file, index: index, sortedFiles: fileList)) {
                        HStack {
                            thumbnailOrIcon(for: file)
                                .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)
                            Text(file.name)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func gridCell(for file: FileItem, at index: Int, in fileList: [FileItem], module: Bool) -> some View {
        let style = ViewStyle.gridStyle(module: module)

        let handleFileTap = {
            if selectionMode {
                toggleSelection(for: file)
            } else {
                selectedFileIndex = index
                selectedFileList = fileList
            }
        }

        let handleFolderTap = {
            if selectionMode {
                toggleSelection(for: file)
            }
        }

        ZStack(alignment: .topTrailing) {
            if file.isDir {
                if selectionMode {
                    Button(action: handleFolderTap) {
                        gridContent(file: file, style: style, module: module)
                    }
                    .buttonStyle(.plain)
                } else {
                    NavigationLink(value: fullPath(for: file)) {
                        gridContent(file: file, style: style, module: module)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Button(action: handleFileTap) {
                    gridContent(file: file, style: style, module: module)
                }
                .buttonStyle(.plain)
            }

            if selectionMode {
                Image(systemName: selectedItems.contains(file) ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: style.selectionSize, height: style.selectionSize)
                    .foregroundColor(selectedItems.contains(file) ? .blue : .gray)
                    .padding(6)
            }
        }
    }

    @ViewBuilder
    func gridContent(file: FileItem, style: GridStyle, module: Bool) -> some View {
        VStack(spacing: 2) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(height: style.gridHeight)

                thumbnailOrIcon(for: file, style: style)
            }

            Text(file.name)
                .font(module ? .caption2 : .caption)
                .multilineTextAlignment(.center)
                .lineLimit(style.lineLimit)
                .padding(.horizontal, 2)
                .foregroundColor(.primary)
            if !module {
                Text(parseGridSize(from: file.isDir ? nil : file.size) ?? "—")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(parseGridDate(from: file.modified))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }

    @ViewBuilder
    func gridView(for fileList: [FileItem], module: Bool = false) -> some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumns(module: module), spacing: 12) {
                ForEach(Array(fileList.enumerated()), id: \.element.id) { index, file in
                    gridCell(for: file, at: index, in: fileList, module: module)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    func searchListView(for results: [FileItemSearch]) -> some View {
        ForEach(results, id: \.path) { result in
            let name = URL(fileURLWithPath: result.path).lastPathComponent
            if result.dir {
                NavigationLink(value: result.path) {
                    HStack {
                        Image(systemName: "folder")
                            .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)
                        Text(name)
                    }
                }
            } else {
                NavigationLink(destination: {
                    // Minimal FileItem for detail view
                    let fileItem = FileItem(
                        name: name,
                        path: result.path,
                        isDir: false,
                        modified: nil,
                        size: nil,
                        extension: name.split(separator: ".").last.map(String.init)
                    )
                    detailView(for: fileItem, index: 0, sortedFiles: [fileItem])
                }) {
                    HStack {
                        Image(systemName: "doc")
                            .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)
                        Text(name)
                    }
                }
            }
        }
    }

    func showPrepareUpload(after duration: Int = 10) {
        // MARK: Force isPreparingUpload flag after a static timeout
        // There is no real way to detect a cancel even from file importer or photo picker
        // This is to make sure "preparing to upload" banner is not shown forever
        isPreparingUpload = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
            if isPreparingUpload {
                isPreparingUpload = false
                Log.debug("Time's up! Forcing isPreparingUpload flag to false")
                statusMessage = StatusPayload(
                    text: "⚠️ Getting things ready... Upload will follow if files were selected.",
                    color: .yellow,
                    duration: 5
                )
            }
        }
    }

    private func getNavigationTitle() -> String {
        // If we have a pathStack, use the last path component
        if let lastPath = pathStack.last, !lastPath.isEmpty {
            let components = lastPath.components(separatedBy: "/")
            return components.last ?? "Home"
        }

        // If pathStack is empty or path is empty, we're at root
        if pathStack.isEmpty || currentPath == "/" {
            return "Home"
        }

        // Fallback: use the current path
        let components = currentPath.components(separatedBy: "/")
        return components.last ?? "Home"
    }

    func fetchClientStorageInfo() {
        fileCacheSize = FileCache.shared.diskCacheSize()
    }

    func fetchUsageInfo() {
        guard isAuthValid else {
            Log.error("❌ Auth not validated")
            errorMessage = "Invalid authorization. Please log out and log back in."
            return
        }
        guard let url = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "usage"],
            queryItems: []
        ) else {
            Log.error("❌ Invalid URL")
            errorMessage = "Invalid usage URL."
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                guard error == nil, let data = data else {
                    Log.error("❌ Failed to fetch usage: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let used = json["used"] as? Int64,
                       let total = json["total"] as? Int64 {
                        usageInfo = (used, total)
                        Log.info("💽 Usage — Used: \(used), Total: \(total)")
                    } else {
                        Log.error("❌ Malformed /api/usage/ response")
                    }
                } catch {
                    Log.error("❌ JSON parse error for usage: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func getUploadURL(serverURL: String, encodedName: String) -> URL? {
        if currentPath == "/" {
            return buildAPIURL(
                base: serverURL,
                pathComponents: ["api", "tus", encodedName],
                queryItems: [URLQueryItem(name: "override", value: "false")]
            )
        }
        return buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "tus", currentPath, encodedName],
            queryItems: [URLQueryItem(name: "override", value: "false")]
        )
    }

    func initiateTusUpload(for fileURL: URL) {
        guard isAuthValid else {
            Log.error("❌ Auth not validated")
            errorMessage = "Invalid authorization. Please log out and log back in."
            return
        }

        let fileName = fileURL.lastPathComponent
        guard let uploadURL = getUploadURL(serverURL: serverURL, encodedName: fileName) else {
            Log.error("❌ Invalid upload URL")
            errorTitle = "Invalid upload URL"
            errorMessage = "Failed to construct upload URL for: \(fileName)"
            return
        }

        // Create file handle before making upload request
        // 1. This will avoid showing upload progress bar before it begins
        // 2. There is no trace of the file in the server (since this runs before POST and HEAD)
        let fileHandle: FileHandle
        do {
            fileHandle = try FileHandle(forReadingFrom: fileURL)
        } catch {
            Log.error("❌ Cannot open file: \(fileURL.lastPathComponent), error: \(error)")
            errorTitle = "File Error"
            errorMessage = error.localizedDescription
            cancelUpload(fileHandle: nil)
            statusMessage = StatusPayload(text: "❌ Upload failed", color: .red)
            return
        }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ POST failed: \(error.localizedDescription)")
                    errorTitle = "Upload Failed"
                    errorMessage = error.localizedDescription
                    return
                }

                Log.info("✅ Upload session initiated at: \(urlPath(uploadURL))")
                getUploadOffset(fileHandle: fileHandle, fileURL: fileURL, uploadURL: uploadURL)
            }
        }.resume()
    }

    func getUploadOffset(fileHandle: FileHandle, fileURL: URL, uploadURL: URL) {
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "HEAD"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue(self.token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ HEAD failed: \(error.localizedDescription)")
                    errorTitle = "Upload Failed"
                    errorMessage = error.localizedDescription
                    return
                }

                guard let http = response as? HTTPURLResponse,
                      let offsetStr = http.value(forHTTPHeaderField: "Upload-Offset"),
                      let offset = Int(offsetStr) else {
                    Log.error("❌ HEAD missing Upload-Offset")
                    errorTitle = "Upload Failed"
                    errorMessage = "HEAD missing Upload-Offset"
                    return
                }

                Log.info("📍 Upload starting from offset: \(offset)")
                uploadFileInChunks(
                    fileHandle: fileHandle,
                    fileURL: fileURL,
                    to: uploadURL,
                    startingAt: offset
                )
            }
        }.resume()
    }

    func cancelUpload(fileHandle: FileHandle?) {
        fileHandle?.closeFile()
        uploadTask?.cancel()
        uploadTask = nil
        isUploading = false
        Log.debug("❌ Upload cancelled")
        viewModel.fetchFiles(at: currentPath)
    }

    func uploadFileInChunks(
        fileHandle: FileHandle,
        fileURL: URL,
        to uploadURL: URL,
        startingAt offset: Int
    ) {
        let chunkSize = advancedSettings.chunkSize * 1024 * 1024

        let fileSize = (try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? Int) ?? 0
        let fileName = fileURL.lastPathComponent
        currentUploadFile = fileName
        currentUploadFileSize = sizeConverter(fileSize)
        currentUploadFileIcon = systemIcon(for: fileName.lowercased(), extensionTypes: extensionTypes)
        var currentOffset = offset

        var uploadStartTime = Date()
        var startOffset = currentOffset

        func uploadNext() {
            // 🔁 Cancel check
            if isUploadCancelled {
                Log.info("⏹️ Upload cancelled by user.")
                cancelUpload(fileHandle: fileHandle)
                statusMessage = StatusPayload(text: "⚠️ Upload cancelled", color: .yellow)
                return
            }

            // ✅ Finished?
            guard currentOffset < fileSize else {
                fileHandle.closeFile()
                Log.info("✅ Upload complete: \(fileURL.lastPathComponent)")
                currentUploadIndex += 1
                uploadTask = nil
                uploadProgress = 1.0
                currentUploadSpeed = 0.0
                uploadNextInQueue()
                viewModel.fetchFiles(at: currentPath)
                statusMessage = StatusPayload(text: "📤 Uploaded \(fileURL.lastPathComponent)")
                return
            }

            fileHandle.seek(toFileOffset: UInt64(currentOffset))
            let data = fileHandle.readData(ofLength: chunkSize)

            uploadStartTime = Date()
            startOffset = currentOffset

            var request = URLRequest(url: uploadURL)
            request.httpMethod = "PATCH"
            request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
            request.setValue("\(currentOffset)", forHTTPHeaderField: "Upload-Offset")
            request.setValue("application/offset+octet-stream", forHTTPHeaderField: "Content-Type")
            request.setValue(self.token, forHTTPHeaderField: "X-Auth")

            uploadTask = URLSession.shared.uploadTask(with: request, from: data) { _, response, error in
                DispatchQueue.main.async {
                    if isUploadCancelled {
                        Log.info("⏹️ Upload cancelled mid-chunk. \(fileName) may be incomplete.")
                        cancelUpload(fileHandle: fileHandle)
                        statusMessage = StatusPayload(
                            text: "⚠️ Upload cancelled mid-chunk, '\(fileName)' may be incomplete.",
                            color: .yellow,
                            duration: 7
                        )
                        return
                    }

                    if let error = error {
                        Log.error("❌ PATCH failed: \(error.localizedDescription)")
                        errorTitle = "Server Error"
                        errorMessage = error.localizedDescription
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        self.errorTitle = "Server Error"
                        self.errorMessage = "Invalid response"
                        Log.error("❌ Server error: Response was not HTTPURLResponse")
                        return
                    }

                    guard httpResponse.statusCode == 204 else {
                        self.errorTitle = "Server Error"
                        self.errorMessage = "[PATCH Failed]: [\(httpResponse.statusCode)]: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                        Log.error("❌ Unexpected PATCH response: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                        return
                    }

                    let elapsed = Date().timeIntervalSince(uploadStartTime)
                    let bytesSent = currentOffset + data.count - startOffset
                    if elapsed > 0 {
                        currentUploadSpeed = Double(bytesSent) / elapsed / (1024 * 1024)
                    }

                    currentOffset += data.count
                    uploadProgress = Double(currentOffset) / Double(fileSize)
                    uploadProgressPct = Int((uploadProgress * 100).rounded())
                    currentUploadedFileSize = sizeConverter(currentOffset)
                    Log.debug("📤 Uploaded chunk — new offset: \(currentOffset)")
                    uploadNext()
                }
            }
            uploadTask?.resume()
        }
        uploadNext()
    }

    func uploadNextInQueue() {
        guard currentUploadIndex < uploadQueue.count else {
            isUploading = false
            statusMessage = StatusPayload(text: "📤 Uploaded \(currentUploadIndex) items")
            return
        }

        isUploading = true
        isPreparingUpload = false
        isUploadCancelled = false
        uploadProgress = 0.0
        let fileURL = uploadQueue[currentUploadIndex]
        initiateTusUpload(for: fileURL)
    }

    @discardableResult
    func makeRequest(
        endpoint: String,
        method: String = "GET",
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil,
        contentType: String = "application/json",
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask? {
        guard isAuthValid else {
            Log.error("❌ Auth not validated")
            errorMessage = "Invalid authorization. Please log out and log back in."
            return nil
        }
        guard var components = URLComponents(string: serverURL + endpoint) else {
            Log.error("❌ Failed to make URL components for endpoint: \(endpoint)")
            errorMessage = "Failed to make URL components."
            return nil
        }

        components.queryItems = queryItems
        guard let url = components.url else {
            errorMessage = "Failed to build URL"
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(token, forHTTPHeaderField: "X-Auth")
        if method != "GET" && method != "DELETE" {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let responseCode = (response as? HTTPURLResponse)?.statusCode ?? -1

            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ Request failed: \(error.localizedDescription)")
                    errorMessage = error.localizedDescription
                } else if responseCode != 200 {
                    let bodyString = data.flatMap { String(data: $0, encoding: .utf8) } ?? "No details"
                    Log.error("❌ Request failed with status \(responseCode): \(bodyString)")
                    errorTitle = "Server Error"
                    errorMessage = "[\(responseCode)]: \(bodyString)"
                }
                completion(data, response, error)
            }
        }

        task.resume()
        return task
    }

    func makePayload<T: Encodable>(
        what: String,
        which: [String],
        data: T
    ) -> Data? {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let jsonData = try JSONSerialization.jsonObject(with: encodedData, options: [])
            let payload: [String: Any] = [
                "what": what,
                "which": which,
                "data": jsonData
            ]
            return try JSONSerialization.data(withJSONObject: payload)
        } catch {
            Log.error("❌ Failed to encode payload: \(error.localizedDescription)")
            return nil
        }
    }

    func saveSettings() {
        guard isAuthValid else {
            Log.error("❌ Auth not validated")
            errorMessage = "Invalid authorization. Please log out and log back in."
            return
        }

        guard let currentSettings = userAccount,
              let url = buildAPIURL(
                  base: serverURL,
                  pathComponents: ["api", "users", String(currentSettings.id)],
                  queryItems: []
              ) else {
            Log.error("❌ Invalid user ID or URL")
            return
        }
        Log.debug("⚙️ Current settings: \(currentSettings)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        var updatedSettings = currentSettings
        updatedSettings.hideDotfiles = hideDotfiles
        updatedSettings.dateFormat = dateFormatExact

        // MARK: Set both current state, and auth state (since self is overriden with auth in init)
        self.userAccount = updatedSettings
        auth.userAccount = updatedSettings
        Log.debug("🔄 Updated settings: \(updatedSettings)")

        let dataDict = (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(updatedSettings))) ?? [:]

        let payload: [String: Any] = [
            "what": "user",
            "which": ["locale", "hideDotfiles", "dateFormat"],
            "data": dataDict
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? "(no body)"
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    Log.info("✅ Settings saved")
                    self.userAccount?.hideDotfiles = hideDotfiles
                    self.userAccount?.dateFormat = dateFormatExact
                    settingsMessage = StatusPayload(text: "✅ Settings saved")
                } else {
                    Log.error("❌ Settings save failed: \(body)")
                    errorTitle = "Settings save failed"
                    errorMessage = body
                    settingsMessage = StatusPayload(text: "❌ Settings save failed")
                }
            }
        }.resume()
    }

    func toggleSelectAll() {
        if selectedItems.count == viewModel.files.count {
            selectedItems.removeAll()
        } else {
            selectedItems = Set(viewModel.files)
        }
    }

    func deleteSelectedItems() {
        guard isAuthValid else {
            Log.error("❌ Auth not validated")
            errorMessage = "Invalid authorization. Please log out and log back in."
            return
        }

        let group = DispatchGroup()
        for item in selectedItems {
            guard let url = buildAPIURL(
                base: self.serverURL,
                pathComponents: ["api", "resources", item.path],
                queryItems: []
            ) else {
                Log.error("❌ Invalid path for \(item.name)")
                viewModel.errorMessage = "Invalid path for \(item.name)"
                continue
            }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue(token, forHTTPHeaderField: "X-Auth")

            group.enter()
            URLSession.shared.dataTask(with: request) { _, _, _ in
                group.leave()
            }.resume()
        }

        group.notify(queue: .main) {
            let count = selectedItems.count
            Log.info("✅ Deleted \(count) items")
            selectedItems.removeAll()
            selectionMode = false
            viewModel.fetchFiles(at: currentPath)
            statusMessage = StatusPayload(text: "🗑️ Deleted \(count) \(count == 1 ? "item" : "items")", color: .red, duration: 3)
        }
    }

    func renameSelectedItem() {
        guard let item = selectedItems.first else { return }
        let fromPath = item.path
        let toPath = URL(fileURLWithPath: item.path)
            .deletingLastPathComponent()
            .appendingPathComponent(renameInput)
            .path

        guard let encodedFrom = fromPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let encodedTo = toPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            Log.error("❌ Failed to encode paths")
            errorMessage = "Failed to rename \(item.name)"
            return
        }

        let endpoint = "/api/resources/\(removePrefix(urlPath: encodedFrom))"
        let query: [URLQueryItem] = [
            URLQueryItem(name: "action", value: "rename"),
            URLQueryItem(name: "destination", value: encodedTo),
            URLQueryItem(name: "override", value: "false"),
            URLQueryItem(name: "rename", value: "false")
        ]

        makeRequest(endpoint: endpoint, method: "PATCH", queryItems: query) { _, response, _ in
            DispatchQueue.main.async {
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    Log.info("✅ Rename successful")
                    selectedItems.removeAll()
                    isRenaming = false
                    selectionMode = false
                    viewModel.fetchFiles(at: currentPath)
                    statusMessage = StatusPayload(text: "📝 Renamed \(item.name) → \(renameInput)", color: .yellow, duration: 3)
                }
            }
        }
    }

    func toggleSelection(for item: FileItem) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }

    func createResource(isDirectory: Bool) {
        guard isAuthValid else {
            Log.error("❌ Auth not validated")
            errorMessage = "Invalid authorization. Please log out and log back in."
            return
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTimeZone]
        let isoString = formatter.string(from: Date())

        let fileItem = FileItem(
            name: newResourceName,
            path: newResourceName,
            isDir: isDirectory,
            modified: isoString,
            size: 0,
            extension: isDirectory ? nil : newResourceName.split(separator: ".").last.map(String.init)
        )
        let fullPath = self.fullPath(for: fileItem)

        guard let encodedPath = fullPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            Log.error("❌ Failed to encode path")
            viewModel.errorMessage = "Failed to encode path"
            return
        }

        // MARK: Condition based path seaparator for resource creation
        let separator = isDirectory ? "/?" : "?"
        let resourceType = isDirectory ? "Folder" : "File"
        let emoji = isDirectory ? "📁" : "📄"
        let endpoint = "/api/resources/\(removePrefix(urlPath: encodedPath))\(separator)"
        let query: [URLQueryItem] = [
            URLQueryItem(name: "override", value: "false")
        ]

        Log.info("🔄 Creating \(resourceType) at path: \(fullPath)")

        makeRequest(endpoint: endpoint, method: "POST", queryItems: query) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ \(resourceType) creation failed: \(error.localizedDescription)")
                    errorTitle = "Create Failed"
                    errorMessage = "\(resourceType) creation failed: \(error.localizedDescription)"
                    return
                }

                guard let http = response as? HTTPURLResponse else {
                    Log.error("❌ No HTTP response received")
                    return
                }

                if http.statusCode == 200 {
                    Log.info("✅ \(resourceType) created successfully")
                    viewModel.fetchFiles(at: currentPath)
                    statusMessage = StatusPayload(text: "\(emoji) \(newResourceName) created")
                } else {
                    Log.error("❌ \(resourceType) creation failed with status code: \(http.statusCode)")
                    errorTitle = "Create Failed"
                    errorMessage = "\(resourceType) creation failed: \(http.statusCode)"
                }
            }
        }
    }

    func refreshFolder() {
        Log.debug("ℹ️ Refresh Directory")
        viewModel.fetchFiles(at: currentPath)
    }

    private func fullPath(for file: FileItem) -> String {
        if currentPath == "/" {
            return "/\(file.name)"
        } else {
            return "\(currentPath)/\(file.name)"
        }
    }
}

// Wrapper for decoding FileBrowser's response
struct ResourceResponse: Codable {
    let items: [FileItem]
}
