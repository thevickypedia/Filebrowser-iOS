//
//  FileListView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import UIKit
import SwiftUI
import Network
import UniformTypeIdentifiers

struct FileListView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var viewModel: FileListViewModel
    @State private var progressObserver: NSObjectProtocol?
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var photoPickerStatus = PhotoPickerStatus()

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
    @State private var sharePath: FileItem?

    @State private var hideDotfiles = false
    @State private var redirectAfterCopyMove = false
    @State private var showingSettings = false
    @State private var dateFormatExact = false

    // Track transfer state progress
    @State private var downloadStatus: [String: TransferResult] = [:]
    @State private var uploadStatus: [String: TransferResult] = [:]

    @State private var showMove = false
    @State private var showCopy = false
    @State private var showDownload = false
    @State private var sheetPathStack: [FileItem] = []

    // Common Handler (for both upload and download)
    @State private var transferState: TransferState = TransferState()

    // Download vars
    @State private var downloadQueue: [DownloadQueueItem] = []
    @State private var currentDownloadTaskID: UUID?
    @State private var pausedResumeData: Data?

    // Upload vars
    @State private var uploadQueue: [URL] = []
    @State private var currentFileHandle: FileHandle?
    @State private var currentUploadURL: URL?
    @State private var currentUploadedOffset: Int = 0
    @State private var uploadTask: URLSessionUploadTask?
    @State private var isFileUpload = false
    @State private var isPhotoUpload = false
    @State private var showFileImporter = false
    @State private var showPhotoPicker = false

    @State private var usageInfo: (used: Int64, total: Int64)?

    @State private var sortOption: SortOption = .nameAsc
    @AppStorage("viewMode") private var viewModeRawValue: String = ViewMode.list.rawValue

    @State private var loadingFiles: [String: Bool] = [:] // Track loading state by file path

    @State private var displayLimit: Int = Constants.filesDisplayLimit
    @State private var hasLoadedMore = false

    @State private var currentDisplayPath: String = "/"
    @State private var isNavigating = false

    @State private var showShareSettings: Bool = false
    @State private var showAdvancedServerSettings: Bool = false

    private var viewMode: ViewMode {
        get { ViewMode(rawValue: viewModeRawValue) ?? .list }
        set { viewModeRawValue = newValue.rawValue }
    }

    // Display as alerts
    @State private var errorTitle: String?
    @State private var errorMessage: String?

    // Display as disappearing labels
    @State private var settingsMessage: ToastMessagePayload?
    @State private var toastMessage: ToastMessagePayload?
    @State private var modifyMessage: ToastMessagePayload?

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
    let backgroundLogin: BackgroundLogin
    let baseRequest: Request

    init(
        isLoggedIn: Binding<Bool>,
        pathStack: Binding<[String]>,
        logoutHandler: @escaping (Bool) -> Void,
        extensionTypes: ExtensionTypes,
        advancedSettings: AdvancedSettings,
        cacheExtensions: [String],
        backgroundLogin: BackgroundLogin,
        baseRequest: Request
    ) {
        self._isLoggedIn = isLoggedIn
        self._pathStack = pathStack
        self.logoutHandler = logoutHandler
        self.extensionTypes = extensionTypes
        self.advancedSettings = advancedSettings
        self.cacheExtensions = cacheExtensions
        self.backgroundLogin = backgroundLogin
        self.baseRequest = baseRequest
    }

    private func invalidAuth() {
        Log.error("❌ Auth not validated")
        errorTitle = "Auth Error"
        errorMessage = "Invalid authorization. Please log out and log back in."
    }

    private func fetchFiles(at path: String) {
        // Update display immediately for smooth UI
        currentDisplayPath = path

        // Cancel any existing fetch
        viewModel.cancelCurrentFetch()

        // Reset to initial limit on new directory
        displayLimit = Constants.filesDisplayLimit

        // Clear loading states from previous directory
        loadingFiles.removeAll()

        guard auth.isValid else { invalidAuth(); return }
        viewModel.fetchFiles(baseRequest: baseRequest, at: path)
    }

    private var homeStack: some View {
        HStack {
            Button(action: {
                // Update state immediately
                pathStack = []
                currentDisplayPath = "/"
                Log.info("🔙 Dismissing to root directory")
                fetchFiles(at: "/")
            }) {
                Image(systemName: "house")
            }
        }
    }

    private var searchingStack: some View {
        VStack {
            HStack {
                // MARK: Keyboard with "go" button
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
                        toastMessage = ToastMessagePayload(
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
                    fetchFiles(at: pathStack.last ?? "/")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                }
                .buttonStyle(.plain)
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
                    .buttonStyle(.plain)
                    .disabled(searchInProgress)
                }
            }
        }
    }

    private func nextUploadInQueue() -> String? {
        if transferState.currentTransferIndex + 1 < uploadQueue.count {
            return "Next up: \(uploadQueue[transferState.currentTransferIndex + 1].lastPathComponent)"
        } else if transferState.transferType == nil {
            return "Processing \(pendingUploads) pending files"
        }
        return nil
    }

    private var actionsTabStack: some View {
        return Menu {
            if auth.userPermissions?.create == true {
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
                })
                Button("From Photos", systemImage: "photo", action: {
                    showPhotoPicker = true
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
            if !viewModel.files.isEmpty && auth.hasModifyPermissions {
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

    private var selectedStack: some View {
        return Menu {
            if auth.userPermissions?.download == true {
                // 📥 Download
                Button(action: {
                    for item in selectedItems {
                        enqueueDownload(file: item)
                    }
                    selectedItems.removeAll()
                    selectionMode = false
                }) {
                    Label("Download", systemImage: "arrow.down")
                }
            }

            if auth.userPermissions?.modify == true {
                // ➡️ Move
                Button(action: {
                    showMove = true
                }) {
                    Label("Move", systemImage: "arrow.right")
                }
            }

            if auth.userPermissions?.execute == true {
                // 📋 Copy
                Button(action: {
                    showCopy = true
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }

            // 📝 Rename and Share links only when exactly 1 item is selected
            if selectedItems.count == 1,
               let item = selectedItems.first {
                if auth.userPermissions?.rename == true {
                    Button(action: {
                        renameInput = item.name
                        isRenaming = true
                    }) {
                        Label("Rename", systemImage: "pencil")
                    }
                }

                if auth.userPermissions?.share == true {
                    Button(action: {
                        sharePath = item
                        isSharing = true
                    }) {
                        Label {
                            Text("Share")
                                .foregroundColor(.blue)
                        } icon: {
                            Image("material_share_icon")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            if auth.userPermissions?.delete == true {
                // 🗑️ Delete
                Button(role: .destructive, action: {
                    showingDeleteConfirm = true
                }) {
                    Label("Delete", systemImage: "trash")
                        .foregroundStyle(.red)
                }
                .foregroundStyle(.red)
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
        }
    }

    private var showSettingsSheet: some View {
        Form {
            Toggle("Hide dotfiles", isOn: $hideDotfiles)
            Toggle("Set exact date format", isOn: $dateFormatExact)
            Toggle("Redirect to destination after copy/move", isOn: $redirectAfterCopyMove)
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

            // Show shared content
            Section {
                Button(action: {
                    showShareSettings = true
                }) {
                    Label {
                        Text("Share Management")
                            .foregroundColor(.blue)
                    } icon: {
                        Image("material_share_icon")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                }
            }

            // Show advanced settings
            Section {
                Button {
                    showAdvancedServerSettings = true
                } label: {
                    Label("Advanced Settings", systemImage: "server.rack")
                }
            }
        }
        // MARK: Messages within the settings sheet
        .modifier(ToastMessage(payload: $settingsMessage))
        .onAppear {
            getCurrentSettings()
            fetchUsageInfo()
        }
        .sheet(isPresented: $showAdvancedServerSettings) {
            AdvancedServerSettingsView(
                logoutHandler: logoutHandler,
                extensionTypes: extensionTypes,
                backgroundLogin: backgroundLogin
            )
        }
        .sheet(isPresented: $showShareSettings) {
            ShareManagementView(baseRequest: baseRequest)
        }
    }

    // Fixed modifySheet implementation
    private var currentSheetPath: String {
        // Build path from sheetPathStack, starting from root
        if sheetPathStack.isEmpty {
            return "/"
        }

        var path = "/"
        for item in sheetPathStack {
            if path != "/" {
                path += "/"
            }
            path += item.name
        }
        return path
    }

    private func modifySheet(action: ModifyItem) -> some View {
        NavigationStack {
            VStack {
                HStack {
                    // Back button - goes up one level in sheetPathStack
                    Button(action: {
                        if !sheetPathStack.isEmpty {
                            sheetPathStack.removeLast()
                            viewModel.getFiles(baseRequest: baseRequest, at: currentSheetPath, modifySheet: true)
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .foregroundColor(sheetPathStack.isEmpty ? .gray : .primary)
                    .disabled(sheetPathStack.isEmpty) // Disable when at root

                    Spacer()

                    // Home button - goes to root directory
                    Button(action: {
                        sheetPathStack.removeAll()
                        viewModel.getFiles(baseRequest: baseRequest, at: "/", modifySheet: true)
                    }) {
                        VStack {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    }

                    Spacer()

                    // Action button (Move/Copy)
                    let icon = action == ModifyItem.move ? "arrow.right.circle.fill" : "doc.on.doc"
                    Button(action: {
                        modifyItem(to: currentSheetPath, action: action)
                    }) {
                        HStack {
                            Text(action.rawValue).bold()
                            Image(systemName: icon)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                Divider()

                // Folder list or loading spinner
                if viewModel.sheetIsLoading {
                    Spacer()
                    ProgressView("Loading folders...")
                        .padding()
                    Spacer()
                } else {
                    if viewModel.sheetItems.isEmpty {
                        Text("No folders found").foregroundColor(.gray).padding()
                    } else {
                        List {
                            ForEach(viewModel.sheetItems.filter { $0.isDir }, id: \.id) { file in
                                Button(action: {
                                    sheetPathStack.append(file)
                                    viewModel.getFiles(baseRequest: baseRequest, at: currentSheetPath, modifySheet: true)
                                }) {
                                    HStack {
                                        Image(systemName: Icons.folder)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)
                                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
                                        Text(file.name)
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top) // Pins VStack content to top
            .navigationTitle(getSheetNavigationTitle(sheetPathStack))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Initialize sheetPathStack based on currentPath when sheet appears
                initializeSheetPath()
                viewModel.getFiles(baseRequest: baseRequest, at: currentSheetPath, modifySheet: true)
            }
        }
        .modifier(ToastMessage(payload: $modifyMessage))
    }

    private func initializeSheetPath() {
        // Initialize sheetPathStack to represent the current path
        sheetPathStack.removeAll()

        if currentPath != "/" {
            let pathComponents = currentPath.components(separatedBy: "/").filter { !$0.isEmpty }

            // Build FileItem objects for each path component
            var buildingPath = ""
            for component in pathComponents {
                buildingPath += "/" + component
                let fileItem = FileItem(
                    name: component,
                    path: buildingPath,
                    isDir: true,
                    modified: nil,
                    size: nil,
                    extension: nil
                )
                sheetPathStack.append(fileItem)
            }
        }
    }

    private func checkPathExists(_ fullPath: String) -> Bool {
        guard auth.isValid else { invalidAuth(); return false }

        guard let preparedRequest = baseRequest.prepare(pathComponents: ["api", "resources", fullPath]) else {
            let msg = "Failed to prepare request for: /api/resources/\(fullPath)"
            Log.error("❌ \(msg)")
            errorTitle = "Internal Error"
            errorMessage = msg
            return false
        }

        var exists = false
        let semaphore = DispatchSemaphore(value: 0)

        preparedRequest.session.dataTask(with: preparedRequest.request) { _, response, error in
            defer { semaphore.signal() }

            if let error = error {
                Log.error("❌ Request error: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
                return
            }

            if let http = response as? HTTPURLResponse {
                if http.statusCode == 200 {
                    exists = true
                } else if http.statusCode == 404 {
                    exists = false
                } else {
                    Log.error("❌ Path check failed with status \(http.statusCode)")
                    errorMessage = "Server returned status \(http.statusCode)"
                }
            }
        }.resume()

        semaphore.wait() // ⚠️ Blocking here

        return exists
    }

    private func modifyItem(to destinationPath: String, action: ModifyItem) {
        let logAction = action.rawValue.lowercased()
        guard !selectedItems.isEmpty else {
            Log.warn("No items selected to \(logAction)")
            return
        }

        // Validate destination path
        guard !destinationPath.isEmpty else {
            Log.error("Empty destination path for \(logAction)")
            toastMessage = ToastMessagePayload(text: "Invalid destination path", color: .red, duration: 3)
            return
        }

        let selectedNames = selectedItems.map { $0.name }
        let selectedCount = selectedItems.count
        Log.info("Selected items [\(selectedCount)] for \(logAction): \(selectedNames)")
        Log.info("\(action.rawValue.capitalized) to path: \(destinationPath)")

        let statusActionPost = action == ModifyItem.copy ? "Copied" : "Moved"

        // Create a DispatchGroup to track completion
        let dispatchGroup = DispatchGroup()
        var successCount = 0
        var errorCount = 0

        // MARK: Loop ends even if one item fails to move/copy
        for item in selectedItems {
            dispatchGroup.enter()

            let sourcePath = item.path.hasPrefix("/") ? item.path : "/" + item.path
            let encodedSource = sourcePath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? sourcePath

            let destinationFullPath: String
            if destinationPath == "/" {
                destinationFullPath = "/" + item.name
            } else {
                destinationFullPath = destinationPath + "/" + item.name
            }
            let encodedDestination = destinationFullPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? destinationFullPath

            // Client side issue: Break loop without resetting flags, so sheet is still up
            if checkPathExists(encodedDestination) {
                let msg = "⚠️ \(item.name) already exists at \(destinationPath)"
                Log.error(msg)
                modifyMessage = ToastMessagePayload(text: msg, color: .yellow, duration: 2)
                return
            }

            let urlAction = action == ModifyItem.move ? "rename" : "copy"
            let sourceForURL = encodedSource.hasPrefix("/") ? String(encodedSource.dropFirst()) : encodedSource

            // Client side issue: Break loop without resetting flags, so sheet is still up
            guard let preparedRequest = baseRequest.prepare(
                pathComponents: ["api", "resources", sourceForURL],
                queryItems: [
                    URLQueryItem(name: "action", value: urlAction),
                    URLQueryItem(name: "destination", value: encodedDestination),
                    URLQueryItem(name: "override", value: "false"),
                    URLQueryItem(name: "rename", value: "false")
                ],
                method: RequestMethod.patch
            ) else {
                let msg = "Invalid URL for \(item.name)"
                modifyMessage = ToastMessagePayload(text: msg, color: .primary, duration: 2)
                Log.error(msg)
                errorCount += 1
                dispatchGroup.leave()
                return
            }

            let task = preparedRequest.session.dataTask(with: preparedRequest.request) { _, response, error in
                defer { dispatchGroup.leave() }

                // Server side issue: Continue to next item and display errors at last in list view
                if let error = error {
                    let msg = "Failed to \(logAction) \(item.name): \(error.localizedDescription)"
                    Log.error(msg)
                    DispatchQueue.main.async {
                        errorCount += 1
                    }
                    return
                }

                // Server side issue: Continue to next item and display errors at last in list view
                guard let httpResponse = response as? HTTPURLResponse else {
                    let msg = "Invalid response received when trying to \(logAction) \(item.name)"
                    Log.error(msg)
                    DispatchQueue.main.async {
                        errorCount += 1
                    }
                    return
                }

                if httpResponse.statusCode == 200 {
                    Log.info("\(item.name) \(logAction)d successfully to \(destinationPath)")
                    DispatchQueue.main.async {
                        successCount += 1
                    }
                } else {
                    // Server side issue: Continue to next item and display errors at last in list view
                    let msg = "Failed to \(logAction) \(item.name). HTTP Status: \(httpResponse.statusCode)"
                    Log.error(msg)
                    DispatchQueue.main.async {
                        errorCount += 1
                    }
                }
            }
            task.resume()
        }

        // Wait for all tasks to complete
        dispatchGroup.notify(queue: .main) {
            Log.info("\(successCount) items successfully \(statusActionPost), \(errorCount) failed")

            // Show completion message
            if errorCount == 0 {
                toastMessage = ToastMessagePayload(
                    text: "✅ \(statusActionPost) \(successCount) item\(successCount == 1 ? "" : "s")",
                    color: .green,
                    duration: 3
                )
            } else if successCount > 0 {
                toastMessage = ToastMessagePayload(
                    text: "⚠️ \(statusActionPost) \(successCount), \(errorCount) failed",
                    color: .yellow,
                    duration: 4
                )
            } else {
                toastMessage = ToastMessagePayload(
                    text: "❌ Failed to \(logAction) items",
                    color: .red,
                    duration: 3
                )
            }

            // Close the sheet and refresh the current directory
            showCopy = false
            showMove = false
            selectedItems.removeAll()
            selectionMode = false
            fetchFiles(at: currentPath)
        }
    }

    private func retainUploadingStack() -> Bool {
        if isFileUpload {
            // If it's a file upload check if uploadQueue is empty (since all URLs are loaded initially)
            return !uploadQueue.isEmpty
        }
        if photoPickerStatus.isPreparingUpload {
            return false
        }
        if photoPickerStatus.totalSelected == 0 {
            // If totalSelected is empty, check pendingUploads (reverse and return)
            return pendingUploads != 0
        }
        // If totalSelected is not empty, then check if uploadQueue is smaller
        return uploadQueue.count < photoPickerStatus.totalSelected
    }

    private func notifyTransferState(_ action: TransferType, _ state: TransferStatus) {
        let currentState = action == .upload
            ? "[\(transferState.currentTransferIndex + 1)/\(uploadQueue.count)]"
            : "[\(transferState.currentTransferIndex + 1)/\(downloadQueue.count)]"

        let text = transferState.currentTransferFile.map {
            "\(state.emoji) \(action.rawValue) \(currentState) - \($0) - \(state.rawValue) \(state.prefix) \(transferState.transferProgressPct)%"
        } ?? "\(state.emoji) \(action.rawValue) \(state.rawValue)"

        toastMessage = ToastMessagePayload(
            text: text,
            color: state.color,
            duration: 3
        )

        Log.info(text)
    }

    private var uploadStack: some View {
        UploadingStack(
            isUploading: transferState.transferType == .upload,
            fileName: transferState.currentTransferFile,
            fileIcon: transferState.currentTransferFileIcon,
            uploaded: transferState.currentTransferedFileSize,
            total: transferState.currentTransferFileSize,
            progress: transferState.transferProgress,
            progressPct: transferState.transferProgressPct,
            speed: transferState.currentTransferSpeed,
            index: transferState.currentTransferIndex,
            totalCount: photoPickerStatus.totalSelected,
            chunkSize: advancedSettings.chunkSize,
            isPaused: transferState.isTransferPaused,
            onPause: { pauseUpload() },
            onResume: { resumeUpload() },
            onCancel: {
                notifyTransferState(TransferType.upload, TransferStatus.cancelled)
                transferState.isTransferCancelled = true
                cancelUpload(fileHandle: nil, statusText: nil)
            },
            nextUploadInQueue: { nextUploadInQueue() }
        )
    }

    private var downloadStack: some View {
        DownloadingStack(
            fileName: transferState.currentTransferFile,
            fileIcon: transferState.currentTransferFileIcon,
            downloaded: transferState.currentTransferedFileSize,
            total: transferState.currentTransferFileSize,
            progress: transferState.transferProgress,
            progressPct: transferState.transferProgressPct,
            speed: transferState.currentTransferSpeed,
            index: transferState.currentTransferIndex + 1,
            totalCount: downloadQueue.count,
            isPaused: transferState.isTransferPaused,
            onPause: { pauseDownload() },
            onResume: { resumeDownload() },
            onCancel: {
                notifyTransferState(TransferType.download, TransferStatus.cancelled)
                cancelDownload()
            }
        )
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
                    // MARK: Preparing upload will be displayed only for uploads from Photos app
                    if photoPickerStatus.isPreparingUpload {
                        preparingUploadStack(totalSelected: photoPickerStatus.totalSelected)
                    }

                    if let transferType = transferState.transferType {
                        switch transferType {
                        case .upload:
                            uploadStack
                        case .download:
                            downloadStack
                        }
                    } else {
                        if retainUploadingStack() { uploadStack }
                        if showDownload { downloadStack }
                    }

                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)").foregroundColor(.red)
                    } else {
                        let sortedFiles = viewModel.sortedFiles(by: sortOption)
                        let filesToDisplay = Array(sortedFiles.prefix(displayLimit))
                        Group {
                            if viewMode == .list {
                                listView(for: filesToDisplay)
                            } else {
                                gridView(for: filesToDisplay, module: viewMode == .module)
                            }
                        }
                        // "Load More" button if there are more files
                        if sortedFiles.count > displayLimit {
                            Button(action: {
                                displayLimit += Constants.filesDisplayLimit
                            }) {
                                HStack {
                                    Text("Load More (\(sortedFiles.count - displayLimit) remaining)")
                                    Image(systemName: "arrow.down.circle.fill")
                                }
                                .foregroundColor(.blue)
                                .padding()
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
        .navigationTitle(getNavigationTitle(for: currentDisplayPath))
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

            // Right: Actions (person icon) and Selection (three dot) buttons
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Buttons to display when something is selected
                if selectionMode {
                    // Selection (three dot) buttons - needs at least one item to be selected
                    if selectedItems.count > 0 {
                        selectedStack
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
                } else {
                    actionsTabStack
                    selectionStack
                }
                // ⏏ 🔚 Logout
                Button(action: {
                    Log.info("Logged out!")
                    logoutHandler(false)
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .id("filelist-\(currentDisplayPath)-\(pathStack.count)")
        // MARK: Messages on any listing page with no sheets presented
        .modifier(ToastMessage(payload: $toastMessage))
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
            guard auth.isValid else { invalidAuth(); return }

            if !searchClicked && !searchInProgress {
                let targetPath = currentPath
                currentDisplayPath = targetPath
                Log.debug("📂 FileListView appeared for path: \(targetPath)")
                fetchFiles(at: targetPath)
            }
        }
        .onDisappear {
            if let obs = progressObserver {
                NotificationCenter.default.removeObserver(obs)
                progressObserver = nil
            }
            // Clean up when leaving the view entirely
            loadingFiles.removeAll()
        }
        .sheet(isPresented: $isSharing) {
            if let filePath = sharePath ?? selectedItems.first {
                ShareSheetView(
                    serverURL: auth.serverURL,
                    token: auth.token,
                    file: filePath,
                    onDismiss: { isSharing = false },
                    baseRequest: baseRequest
                )
            } else {
                // sharePath is nil
                Text("No item selected to share").padding()
            }
        }
        .sheet(isPresented: $showCopy) {
            modifySheet(action: ModifyItem.copy)
        }
        .sheet(isPresented: $showMove) {
            modifySheet(action: ModifyItem.move)
        }
        .sheet(isPresented: $showingSettings) {
            showSettingsSheet
        }
        .sheet(isPresented: $showPhotoPicker, onDismiss: {
            // This will fire on cancel, swipe down or selection - so check selected count first
            if photoPickerStatus.totalSelected == 0 && photoPickerStatus.isPreparingUpload {
                Log.warn("Upload sheet dismissed without selection")
                photoPickerStatus.isPreparingUpload = false
            }
        }) {
            PhotoPicker(
                photoPickerStatus: photoPickerStatus,
                onFilePicked: { url in
                    isPhotoUpload = true
                    uploadQueue.append(url)
                    if transferState.transferType == nil {
                        uploadNextInQueue()
                    }
                }
            )
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                isFileUpload = true
                uploadQueue = urls
                transferState.currentTransferIndex = 0
                uploadNextInQueue()
            case .failure(let error):
                isFileUpload = false
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

    private func pauseDownload(networkFailure: Bool = false) {
        transferState.isTransferPaused = true
        if let id = currentDownloadTaskID {
            if networkFailure {
                self.toastMessage = ToastMessagePayload(
                    text: "⏸️ Download paused due to network error. Please resume manually when network is available.",
                    color: .orange,
                    duration: 5
                )
            } else {
                notifyTransferState(TransferType.download, TransferStatus.paused)
            }
            Log.info("Download ID [\(id)] stored as paused resume data")
            DownloadManager.shared.pause(id) { data in
                pausedResumeData = data
            }
        } else {
            Log.warn("Download ID [currentDownloadTaskID] is missing")
            errorTitle = "Pause download failed"
            errorMessage = "Download ID is missing - unable to pause download"
        }
    }

    private func cancelDownload() {
        transferState.isTransferCancelled = true
        if let id = currentDownloadTaskID {
            DownloadManager.shared.cancel(id)
        }
        downloadQueue.removeAll()
        transferState.currentTransferIndex = 0
        transferState.transferProgress = 0.0
        transferState.transferType = nil
        showDownload = false
    }

    private func resumeDownload() {
        guard let data = pausedResumeData else {
            Log.warn("Resume download condition not met, re-starting")
            Task {
                let serverHealth = await checkServerHealth(baseRequest: baseRequest)
                if serverHealth.success {
                    self.toastMessage = ToastMessagePayload(
                        text: "⏯️ Resume download condition not met, re-starting",
                        color: .yellow
                    )
                    startNextDownload()
                } else {
                    Log.error("No network connection while trying to restart download.")
                    pauseDownload(networkFailure: true)
                }
            }
            return
        }

        Task {
            let serverHealth = await checkServerHealth(baseRequest: baseRequest)
            if !serverHealth.success {
                startNextDownload()
                Log.error("No network connection while trying to restart download.")
                pauseDownload(networkFailure: true)
                return
            }
            notifyTransferState(TransferType.download, TransferStatus.resumed)
            transferState.isTransferPaused = false
            let file = downloadQueue[transferState.currentTransferIndex].file
            transferState.currentTransferFile = file.name
            transferState.currentTransferFileIcon = systemIcon(for: file.name.lowercased(), extensionTypes: extensionTypes)
            transferState.transferProgress = 0
            transferState.transferProgressPct = 0
            transferState.transferType = TransferType.download

            var downloadStartTime = Date()
            var bytesDownloadedSinceLastUpdate: Int64 = 0
            var speedUpdateTimer: Timer?

            let newID = UUID()
            currentDownloadTaskID = newID

            DownloadManager.shared.resume(
                with: data,
                id: newID,
                progress: { bytesWritten, totalBytesWritten, totalBytesExpected in
                    DispatchQueue.main.async {
                        bytesDownloadedSinceLastUpdate += bytesWritten
                        let elapsed = Date().timeIntervalSince(downloadStartTime)
                        if elapsed >= Constants.downloadSpeedUpdateInterval {
                            let downloadSpeed = Double(bytesDownloadedSinceLastUpdate) / elapsed / (1024 * 1024)
                            transferState.currentTransferSpeed = downloadSpeed
                            downloadStartTime = Date()
                            bytesDownloadedSinceLastUpdate = 0
                        }

                        guard totalBytesExpected > 0 else {
                            self.transferState.transferProgress = 0
                            self.transferState.transferProgressPct = 0
                            return
                        }
                        let prog = Double(totalBytesWritten) / Double(totalBytesExpected)
                        self.transferState.transferProgress = prog
                        self.transferState.transferProgressPct = Int(prog * 100)
                        self.transferState.currentTransferedFileSize = formatBytes(totalBytesWritten)
                        self.transferState.currentTransferFileSize = formatBytes(totalBytesExpected)
                    }
                },
                completion: { result in
                    DispatchQueue.main.async {
                        speedUpdateTimer?.invalidate()
                        pausedResumeData = nil

                        switch result {
                        case .success(let localURL):
                            Log.info("✅ Resumed download finished: \(file.name)")
                            downloadStatus[file.path] = .success
                            FileDownloadHelper.handleDownloadCompletion(
                                file: file,
                                localURL: localURL,
                                toastMessage: $toastMessage,
                                errorTitle: $errorTitle,
                                errorMessage: $errorMessage
                            )
                        case .failure(let err):
                            downloadStatus[file.path] = .failed
                            Log.error("❌ Resumed download failed: \(err.localizedDescription)")
                        }

                        self.transferState.currentTransferIndex += 1
                        if self.transferState.currentTransferIndex >= self.downloadQueue.count {
                            // Finished all
                            self.downloadQueue.removeAll()
                            self.transferState.currentTransferIndex = 0
                            self.transferState.transferType = nil
                            self.currentDownloadTaskID = nil
                            self.showDownload = false
                            self.transferState.transferProgress = 0
                            let status = downloadStatus
                            guard !status.isEmpty else {
                                Log.error("Download status not registered")
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showTransferStatus(status, .download)
                            }
                            downloadStatus = [:]
                        } else {
                            self.startNextDownload()
                        }
                    }
                })
            // Start speed update timer (optional; since closure is empty)
            speedUpdateTimer = Timer.scheduledTimer(withTimeInterval: Constants.downloadSpeedUpdateInterval, repeats: true) { _ in }
        }
    }

    // Call this to queue a single file for download from FileListView
    private func enqueueDownload(file: FileItem) {
        let item = DownloadQueueItem(file: file)
        downloadQueue.append(item)
        showDownload = true
        // start if idle
        if transferState.transferType == nil {
            startNextDownload()
        }
    }

    // Start the next item in the queue
    private func startNextDownload() {
        guard !downloadQueue.isEmpty else {
            // nothing to do
            transferState.transferType = nil
            showDownload = false
            transferState.transferProgress = 0
            transferState.currentTransferIndex = 0
            currentDownloadTaskID = nil
            return
        }

        let item = downloadQueue[transferState.currentTransferIndex]
        let file = item.file
        transferState.currentTransferFile = file.name
        transferState.transferProgress = 0
        transferState.transferProgressPct = 0
        transferState.transferType = TransferType.download

        // Set the download file icon
        transferState.currentTransferFileIcon = systemIcon(for: file.name.lowercased(), extensionTypes: extensionTypes)

        // Build raw URL (same as FileDetailView)
        guard let url = buildAPIURL(
            baseURL: auth.serverURL,
            pathComponents: ["api", "raw", file.path],
            queryItems: [ URLQueryItem(name: "auth", value: auth.token) ]
        ) else {
            errorTitle = "Internal Error"
            errorMessage = "Invalid download URL for \(file.name)"
            transferState.transferType = nil
            return
        }

        // Variables to track download speed
        var downloadStartTime = Date()
        // Instead of updating transferState.currentTransferSpeed immediately with each chunk,
        // we accumulate the bytes downloaded and calculate the speed at certain intervals
        var bytesDownloadedSinceLastUpdate: Int64 = 0

        // Timer to update the speed every second
        var speedUpdateTimer: Timer?

        // Kick off the download via DownloadManager
        let taskID = DownloadManager.shared.download(from: url, token: auth.token,
            progress: { bytesWritten, totalBytesWritten, totalBytesExpected in
                DispatchQueue.main.async {
                    // Accumulate bytes downloaded
                    bytesDownloadedSinceLastUpdate += bytesWritten
                    // Calculate download speed with 'downloadSpeedUpdateInterval'
                    let elapsed = Date().timeIntervalSince(downloadStartTime)
                    if elapsed >= Constants.downloadSpeedUpdateInterval {
                        let downloadSpeed = Double(bytesDownloadedSinceLastUpdate) / elapsed / (1024 * 1024)
                        transferState.currentTransferSpeed = downloadSpeed
                        // Reset counters for the next period
                        downloadStartTime = Date()
                        bytesDownloadedSinceLastUpdate = 0
                    }
                    // Update progress
                    guard totalBytesExpected > 0 else {
                        self.transferState.transferProgress = 0
                        self.transferState.transferProgressPct = 0
                        return
                    }
                    let prog = Double(totalBytesWritten) / Double(totalBytesExpected)
                    self.transferState.transferProgress = prog
                    self.transferState.transferProgressPct = Int(prog * 100)
                    // Optional size strings
                    self.transferState.currentTransferedFileSize = formatBytes(totalBytesWritten)
                    self.transferState.currentTransferFileSize = formatBytes(totalBytesExpected)
                }
            },
            completion: { result in
                DispatchQueue.main.async {
                    // Invalidate the timer once the download is complete
                    speedUpdateTimer?.invalidate()
                    switch result {
                    case .failure(let error) where error.isNetworkError:
                        // Network error
                        Log.warn("⚠️ Network error during download: \(error.localizedDescription)")
                        pauseDownload(networkFailure: true)
                        return
                    case .failure(let err):
                        // Non-network error
                        Log.error("❌ Download failed: \(err.localizedDescription)")
                        downloadStatus[file.path] = .failed
                    case .success(let localURL):
                        Log.info("✅ Download finished: \(file.name)")
                        downloadStatus[file.path] = .success
                        FileDownloadHelper.handleDownloadCompletion(
                            file: file,
                            localURL: localURL,
                            toastMessage: $toastMessage,
                            errorTitle: $errorTitle,
                            errorMessage: $errorMessage
                        )
                    }

                    // Move to next item
                    self.transferState.currentTransferIndex += 1
                    if self.transferState.currentTransferIndex >= self.downloadQueue.count {
                        // Finished all
                        self.downloadQueue.removeAll()
                        self.transferState.currentTransferIndex = 0
                        self.transferState.transferType = nil
                        self.currentDownloadTaskID = nil
                        self.showDownload = false
                        self.transferState.transferProgress = 0
                        let status = downloadStatus
                        guard !status.isEmpty else {
                            Log.error("Download status not registered")
                            return
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showTransferStatus(status, .download)
                        }
                        downloadStatus = [:]
                    } else {
                        // Start next
                        self.startNextDownload()
                    }
                }
            })

        // Store task ID so it can be cancelled
        currentDownloadTaskID = taskID
        // Update download speed in the UX with 'downloadSpeedUpdateInterval'
        speedUpdateTimer = Timer.scheduledTimer(withTimeInterval: Constants.downloadSpeedUpdateInterval, repeats: true) { _ in }
    }

    func showTransferStatus(_ progressStore: [String: TransferResult], _ type: TransferType) {
        // Show summary
        let total = progressStore.count
        let (failed, success) = progressStore.reduce(into: (0, 0)) { counts, entry in
            switch entry.value {
            case .failed: counts.0 += 1
            case .success: counts.1 += 1
            }
        }
        let direction = type == .upload ? "Up" : "Down"
        if failed == 0 {
            toastMessage = ToastMessagePayload(
                text: "✅ \(direction)loaded \(success) \(failed == 1 ? "file" : "files")",
                color: .green
            )
        } else {
            toastMessage = ToastMessagePayload(
                text: "📥 \(direction)loaded \(total) files: ✅ \(success) succeeded, ❌ \(failed) failed",
                color: success > 0 ? .yellow : .red
            )
        }
    }

    func getSearchPath() -> [String] {
        let searchLocation: String
        if pathStack.isEmpty || currentPath == "/" {
            // No extra path component, search at /api/search
            searchLocation = ""
            toastMessage = ToastMessagePayload(
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

        return pathComponents  // pass raw query string
    }

    func searchFiles(query: String) async {
        Log.debug("🔍 Searching for: \(query)")
        guard auth.isValid else { invalidAuth(); return }

        guard let preparedRequest = baseRequest.prepare(
            pathComponents: getSearchPath(),
            queryItems: [URLQueryItem(
                name: "query",
                value: parseSearchQuery(query: query, queryPrefix: searchType.queryPrefix, displayName: searchType.displayName)
            )],
            timeout: RequestTimeout(request: Constants.searchRequestTimeout, resource: Constants.searchResourceTimeout)
        ) else {
            let msg = "Failed to prepare request for: \(query)"
            Log.error("❌ \(msg)")
            errorTitle = "Internal Error"
            errorMessage = msg
            return
        }

        await MainActor.run {
            viewModel.isLoading = true
            errorMessage = nil
        }

        do {
            let (data, response) = try await preparedRequest.session.data(for: preparedRequest.request)

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
                    self.errorMessage = "Server error: \(formatHttpResponse(httpResponse))"
                }
                Log.error("❌ Server error: \(formatHttpResponse(httpResponse))")
                return
            }

            guard !Task.isCancelled else {
                Log.debug("⚠️ Search task was cancelled before decoding")
                return
            }

            do {
                let decoder = JSONDecoder()
                let lines = data.split(separator: UInt8(ascii: "\n"))

                let results = try lines.map { line in
                    try decoder.decode(FileItemSearch.self, from: Data(line))
                }

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
                    errorTitle = "Decode Error"
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

    @ViewBuilder
    func detailView(for file: FileItem, index: Int, sortedFiles: [FileItem]) -> some View {
        FileDetailView(
            currentIndex: index,
            files: sortedFiles,
            serverURL: auth.serverURL,
            token: auth.token,
            extensionTypes: extensionTypes,
            cacheExtensions: getCacheExtensions(
                advancedSettings: advancedSettings,
                extensionTypes: extensionTypes
            ),
            animateGIF: advancedSettings.animateGIF,
            baseRequest: baseRequest
        )
    }

    @ViewBuilder
    func thumbnailOrIcon(for file: FileItem, style: GridStyle? = nil) -> some View {
        let fileName = file.name.lowercased()
        let useThumbnail = advancedSettings.displayThumbnail &&
            extensionTypes.thumbnailExtensions.contains(where: fileName.hasSuffix)
        let iconSize = style?.iconSize ?? ViewStyle.listIconSize

        if useThumbnail {
            RemoteThumbnail(
                file: file,
                serverURL: auth.serverURL,
                token: auth.token,
                advancedSettings: advancedSettings,
                extensionTypes: extensionTypes,
                width: style?.gridHeight ?? ViewStyle.listIconSize,
                height: style?.gridHeight ?? ViewStyle.listIconSize,
                loadingFiles: $loadingFiles,
                iconSize: iconSize,
                baseRequest: baseRequest
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
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.9))
        }
    }

    @ViewBuilder
    func listView(for fileList: [FileItem]) -> some View {
        ForEach(fileList.indices, id: \.self) { index in
            let file = fileList[index]
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
                    NavigationLink(value: fullPath(for: file, with: currentPath)) {
                        HStack {
                            thumbnailOrIcon(for: file)
                                .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)
                            Text(file.name)
                        }
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        // Pre-update the display path for immediate UI response
                        currentDisplayPath = fullPath(for: file, with: currentPath)
                    })
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
                    NavigationLink(value: fullPath(for: file, with: currentPath)) {
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
                ForEach(fileList.indices, id: \.self) { index in
                    let file = fileList[index]
                    gridCell(for: file, at: index, in: fileList, module: module)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    func searchListView(for results: [FileItemSearch]) -> some View {
        let filteredResults = filterSearchResults(for: results, settings: auth.tokenPayload?.user)
        ForEach(filteredResults, id: \.path) { result in
            let name = URL(fileURLWithPath: result.path).lastPathComponent
            if result.dir {
                Button(action: {
                    navigateToSearchResult(path: result.path)
                }) {
                    HStack {
                        Image(systemName: "folder")
                            .frame(width: ViewStyle.listIconSize, height: ViewStyle.listIconSize)
                        Text(name)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(.plain)
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

    private func navigateToSearchResult(path: String) {
        searchClicked = false
        searchInProgress = false
        searchText = ""
        viewModel.searchResults.removeAll()
        if path == "/" {
            pathStack = []
        } else {
            var stack: [String] = []
            var currentPath = ""

            for component in path.split(separator: "/") {
                if currentPath.isEmpty {
                    currentPath = String(component)
                } else {
                    currentPath += "/\(component)"
                }
                stack.append(currentPath)
            }
            pathStack = stack
        }
        fetchFiles(at: path)
    }

    func fetchUsageInfo() {
        guard auth.isValid else { invalidAuth(); return }

        guard let preparedRequest = baseRequest.prepare(pathComponents: ["api", "usage"]) else {
            let msg = "Failed to prepare request for: /api/usage"
            Log.error("❌ \(msg)")
            errorTitle = "Internal Error"
            errorMessage = msg
            return
        }
        preparedRequest.session.dataTask(with: preparedRequest.request) { data, _, error in
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

    func initiateTusUpload(for fileURL: URL) {
        guard auth.isValid else { invalidAuth(); return }

        let fileName = fileURL.lastPathComponent
        guard let uploadURL = getUploadURL(serverURL: auth.serverURL, encodedName: fileName, currentPath: currentPath) else {
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
            Log.error("❌ Cannot open file: \(fileURL.lastPathComponent), error: \(error.localizedDescription)")
            uploadStatus[fileURL.lastPathComponent] = .failed
            transferState.currentTransferIndex += 1
            uploadNextInQueue()
            return
        }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        request.setValue(auth.token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ POST failed: \(error.localizedDescription)")
                    uploadStatus[fileURL.lastPathComponent] = .failed
                    fileHandle.closeFile()
                    // Continue to next file
                    transferState.currentTransferIndex += 1
                    uploadNextInQueue()
                    return
                }

                Log.debug("✅ Upload session initiated for: \(fileName)")
                getUploadOffset(fileHandle: fileHandle, fileURL: fileURL, uploadURL: uploadURL)
            }
        }.resume()
    }

    func getUploadOffset(fileHandle: FileHandle, fileURL: URL, uploadURL: URL) {
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "HEAD"
        request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
        request.setValue(auth.token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ HEAD failed: \(error.localizedDescription)")
                    uploadStatus[fileURL.lastPathComponent] = .failed
                    fileHandle.closeFile()
                    if isFileUpload {
                        fileURL.stopAccessingSecurityScopedResource()
                    }
                    // Continue to next file
                    transferState.currentTransferIndex += 1
                    uploadNextInQueue()
                    return
                }

                guard let http = response as? HTTPURLResponse,
                      let offsetStr = http.value(forHTTPHeaderField: "Upload-Offset"),
                      let offset = Int(offsetStr) else {
                    Log.error("❌ HEAD missing Upload-Offset")
                    uploadStatus[fileURL.lastPathComponent] = .failed
                    fileHandle.closeFile()
                    if isFileUpload {
                        fileURL.stopAccessingSecurityScopedResource()
                    }
                    // Continue to next file
                    transferState.currentTransferIndex += 1
                    uploadNextInQueue()
                    return
                }

                if offset != 0 {
                    Log.info("📍 Upload starting from offset: \(offset)")
                }
                uploadFileInChunks(
                    fileHandle: fileHandle,
                    fileURL: fileURL,
                    to: uploadURL,
                    startingAt: offset
                )
            }
        }.resume()
    }

    func cancelUpload(fileHandle: FileHandle?, statusText: String?) {
        Log.info("❌ Upload cancelled by user.")
        UIApplication.shared.isIdleTimerDisabled = false
        fileHandle?.closeFile()
        uploadTask?.cancel()
        clearUploadStatus()
        if isPhotoUpload {
            // MARK: Cancel task that streams files to be uploaded
            photoPickerStatus.cancellableTasks.forEach { $0.cancel() }
            clearPickerStatus()
        }
        fetchFiles(at: currentPath)
        if let text = statusText {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                toastMessage = ToastMessagePayload(text: text, color: .yellow, duration: 7)
            }
        }
        isPhotoUpload = false
        isFileUpload = false
    }

    func endUpload() {
        // MARK: Exit - Enable auto-lock and clean up staging area
        Log.info("✅ All uploads have been completed")
        UIApplication.shared.isIdleTimerDisabled = false
        clearPickerStatus()
        clearUploadStatus()
        fetchFiles(at: currentPath)
        isPhotoUpload = false
        isFileUpload = false
    }

    private var pendingUploads: Int {
        if isPhotoUpload {
            return photoPickerStatus.totalSelected - transferState.currentTransferIndex
        }
        return uploadQueue.count - transferState.currentTransferIndex
    }

    func pauseUpload(currentOffset: Int? = nil, message: String? = nil) {
        self.transferState.isTransferPaused = true
        self.uploadTask?.cancel()
        self.uploadTask = nil
        if let offset = currentOffset {
            self.currentUploadedOffset = offset
        }
        // Notify user
        if let text = message {
            self.toastMessage = ToastMessagePayload(
                text: text,
                color: .orange,
                duration: 3
            )
        } else {
            notifyTransferState(TransferType.upload, TransferStatus.paused)
        }
    }

    func resumeUpload() {
        Task {
            let serverHealth = await checkServerHealth(baseRequest: baseRequest)
            if serverHealth.success {
                if let fileHandle = currentFileHandle,
                   let uploadURL = currentUploadURL {
                    notifyTransferState(TransferType.upload, TransferStatus.resumed)
                    transferState.isTransferPaused = false
                    Log.info("▶️ Resuming upload for \(uploadURL.lastPathComponent)")
                    // This is the simplest & safest way to resume since TUS supports resumable uploads by design
                    getUploadOffset(
                        fileHandle: fileHandle,
                        fileURL: uploadQueue[transferState.currentTransferIndex],
                        uploadURL: uploadURL
                    )
                } else {
                    Log.error("Resume upload conditions not met")
                    errorTitle = "Resume Error"
                    errorMessage = "File handle or upload URL missing - unable to continue upload"
                }
            } else {
                Log.error("No network connection while trying to restart upload.")
                pauseUpload(message: "⚠️ No network connection while trying to restart upload.")
            }
        }
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
        transferState.currentTransferFile = fileName
        transferState.currentTransferFileSize = sizeConverter(fileSize)
        transferState.currentTransferFileIcon = systemIcon(for: fileName.lowercased(), extensionTypes: extensionTypes)
        var currentOffset = offset

        currentUploadURL = uploadURL
        currentFileHandle = fileHandle
        currentUploadedOffset = offset

        var uploadStartTime = Date()
        var startOffset = currentOffset

        func uploadNext() {
            // ⏸️ PAUSE Check
            if transferState.isTransferPaused {
                Log.info("⏸️ Upload paused at offset: \(currentOffset)")
                uploadTask = nil
                currentUploadedOffset = currentOffset
                return
            }

            // 🔁 Cancel check
            // MARK: Catches cancellation during mid-chunk
            if transferState.isTransferCancelled {
                Log.info("⏹️ Upload cancelled by user.")
                // Store statusText before cancelling
                var statusText = "⚠️ Upload cancelled"
                if pendingUploads != 0 {
                    statusText += ", pending files: \(pendingUploads)"
                }
                if isFileUpload {
                    do { fileURL.stopAccessingSecurityScopedResource() }
                }
                cancelUpload(fileHandle: fileHandle, statusText: statusText)
                return
            }

            // ✅ Finished?
            // MARK: Checks if there are more chunks to upload w.r.t file size
            guard currentOffset < fileSize else {
                fileHandle.closeFile()
                if isFileUpload {
                    do { fileURL.stopAccessingSecurityScopedResource() }
                }
                Log.info("✅ Upload complete: \(fileURL.lastPathComponent)")
                uploadStatus[fileURL.lastPathComponent] = .success
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Constants.uploadCleanupDelay)) {
                    FileCache.shared.removeTempFile(at: fileURL)
                }
                transferState.currentTransferIndex += 1
                uploadTask = nil
                transferState.transferProgress = 1.0
                transferState.currentTransferSpeed = 0.0
                currentUploadedOffset = 0
                uploadNextInQueue()
                return
            }

            // Read chunk
            fileHandle.seek(toFileOffset: UInt64(currentOffset))
            let data = fileHandle.readData(ofLength: chunkSize)

            uploadStartTime = Date()
            startOffset = currentOffset

            var request = URLRequest(url: uploadURL)
            request.httpMethod = "PATCH"
            request.setValue("1.0.0", forHTTPHeaderField: "Tus-Resumable")
            request.setValue("\(currentOffset)", forHTTPHeaderField: "Upload-Offset")
            request.setValue("application/offset+octet-stream", forHTTPHeaderField: "Content-Type")
            request.setValue(auth.token, forHTTPHeaderField: "X-Auth")

            uploadTask = URLSession.shared.uploadTask(with: request, from: data) { _, response, error in
                DispatchQueue.main.async {
                    // Handle network errors with auto-pause
                    if let error = error, error.isNetworkError {
                        Log.warn("⚠️ Network error detected: \(error.localizedDescription)")
                        // Auto-pause the upload
                        pauseUpload(
                            currentOffset: currentOffset,
                            message: "⏸️ Upload paused due to network error. Will resume when connection is restored."
                        )
                    }
                    // Re-check pause/cancel in async block
                    if transferState.isTransferCancelled {
                        Log.info("⏹️ Upload cancelled mid-chunk. \(fileName) may be incomplete.")
                        // Store statusText before cancelling
                        var statusText = "⚠️ Upload cancelled mid-chunk, '\(fileName)' may be incomplete."
                        if pendingUploads != 0 {
                            statusText += " Pending files: \(pendingUploads)"
                        }
                        cancelUpload(fileHandle: fileHandle, statusText: statusText)
                        return
                    }

                    if transferState.isTransferPaused {
                        Log.info("⏸️ Upload paused mid-chunk at offset: \(currentOffset)")
                        pauseUpload(currentOffset: currentOffset, message: "⏸️ Upload paused mid-chunk at offset: \(currentOffset)")
                        return
                    }

                    if let error = error {
                        Log.error("❌ PATCH failed: \(error.localizedDescription)")
                        uploadStatus[fileURL.lastPathComponent] = .failed
                        fileHandle.closeFile()
                        if isFileUpload {
                            fileURL.stopAccessingSecurityScopedResource()
                        }
                        // Continue to next file
                        transferState.currentTransferIndex += 1
                        uploadTask = nil
                        transferState.transferProgress = 0.0
                        currentUploadedOffset = 0
                        uploadNextInQueue()
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        Log.error("❌ Server error: Response was not HTTPURLResponse")
                        uploadStatus[fileURL.lastPathComponent] = .failed
                        fileHandle.closeFile()
                        if isFileUpload {
                            fileURL.stopAccessingSecurityScopedResource()
                        }
                        // Continue to next file
                        transferState.currentTransferIndex += 1
                        uploadTask = nil
                        transferState.transferProgress = 0.0
                        currentUploadedOffset = 0
                        uploadNextInQueue()
                        return
                    }

                    guard httpResponse.statusCode == 204 else {
                        Log.error("❌ Unexpected PATCH response: \(formatHttpResponse(httpResponse))")
                        uploadStatus[fileURL.lastPathComponent] = .failed
                        fileHandle.closeFile()
                        if isFileUpload {
                            fileURL.stopAccessingSecurityScopedResource()
                        }
                        // Continue to next file
                        transferState.currentTransferIndex += 1
                        uploadTask = nil
                        transferState.transferProgress = 0.0
                        currentUploadedOffset = 0
                        uploadNextInQueue()
                        return
                    }

                    let elapsed = Date().timeIntervalSince(uploadStartTime)
                    let bytesSent = currentOffset + data.count - startOffset
                    if elapsed > 0 {
                        transferState.currentTransferSpeed = Double(bytesSent) / elapsed / (1024 * 1024)
                    }

                    currentOffset += data.count
                    transferState.transferProgress = Double(currentOffset) / Double(fileSize)
                    transferState.transferProgressPct = Int((transferState.transferProgress * 100).rounded())
                    transferState.currentTransferedFileSize = sizeConverter(currentOffset)
                    currentUploadedOffset = currentOffset

                    Log.trace("📤 Uploaded chunk — new offset: \(currentOffset)")
                    uploadNext()
                }
            }
            uploadTask?.resume()
        }
        uploadNext()
    }

    func clearUploadStatus() {
        Log.debug("Resetting all upload attributes")
        uploadTask = nil
        transferState.transferType = nil
        uploadQueue = []
        transferState.currentTransferIndex = 0
        transferState.transferProgress = 0.0
    }

    func clearPickerStatus() {
        Log.debug("Resetting all photo picker attributes")
        photoPickerStatus.isPreparingUpload = false
        photoPickerStatus.totalSelected = 0
        photoPickerStatus.cancellableTasks.removeAll()
    }

    func uploadNextInQueue() {
        guard transferState.currentTransferIndex < uploadQueue.count else {
            transferState.transferType = nil
            if pendingUploads == 0 {
                // Show summary
                let status = uploadStatus
                guard !status.isEmpty else {
                    Log.error("Download status not registered")
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showTransferStatus(status, .upload)
                }
                uploadStatus = [:]
                endUpload()
            } else {
                Log.trace("Unprocessed files: \(pendingUploads)")
            }
            return
        }

        transferState.transferType = TransferType.upload
        transferState.isTransferCancelled = false
        transferState.transferProgress = 0.0
        let fileURL = uploadQueue[transferState.currentTransferIndex]
        if isFileUpload {
            guard fileURL.startAccessingSecurityScopedResource() else {
                Log.error("❌ Failed to access file: \(fileURL)")
                uploadStatus[fileURL.lastPathComponent] = .failed
                // Continue to next file
                transferState.currentTransferIndex += 1
                uploadNextInQueue()
                return
            }
        }
        initiateTusUpload(for: fileURL)
    }

    private func loadDefaultSettings() {
        hideDotfiles = auth.tokenPayload?.user.hideDotfiles ?? false
        dateFormatExact = auth.tokenPayload?.user.dateFormat ?? false
        redirectAfterCopyMove = auth.tokenPayload?.user.redirectAfterCopyMove ?? false
    }

    private func getCurrentSettings() {
        // Set defaults
        loadDefaultSettings()

        guard let currentSettings = auth.tokenPayload?.user else {
            Log.error("❌ Invalid user ID")
            errorTitle = "Internal Error"
            errorMessage = "Invalid user ID"
            return
        }

        guard let preparedRequest = baseRequest.prepare(
            pathComponents: ["api", "users", String(currentSettings.id)],
            method: RequestMethod.get
        ) else {
            let msg = "Failed to prepare request for: /api/users/\(currentSettings.id)"
            Log.error("❌ \(msg)")
            errorTitle = "Internal Error"
            errorMessage = msg
            return
        }

        let task = preparedRequest.session.dataTask(
            with: preparedRequest.request
        ) { data, _, error in

            if let error = error {
                Log.error("Failed to fetch settings: \(error)")
                self.errorTitle = "Network Error"
                self.errorMessage = error.localizedDescription
                return
            }

            guard let data = data else {
                Log.error("No data returned for settings")
                return
            }

            do {
                let settings = try JSONDecoder().decode(UserAccount.self, from: data)
                Log.debug("Settings: \(settings)")
                DispatchQueue.main.async {
                    auth.tokenPayload?.user = settings
                    self.hideDotfiles = settings.hideDotfiles
                    self.dateFormatExact = settings.dateFormat
                    self.redirectAfterCopyMove = settings.redirectAfterCopyMove
                }

            } catch {
                Log.error("JSON parsing error: \(error)")
            }
        }

        task.resume()
    }

    func saveSettings() {
        guard auth.isValid else { invalidAuth(); return }

        guard let currentSettings = auth.tokenPayload?.user else {
            Log.error("❌ Invalid user ID")
            errorTitle = "Internal Error"
            errorMessage = "Invalid user ID"
            return
        }
        Log.debug("⚙️ Current settings: \(currentSettings)")

        guard var preparedRequest = baseRequest.prepare(
            pathComponents: ["api", "users", String(currentSettings.id)],
            method: RequestMethod.put
        ) else {
            let msg = "Failed to prepare request for: /api/users/\(currentSettings.id)"
            Log.error("❌ \(msg)")
            errorTitle = "Internal Error"
            errorMessage = msg
            return
        }

        var updatedSettings = currentSettings
        updatedSettings.hideDotfiles = hideDotfiles
        updatedSettings.dateFormat = dateFormatExact
        updatedSettings.redirectAfterCopyMove = redirectAfterCopyMove

        // MARK: Set both current state, and auth state (since self is overriden with auth in init)
        auth.tokenPayload?.user = updatedSettings
        Log.debug("🔄 Updated settings: \(updatedSettings)")

        let dataDict = (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(updatedSettings))) ?? [:]

        let payload: [String: Any] = [
            "what": "user",
            "which": ["locale", "hideDotfiles", "singleClick", "redirectAfterCopyMove", "dateFormat", "aceEditorTheme"],
            "data": dataDict
        ]

        preparedRequest.request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        preparedRequest.session.dataTask(with: preparedRequest.request) { data, response, _ in
            DispatchQueue.main.async {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? "(no body)"
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    Log.info("✅ Settings saved")
                    auth.tokenPayload?.user.hideDotfiles = hideDotfiles
                    auth.tokenPayload?.user.dateFormat = dateFormatExact
                    auth.tokenPayload?.user.redirectAfterCopyMove = redirectAfterCopyMove
                    settingsMessage = ToastMessagePayload(text: "✅ Settings saved", color: .green)
                } else {
                    Log.error("❌ Settings save failed: \(body)")
                    errorTitle = "Settings save failed"
                    errorMessage = body
                    settingsMessage = ToastMessagePayload(text: "❌ Settings save failed", color: .red)
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
        guard auth.isValid else { invalidAuth(); return }

        let group = DispatchGroup()
        for item in selectedItems {
            guard let preparedRequest = baseRequest.prepare(
                pathComponents: ["api", "resources", item.path],
                method: RequestMethod.delete
            ) else {
                let msg = "Failed to prepare request for: /api/resources/\(item.path)"
                Log.error("❌ \(msg)")
                errorTitle = "Internal Error"
                errorMessage = msg
                return
            }

            group.enter()
            preparedRequest.session.dataTask(with: preparedRequest.request) { _, _, _ in
                group.leave()
            }.resume()
        }

        group.notify(queue: .main) {
            let count = selectedItems.count
            Log.info("✅ Deleted \(count) items")
            selectedItems.removeAll()
            selectionMode = false
            fetchFiles(at: currentPath)
            toastMessage = ToastMessagePayload(text: "🗑️ Deleted \(count) \(count == 1 ? "item" : "items")", color: .red, duration: 3)
        }
    }

    func renameSelectedItem() {
        guard let item = selectedItems.first else { return }
        let fromPath = item.path
        let toPath = URL(fileURLWithPath: item.path)
            .deletingLastPathComponent()
            .appendingPathComponent(renameInput)
            .path

        guard let preparedRequest = baseRequest.prepare(
            pathComponents: ["api", "resources", fromPath],
            queryItems: [
                URLQueryItem(name: "action", value: "rename"),
                URLQueryItem(name: "destination", value: toPath),
                URLQueryItem(name: "override", value: "false"),
                URLQueryItem(name: "rename", value: "false")
            ],
            method: RequestMethod.patch
        ) else {
            let msg = "Failed to prepare request for: \(item.name)"
            Log.error("❌ \(msg)")
            errorTitle = "Internal Error"
            errorMessage = msg
            return
        }
        preparedRequest.session.dataTask(with: preparedRequest.request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error("❌ Rename failed: \(error.localizedDescription)")
                    errorTitle = "Rename Failed"
                    errorMessage = error.localizedDescription
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Log.error("❌ No HTTP response received")
                    return
                }

                let responseText = formatHttpResponse(httpResponse)
                if httpResponse.statusCode == 200 {
                    let msg = "📝 Renamed \(item.name) → \(renameInput)"
                    Log.info("\(responseText) - \(msg)")
                    selectedItems.removeAll()
                    isRenaming = false
                    selectionMode = false
                    fetchFiles(at: currentPath)
                    toastMessage = ToastMessagePayload(text: msg, color: .yellow, duration: 3)
                    renameInput = ""
                    selectionMode = false
                } else {
                    let msg = "❌ Rename \(item.name) → \(renameInput) failed"
                    Log.error("\(responseText) - \(msg)")
                    errorTitle = "Rename Failed"
                    errorMessage = "\(responseText) - \(msg)"
                }
            }
        }.resume()
    }

    func toggleSelection(for item: FileItem) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }

    func createResource(isDirectory: Bool) {
        guard auth.isValid else { invalidAuth(); return }

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
        let fullPath = fullPath(for: fileItem, with: currentPath)

        guard let encodedPath = fullPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            Log.error("❌ Failed to encode path")
            viewModel.errorMessage = "Failed to encode path"
            return
        }

        // MARK: Condition based path seaparator for resource creation
        let separator = isDirectory ? "/?" : "?"
        let resourceType = isDirectory ? "Folder" : "File"
        let emoji = isDirectory ? "📁" : "📄"

        Log.info("📄 Creating \(resourceType) at path: \(fullPath)")
        guard let preparedRequest = baseRequest.prepare(
            pathComponents: ["/api/resources\(encodedPath)\(separator)override=false"],
            method: RequestMethod.post
        ) else {
            let msg = "Failed to prepare request for: /api/resources/\(fullPath)"
            Log.error("❌ \(msg)")
            errorTitle = "Internal Error"
            errorMessage = msg
            return
        }
        preparedRequest.session.dataTask(with: preparedRequest.request) { _, response, error in
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
                    fetchFiles(at: currentPath)
                    toastMessage = ToastMessagePayload(text: "\(emoji) \(newResourceName) created", color: .green)
                    newResourceName = ""
                } else {
                    Log.error("❌ \(resourceType) creation failed with status code: \(http.statusCode)")
                    errorTitle = "Create Failed"
                    errorMessage = "\(resourceType) creation failed: \(http.statusCode)"
                }
            }
        }.resume()
    }

    func refreshFolder() {
        Log.debug("ℹ️ Refresh Directory")
        fetchFiles(at: currentPath)
    }
}
