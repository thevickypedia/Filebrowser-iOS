//
//  ContentView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var knownServers: [String] = []
    @State private var showAddServerAlert = false
    @State private var newServerURL = ""
    @State private var serverURL = ""
    @State private var username = ""
    @State private var password = ""
    @State private var oneTimePasscode = ""
    @State private var oneTimePasscodeSecret = ""
    @AppStorage("rememberMe") private var rememberMe = false
    @AppStorage("transitProtection") private var transitProtection = false
    @AppStorage("useFaceID") private var useFaceID: Bool = false
    @State private var storeOtpSecret: Bool = false

    @State private var pathStack: [String] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var token: String?
    @EnvironmentObject var auth: AuthManager
    @State private var isLoggedIn = false
    @State private var showLogoutMessage = false
    @State private var toastMessage: ToastMessagePayload?
    @EnvironmentObject var themeManager: ThemeManager

    @StateObject private var fileListViewModel = FileListViewModel()

    @State private var showAdvancedOptions = false

    @AppStorage("cacheImage") private var cacheImage = true
    @AppStorage("cachePDF") private var cachePDF = true
    @AppStorage("cacheText") private var cacheText = true
    @AppStorage("cacheThumbnail") private var cacheThumbnail = true
    @AppStorage("displayThumbnail") private var displayThumbnail = true
    @AppStorage("animateGIF") private var animateGIF = true
    @AppStorage("chunkSize") private var chunkSize = 1
    @AppStorage("logLevel") private var logLevel = LogLevel.info
    @AppStorage("logOption") private var logOption = LogOptions.both
    @AppStorage("verboseLogging") private var verboseLogging = false
    @State private var chunkSizeText: String = "1"

    @State private var backgroundLogin: BackgroundLogin?

    private var baseRequest: Request {
        // auth might not be instantiated yet, consider user input as fallback
        let requestURL = auth.serverURL.isEmpty ? serverURL : auth.serverURL
        if auth.token.isEmpty {
            Log.warn("Authentication token not found; the request may only be used for initial login.")
        }
        return Request(baseURL: requestURL, token: auth.token)
    }

    private func initialize() -> BackgroundLogin {
        Log.info("⏳ Initializing background login struct")
        return BackgroundLogin(auth: auth, baseRequest: baseRequest)
    }

    private func fileListView(advancedSettings: AdvancedSettings,
                              extensionTypes: ExtensionTypes,
                              cacheExtensions: [String]) -> some View {
        FileListView(
            isLoggedIn: $isLoggedIn,
            pathStack: $pathStack,
            logoutHandler: handleLogout,
            extensionTypes: extensionTypes,
            advancedSettings: advancedSettings,
            cacheExtensions: cacheExtensions,
            backgroundLogin: backgroundLogin ?? initialize(),  // Re-initialize if nil
            baseRequest: baseRequest
        )
        .environmentObject(fileListViewModel)
    }

    var body: some View {
        let extensionTypes = ExtensionTypes()
        let advancedSettings = AdvancedSettings(
            cacheImage: cacheImage,
            cachePDF: cachePDF,
            cacheText: cacheText,
            displayThumbnail: displayThumbnail,
            cacheThumbnail: cacheThumbnail,
            animateGIF: animateGIF,
            chunkSize: chunkSize,
            logOption: logOption,
            logLevel: logLevel,
            verboseLogging: verboseLogging
        )
        let cacheExtensions = getCacheExtensions(advancedSettings: advancedSettings, extensionTypes: extensionTypes)
        NavigationStack(path: $pathStack) {
            Group {
                if isLoggedIn {
                    fileListView(advancedSettings: advancedSettings,
                                 extensionTypes: extensionTypes,
                                 cacheExtensions: cacheExtensions)
                } else {
                    loginView
                }
            }
            .navigationDestination(for: String.self) { _ in
                fileListView(advancedSettings: advancedSettings,
                             extensionTypes: extensionTypes,
                             cacheExtensions: cacheExtensions)
            }
        }
        .modifier(ToastMessage(payload: $toastMessage))
    }

    private struct LoggingSettings: Equatable {
        var option: LogOptions
        var level: LogLevel
        var verbose: Bool
    }

    private func applyLogSettings(_ settings: LoggingSettings? = nil) {
        let logSettings: LoggingSettings
        if let customSettings = settings {
            logSettings = customSettings
            Log.debug("🗒️ Configuring logger with custom setup: \(logSettings)")
        } else {
            logSettings = LoggingSettings(option: logOption, level: logLevel, verbose: verboseLogging)
            Log.debug("🗒️ Configuring logger with app storage: \(logSettings)")
        }
        Log.initialize(
            logOption: logSettings.option,
            logLevel: logSettings.level,
            verboseMode: logSettings.verbose
        )
    }

    var loginView: some View {
        VStack(spacing: 20) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 10)

            Text("Filebrowser")
                .font(.largeTitle)
                .bold()
                .padding(.top, 1)

            ServerURLMenu(
                serverURL: $serverURL,
                showAddServerAlert: $showAddServerAlert,
                knownServers: knownServers,
                newServerURL: $newServerURL,
                addNewServer: addNewServer
            ).padding(.top, 1)

            let loadedSession = KeychainHelper.loadSession()
            /// 1. FaceID should be enabled
            /// 2. A stored session could be loaded
            /// 3. Stored session's "serverURL" matches the one chosen by the user
            /// 4. Password was stored in existing session - indicates FaceID was chosen previously
            if useFaceID,
               let existingSession = loadedSession,
               existingSession.serverURL == serverURL,
               existingSession.password != nil {
                // Face ID mode with saved session
                Toggle("Login with Face ID", isOn: $useFaceID)
                    .padding(.top, 8)
                Button(action: {
                    biometricSignIn(session: existingSession)
                }) {
                    let username = existingSession.username
                    let labelText = (username.isEmpty == false) ? "Login as \(username)" : "Login with FaceID"
                    Label(labelText, systemImage: "faceid")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.headline)
                }
                .padding(.top, 6)
                Spacer().frame(height: 8)
                Button(action: {
                    KeychainHelper.deleteSession()
                    useFaceID = false
                }) {
                    Label("Switch User", systemImage: "person.crop.circle.badge.checkmark")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                        .font(.headline)
                }
                .padding(.top, 4)
            } else {
                // Normal credential-based login
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if storeOtpSecret {
                    SecureField("OTP Secret", text: $oneTimePasscodeSecret)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    TextField("One-time Passcode", text: $oneTimePasscode)
                        .keyboardType(.numberPad) // shows numeric keypad
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: oneTimePasscode) { newValue in
                            // Allow only digits, limit to 6
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered.count > 6 {
                                oneTimePasscode = String(filtered.prefix(6))
                            } else {
                                oneTimePasscode = filtered
                            }
                        }
                }

                // Show toggle button only when there is no stored session or the stored otpSecret is empty
                if loadedSession == nil || loadedSession?.otpSecret == "" {
                    Toggle("Store OTP Secret", isOn: $storeOtpSecret)
                        .padding(.top, 8)
                }

                // Conditionally display "Remember Me" Toggle only when Face ID is not being used
                if !useFaceID {
                    Toggle("Remember Me", isOn: $rememberMe)
                }

                Toggle("Use Face ID", isOn: $useFaceID)
                Toggle("Transit Protection", isOn: $transitProtection)

                Button(action: {
                    Task {
                        await login()
                    }
                }) {
                    if isLoading { ProgressView() } else {
                        // key.fill || person.badge.key.fill
                        Label("Login", systemImage: "person.badge.key.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .font(.headline)
                    }
                }
                .disabled(isLoading)
            }

            var currentLoggingSettings: LoggingSettings {
                LoggingSettings(option: logOption, level: logLevel, verbose: verboseLogging)
            }

            Section {
                AdvancedSettingsView(
                    cacheImage: $cacheImage,
                    cachePDF: $cachePDF,
                    cacheText: $cacheText,
                    displayThumbnail: $displayThumbnail,
                    cacheThumbnail: $cacheThumbnail,
                    animateGIF: $animateGIF,
                    chunkSize: $chunkSize,
                    logOption: $logOption,
                    logLevel: $logLevel,
                    verboseLogging: $verboseLogging
                )
                .onAppear {
                    chunkSizeText = String(chunkSize)
                    applyLogSettings()
                }
                .onChange(of: currentLoggingSettings) { logSettings in
                    applyLogSettings(logSettings)
                }
            }

            Spacer()

            // 🌗 Theme toggle
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
            .padding(.bottom, 20)

            // Footer
            VStack(spacing: 2) {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                   let url = URL(string: "https://github.com/thevickypedia/Filebrowser-iOS/releases/tag/v\(version)") {
                    Link("Version: \(version)", destination: url)
                        .font(.footnote)
                        .foregroundColor(.blue)
                } else {
                    Link("Version: unknown", destination: URL(string: "https://github.com/thevickypedia/Filebrowser-iOS/releases")!)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Link("© 2025 Vignesh Rao", destination: URL(string: "https://vigneshrao.com")!)
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 8)
        }
        .padding()
        .onAppear {
            knownServers = KeychainHelper.loadKnownServers()
            if !knownServers.isEmpty {
                serverURL = knownServers.last ?? ""
            }
            if backgroundLogin == nil {
                backgroundLogin = initialize()
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil), presenting: errorMessage) { _ in
            Button("OK", role: .cancel) {
                errorMessage = nil
            }
        } message: { error in
            Text(error)
        }
    }

    func addNewServer() {
        // This should not happen since the button will not be visible (but just in case)
        if knownServers.count == Constants.maxKnownServers {
            errorMessage = "Server limit reached (\(Constants.maxKnownServers)). Delete one to add a new server."
            return
        }
        let trimmed = newServerURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.hasPrefix("http") else {
            if !trimmed.isEmpty { errorMessage = "Invalid URL: \(trimmed)" }
            return
        }

        if !knownServers.contains(trimmed) {
            knownServers.insert(trimmed, at: 0)
            KeychainHelper.saveKnownServers(knownServers)
        }

        serverURL = trimmed
        newServerURL = ""
        // Reset all auth state for better security
        username = ""
        password = ""
        useFaceID = false
        rememberMe = false
    }

    func terminator(endpoint: String, success: String, failure: String) async -> Bool {
        if let preparedRequest = baseRequest.prepare(
            pathComponents: ["api", endpoint],
            method: RequestMethod.post
        ) {
            do {
                let (_, response) = try await preparedRequest.session.data(for: preparedRequest.request)
                if let httpResponse = response as? HTTPURLResponse {
                    let responseText = formatHttpResponse(httpResponse)
                    if httpResponse.statusCode == 200 {
                        Log.info("\(success): \(responseText)")
                        return true
                    } else {
                        Log.error("\(failure): \(responseText)")
                    }
                } else {
                    Log.error("\(failure): No HTTPURLResponse received")
                }
            } catch {
                Log.error("\(failure): \(error.localizedDescription)")
            }
        }
        return false
    }

    func clearServerJWT() async {
        let terminated = await terminator(
            endpoint: "logout",
            success: "Server side JWT invalidation successful",
            failure: "Server side JWT invalidation failed"
        )
        if terminated {
            DispatchQueue.main.async {
                toastMessage = ToastMessagePayload(text: "⚠️ Logout successful!", color: .yellow, duration: 3.5)
            }
        } else {
            DispatchQueue.main.async {
                toastMessage = ToastMessagePayload(
                    text: "⚠️ Logout successful, but server side token invalidation failed",
                    color: .yellow, duration: 3.5
                )
            }
        }
    }

    func handleLogout(_ clearActiveServers: Bool = false) {
        pathStack.removeAll()

        isLoggedIn = false
        if !rememberMe {
            username = ""
        }
        password = ""
        backgroundLogin?.backgroundLogout()

        // If neither remember nor useFaceID is enabled, remove any saved session
        if !(rememberMe || useFaceID) {
            KeychainHelper.deleteSession()
            KeychainHelper.deleteKnownServers()
        } else {
            KeychainHelper.logout()
        }

        // Clears current serverURL and knownServers immediately
        if clearActiveServers {
            knownServers.removeAll()
            serverURL = ""
            Task {
                _ = await terminator(
                    endpoint: "terminate",
                    success: "Terminated all JWTs on server",
                    failure: "Failed to terminate all JWTs on server"
                )
            }
        } else {
            Task { await clearServerJWT() }
        }
    }

    private func loginFailed(_ msg: String) {
        isLoading = false
        let msgF = "Login failed: \(msg)"
        Log.error(msgF)
        errorMessage = msgF
    }

    private func processHealthCheck() async -> Bool {
        toastMessage = ToastMessagePayload(text: "⏳ Checking server health", color: .primary)
        let healthCheck = await checkServerHealth(baseRequest: baseRequest)
        if !healthCheck.success {
            errorMessage = "Health check failed - \(healthCheck.text)"
        }
        return healthCheck.success
    }

    func login() async {
        if serverURL.isEmpty || username.isEmpty || password.isEmpty {
            errorMessage = "Credentials are required to login!"
            return
        }
        isLoading = true
        errorMessage = nil
        token = nil

        if serverURL.hasSuffix("/") {
            serverURL.removeLast()
        }
        if await !processHealthCheck() {
            return
        }

        guard var preparedRequest = baseRequest.prepare(pathComponents: ["api", "login"], method: RequestMethod.post) else {
            let msg = "Failed to prepare request for: /api/login"
            Log.error("❌ \(msg)")
            errorMessage = msg
            return
        }

        if transitProtection {
            if oneTimePasscodeSecret != "" {
                if let code = generateTOTP(secret: oneTimePasscodeSecret, time: Date()) {
                    Log.info("Generated TOTP")
                    self.oneTimePasscode = code
                } else {
                    Log.error("Failed to generated TOTP")
                }
            } else if oneTimePasscode == "" {
                Log.warn("Neither oneTimePasscode nor oneTimePasscodeSecret are available!")
            }
            let hexUsername = convertStringToHex(username)
            let hexPassword = convertStringToHex(password)
            let hexRecaptcha = convertStringToHex("")
            let hexOneTimePasscode = convertStringToHex(oneTimePasscode)
            let combined = "\\u" + hexUsername + "," + "\\u" + hexPassword + "," + "\\u" + hexRecaptcha + "," + "\\u" + hexOneTimePasscode
            guard let payload = combined.data(using: .utf8)?.base64EncodedString() else {
                loginFailed("Failed to encode credentials")
                return
            }
            preparedRequest.request.setValue(payload, forHTTPHeaderField: "Authorization")
            preparedRequest.request.httpBody = nil
        } else {
            let credentials = [
                "username": username,
                "password": password
            ]
            do {
                preparedRequest.request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: [])
            } catch {
                loginFailed("Failed to encode credentials")
                return
            }
        }

        do {
            let (data, response) = try await preparedRequest.session.data(for: preparedRequest.request)
            isLoading = false
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                return
            }

            if httpResponse.statusCode == 200 {
                if let jwt = String(data: data, encoding: .utf8) {
                    if let payload = decodeJWT(jwt: jwt) {
                        token = jwt
                        // MARK: Set auth params
                        auth.token = jwt
                        auth.username = username
                        auth.serverURL = serverURL
                        auth.tokenPayload = payload
                        // Extras
                        auth.password = password
                        auth.oneTimePasscodeSecret = oneTimePasscodeSecret
                        auth.transitProtection = transitProtection

                        fileListViewModel.configure(token: jwt, serverURL: serverURL)
                        isLoggedIn = true
                        // Show success message
                        toastMessage = ToastMessagePayload(text: "✅ Login successful!", color: .green)
                        updateLastUsedServer()
                        DispatchQueue.main.async {
                            backgroundLogin?.logTokenInfo()
                            backgroundLogin?.startReauthTimer(at: payload.exp)
                        }
                        if rememberMe || useFaceID {
                            KeychainHelper.saveSession(
                                session: StoredSession(
                                    token: jwt,
                                    username: username,
                                    serverURL: serverURL,
                                    transitProtection: transitProtection,
                                    // MARK: Store password only when FaceID is enabled
                                    password: useFaceID ? password : nil,
                                    otpSecret: oneTimePasscodeSecret
                                )
                            )
                        } else {
                            // ensure any existing saved session is removed when the user opts out
                            KeychainHelper.deleteSession()
                            KeychainHelper.deleteKnownServers()
                        }
                    } else {
                        loginFailed("Failed to decode token")
                    }
                } else {
                    loginFailed("Failed to extract JWT")
                }
            } else {
                loginFailed("\(httpResponse.statusCode)")
            }
        } catch {
            loginFailed(error.localizedDescription)
        }
    }

    func updateLastUsedServer() {
        var knownServersCopy = KeychainHelper.loadKnownServers()
        // Skip if current serverURL is already in the last index of knownServer list
        if knownServersCopy.last == serverURL { return }
        Log.debug("Updating last logged in server")
        Log.debug("Before update: \(knownServersCopy)")
        if let index = knownServersCopy.firstIndex(of: serverURL) {
            let item = knownServersCopy.remove(at: index)
            knownServersCopy.append(item)
        }
        Log.debug("After update: \(knownServersCopy)")
        KeychainHelper.saveKnownServers(knownServersCopy)
    }

    func reauth(_ session: StoredSession) {
        if let sessionPassword = session.password,
           session.serverURL == self.serverURL {
            DispatchQueue.main.async {
                self.username = session.username
                self.password = sessionPassword
                self.oneTimePasscodeSecret = session.otpSecret
                self.transitProtection = session.transitProtection
                // Reuse the normal login flow
                Task {
                    await login()
                }
            }
        } else {
            DispatchQueue.main.async {
                useFaceID = false // fallback to manual login
            }
        }
    }

    func biometricSignIn(session: StoredSession) {
        var doHealthCheck = true
        // Force remembering username whenever FaceID is toggled
        rememberMe = false
        KeychainHelper.authenticateWithBiometrics { success in
            Task {
                guard success,
                      session.serverURL == self.serverURL
                else {
                    DispatchQueue.main.async {
                        useFaceID = false // fallback to manual login
                    }
                    doHealthCheck = false
                    return
                }

                // Decode JWT to check expiration
                guard let token = session.token,
                      let tokenPayload = decodeJWT(jwt: token) else {
                    doHealthCheck = false
                    Log.warn("⚠️ JWT not found in session, or unable to decode")
                    DispatchQueue.main.async {
                        reauth(session)
                    }
                    return
                }
                let now = Date().timeIntervalSince1970
                if now >= tokenPayload.exp {
                    doHealthCheck = false
                    Log.info("🔑 Token expired — refreshing via stored credentials.")
                    DispatchQueue.main.async {
                        reauth(session)
                    }
                    return
                }

                // Token still valid — just use it
                // MARK: Set auth params
                auth.token = token
                auth.username = session.username
                auth.serverURL = session.serverURL
                auth.tokenPayload = tokenPayload
                // Extras
                auth.password = session.password ?? password
                auth.oneTimePasscodeSecret = session.otpSecret
                auth.transitProtection = session.transitProtection

                let handShake = await auth.serverHandShake(for: String(tokenPayload.user.id))
                if handShake.success {
                    Log.debug(handShake.text)
                } else {
                    doHealthCheck = false
                    DispatchQueue.main.async {
                        if handShake.statusCode == 401 {
                            // This indicates a server restart
                            Log.warn("FaceID passed, but session validation failed.")
                            reauth(session)
                        } else {
                            Log.error(handShake.text)
                            errorMessage = handShake.text
                        }
                    }
                    return
                }
                if doHealthCheck {
                    if await !processHealthCheck() {
                        return
                    }
                }
                fileListViewModel.configure(token: token, serverURL: session.serverURL)
                Log.info("✅ Face ID login successful")
                updateLastUsedServer()
                DispatchQueue.main.async {
                    isLoggedIn = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    toastMessage = ToastMessagePayload(text: "✅ Face ID login successful!", color: .green)
                    backgroundLogin?.logTokenInfo()
                    backgroundLogin?.startReauthTimer(at: tokenPayload.exp)
                }
            }
        }
    }
}
