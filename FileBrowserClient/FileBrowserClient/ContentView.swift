//
//  ContentView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI

struct AdvancedSettings {
    // Controlled with file extensions
    let cacheImage: Bool
    let cachePDF: Bool
    let cacheText: Bool
    // Controlled with individual condition blocks
    let displayThumbnail: Bool
    let cacheThumbnail: Bool
    let animateGIF: Bool
    let chunkSize: Int
}

struct ContentView: View {
    @State private var knownServers: [String] = []
    @State private var showAddServerAlert = false
    @State private var newServerURL = ""
    @AppStorage("serverURL") private var serverURL = ""
    @State private var username = ""
    @State private var password = ""
    @AppStorage("rememberMe") private var rememberMe = false
    @AppStorage("transitProtection") private var transitProtection = false
    @AppStorage("useFaceID") private var useFaceID: Bool = false

    @State private var pathStack: [String] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var token: String?
    @EnvironmentObject var auth: AuthManager
    @State private var isLoggedIn = false
    @State private var showLogoutMessage = false
    @State private var statusMessage: String?
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
    @State private var chunkSizeText: String = "1"

    var body: some View {
        let extensionTypes = ExtensionTypes()
        let advancedSettings = AdvancedSettings(
            cacheImage: cacheImage,
            cachePDF: cachePDF,
            cacheText: cacheText,
            displayThumbnail: displayThumbnail,
            cacheThumbnail: cacheThumbnail,
            animateGIF: animateGIF,
            chunkSize: chunkSize
        )
        let cacheExtensions = getCacheExtensions(advancedSettings: advancedSettings, extensionTypes: extensionTypes)
        NavigationStack(path: $pathStack) {
            Group {
                if isLoggedIn {
                    FileListView(
                        isLoggedIn: $isLoggedIn,
                        pathStack: $pathStack,
                        logoutHandler: handleLogout,
                        extensionTypes: extensionTypes,
                        advancedSettings: advancedSettings,
                        cacheExtensions: cacheExtensions
                    )
                    .environmentObject(fileListViewModel)
                } else {
                    loginView
                }
            }
            .navigationDestination(for: String.self) { newPath in
                FileListView(
                    isLoggedIn: $isLoggedIn,
                    pathStack: $pathStack,
                    logoutHandler: handleLogout,
                    extensionTypes: extensionTypes,
                    advancedSettings: advancedSettings,
                    cacheExtensions: cacheExtensions
                )
                .environmentObject(fileListViewModel)
            }
        }
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

            Picker("Server URL", selection: $serverURL) {
                ForEach(knownServers, id: \.self) { url in
                    Text(url).tag(url)
                }
                Text("➕ Add new server").tag("add-new-server")
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: serverURL) { newValue in
                if newValue == "add-new-server" {
                    showAddServerAlert = true
                    serverURL = knownServers.first ?? ""
                }
            }

            let hasSavedSession = KeychainHelper.loadSession() != nil

            if !(useFaceID && hasSavedSession) {
                // Normal credential-based login
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Toggle("Remember Me", isOn: $rememberMe)
                Toggle("Use Face ID", isOn: $useFaceID)

                Button(action: { login() }) {
                    if isLoading { ProgressView() } else {
                        Text("Login").bold().frame(maxWidth: .infinity)
                            .padding().background(Color.blue).foregroundColor(.white).cornerRadius(8)
                    }
                }
                .disabled(isLoading)
            } else {
                // Face ID mode with saved session
                Toggle("Use Face ID", isOn: $useFaceID)
                    .padding(.top, 8)
                Button(action: {
                    biometricSignIn()
                }) {
                    Label("Login with Face ID", systemImage: "faceid")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.headline)
                }
                .padding(.top, 6)
            }
            Toggle("Transit Protection", isOn: $transitProtection)

            Section {
                DisclosureGroup("Advanced Settings", isExpanded: $showAdvancedOptions) {
                    HStack {
                        Text("Chunk Size (MB)")
                        Spacer()
                        Picker(selection: $chunkSize, label: Text("\(chunkSize)")) {
                            ForEach([1, 2, 5, 10, 20], id: \.self) { size in
                                Text("\(size)").tag(size)
                            }
                        }
                        // WheelPickerStyle takes too much space
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 80)
                    }
                    Toggle("Cache Images", isOn: $cacheImage)
                    Toggle("Cache PDFs", isOn: $cachePDF)
                    Toggle("Cache Text Files", isOn: $cacheText)
                    Toggle("Display Thumbnails", isOn: $displayThumbnail)
                    Toggle("Cache Thumbnails", isOn: $cacheThumbnail)
                    Toggle("Animate GIF Files", isOn: $animateGIF)
                }
                .onAppear {
                    chunkSizeText = String(chunkSize)
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            if let statusMessage = statusMessage {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(statusMessage.contains("Logout") ? .orange : .green)
                    .padding()
                    .transition(.opacity)
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
            if !knownServers.contains(serverURL), let first = knownServers.first {
                serverURL = first
            }
        }
        .alert("Add New Server", isPresented: $showAddServerAlert, actions: {
            TextField("Server URL", text: $newServerURL)
            Button("Add", action: addNewServer)
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Enter the full server URL.")
        })
    }

    func addNewServer() {
        let trimmed = newServerURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.hasPrefix("http") else { return }

        if !knownServers.contains(trimmed) {
            knownServers.insert(trimmed, at: 0)
            KeychainHelper.saveKnownServers(knownServers)
        }

        serverURL = trimmed
        newServerURL = ""
    }

    func handleLogout() {
        pathStack.removeAll()

        isLoggedIn = false
        if !rememberMe {
            username = ""
            password = ""
        }

        statusMessage = "⚠️ Logout successful!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            statusMessage = nil
        }
        // If neither remember nor useFaceID is enabled, remove any saved session
        if !rememberMe && !useFaceID {
            KeychainHelper.deleteSession()
            KeychainHelper.deleteKnownServers()
        }
    }

    func convertStringToHex(_ str: String) -> String {
        return str.unicodeScalars.map {
            let hex = String($0.value, radix: 16)
            return String(repeating: "0", count: 4 - hex.count) + hex
        }.joined(separator: "\\u")
    }

    func login() {
        isLoading = true
        errorMessage = nil
        token = nil

        if serverURL.hasSuffix("/") {
            serverURL.removeLast()
        }
        guard let url = URL(string: "\(serverURL)/api/login") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if transitProtection {
            let hexUsername = convertStringToHex(username)
            let hexPassword = convertStringToHex(password)
            let hexRecaptcha = convertStringToHex("") // assuming no recaptcha for iOS

            let combined = "\\u" + hexUsername + "," + "\\u" + hexPassword + "," + "\\u" + hexRecaptcha

            guard let payload = combined.data(using: .utf8)?.base64EncodedString() else {
                errorMessage = "Encoding failed"
                isLoading = false
                return
            }

            request.setValue(payload, forHTTPHeaderField: "Authorization")
            request.httpBody = nil // no body needed
        } else {
            let credentials = [
                "username": username,
                "password": password
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: [])
            } catch {
                errorMessage = "Failed to encode credentials"
                isLoading = false
                return
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      let data = data else {
                    errorMessage = "No response or data"
                    return
                }

                if httpResponse.statusCode == 200 {
                    if let jwt = String(data: data, encoding: .utf8) {
                        if let payload = decodeJWT(jwt: jwt) {
                            auth.iss = payload["iss"] as? String
                            auth.exp = payload["exp"] as? TimeInterval
                            auth.iat = payload["iat"] as? TimeInterval
                        } else {
                            Log.error("Failed to decode JWT")
                        }
                        token = jwt
                        auth.token = jwt
                        auth.serverURL = serverURL
                        auth.permissions = nil // clear any stale value
                        auth.username = username // ✅ Store username
                        // ✅ Wrap async calls in a Task
                        Task {
                            await auth.fetchUserAccount(for: username, token: jwt, serverURL: serverURL)
                            await auth.fetchPermissions(for: username, token: jwt, serverURL: serverURL)
                        }
                        fileListViewModel.configure(token: jwt, serverURL: serverURL)
                        isLoggedIn = true

                        // ✅ Show success message
                        statusMessage = "✅ Login successful!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            statusMessage = nil
                        }
                        if rememberMe || useFaceID {
                            KeychainHelper.saveSession(
                                token: jwt,
                                username: username,
                                serverURL: serverURL,
                                password: useFaceID ? password : nil
                            )
                        } else {
                            // ensure any existing saved session is removed when the user opts out
                            KeychainHelper.deleteSession()
                            KeychainHelper.deleteKnownServers()
                        }
                    } else {
                        errorMessage = "Failed to decode token"
                    }
                } else {
                    errorMessage = "Login failed: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }

    func logTokenInfo() {
        Log.info("Issuer: \(auth.iss ?? "Unknown")")
        Log.info("Issued: \(timeStampToString(from: auth.iat))")
        Log.info("Expiration: \(timeStampToString(from: auth.exp))")
        Log.info("Time Left: \(timeLeftString(until: auth.exp))")
    }

    func biometricSignIn() {
        KeychainHelper.authenticateWithBiometrics { success in
            guard success,
                  let session = KeychainHelper.loadSession(),
                  let token = session["token"],
                  let username = session["username"],
                  let serverURL = session["serverURL"] else {
                DispatchQueue.main.async {
                    useFaceID = false // fallback to manual login
                }
                return
            }

            // Decode JWT to check expiration
            if let payload = decodeJWT(jwt: token),
               let exp = payload["exp"] as? TimeInterval {
                let now = Date().timeIntervalSince1970
                if now >= exp {
                    Log.info("🔑 Token expired — refreshing via stored credentials.")
                    // If we stored password securely:
                    if let password = session["password"] {
                        DispatchQueue.main.async {
                            self.serverURL = serverURL
                            self.username = username
                            self.password = password
                            self.login() // reuse normal login flow
                        }
                    } else {
                        // No password stored — fallback to showing login UI
                        DispatchQueue.main.async {
                            useFaceID = false
                        }
                    }
                    return
                }
            }

            // Token still valid — just use it
            DispatchQueue.main.async {
                auth.token = token
                auth.serverURL = serverURL
                auth.username = username
                auth.permissions = nil
                if let payload = decodeJWT(jwt: token) {
                    auth.iss = payload["iss"] as? String
                    auth.exp = payload["exp"] as? TimeInterval
                    auth.iat = payload["iat"] as? TimeInterval
                    logTokenInfo()
                } else {
                    Log.error("Failed to decode JWT")
                }
                Task {
                    await auth.fetchUserAccount(for: username, token: token, serverURL: serverURL)
                    await auth.fetchPermissions(for: username, token: token, serverURL: serverURL)
                }
                fileListViewModel.configure(token: token, serverURL: serverURL)
                isLoggedIn = true
                statusMessage = "✅ Face ID login successful!"
                Log.info("✅ Face ID login successful")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { statusMessage = nil }
            }
        }
    }
}

struct Folder: Hashable {
    let name: String
}
