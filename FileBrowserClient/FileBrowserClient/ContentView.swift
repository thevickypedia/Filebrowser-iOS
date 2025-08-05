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
    let cacheThumbnail: Bool
    let animateGIF: Bool
}

struct ContentView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("username") private var username = ""
    @AppStorage("password") private var password = ""
    @AppStorage("rememberMe") private var rememberMe = false
    @AppStorage("transitProtection") private var transitProtection = false

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
    // Default to false since GIF animation in SwiftUI can be resource-intensive
    @AppStorage("animateGIF") private var animateGIF = false

    var body: some View {
        NavigationStack(path: $pathStack) {
            Group {
                if isLoggedIn {
                    FileListView(
                        path: pathStack.last ?? "/",
                        isLoggedIn: $isLoggedIn,
                        pathStack: $pathStack,
                        logoutHandler: handleLogout,
                        extensionTypes: ExtensionTypes(),
                        advancedSettings: AdvancedSettings(
                            cacheImage: cacheImage,
                            cachePDF: cachePDF,
                            cacheText: cacheText,
                            cacheThumbnail: cacheThumbnail,
                            animateGIF: animateGIF
                        )
                    )
                    .environmentObject(fileListViewModel)
                } else {
                    loginView
                }
            }
            .navigationDestination(for: String.self) { newPath in
                FileListView(
                    path: newPath,
                    isLoggedIn: $isLoggedIn,
                    pathStack: $pathStack,
                    logoutHandler: handleLogout,
                    extensionTypes: ExtensionTypes(),
                    advancedSettings: AdvancedSettings(
                        cacheImage: cacheImage,
                        cachePDF: cachePDF,
                        cacheText: cacheText,
                        cacheThumbnail: cacheThumbnail,
                        animateGIF: animateGIF
                    )
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

            TextField("Server URL", text: $serverURL)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Username", text: $username)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Toggle("Remember Me", isOn: $rememberMe)
            Toggle("Transit Protection", isOn: $transitProtection)

            Section {
                DisclosureGroup("Advanced Settings", isExpanded: $showAdvancedOptions) {
                    Toggle("Cache Images", isOn: $cacheImage)
                    Toggle("Cache PDFs", isOn: $cachePDF)
                    Toggle("Cache Text Files", isOn: $cacheText)
                    Toggle("Cache Thumbnails", isOn: $cacheThumbnail)
                    Toggle("Animate GIF Files", isOn: $animateGIF)
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button(action: {
                login()
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Login")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(isLoading)

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
    }

    func handleLogout() {
        isLoggedIn = false
        if !rememberMe {
            username = ""
            password = ""
        }

        statusMessage = "⚠️ Logout successful!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            statusMessage = nil
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
                    } else {
                        errorMessage = "Failed to decode token"
                    }
                } else {
                    errorMessage = "Login failed: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}

struct Folder: Hashable {
    let name: String
}
