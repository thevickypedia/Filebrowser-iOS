//
//  FileBrowserClientApp.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI

@main
struct FileBrowserClientApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .onAppear {
                    attemptSessionRestore()
                }
        }
    }

    func attemptSessionRestore() {
        // Only attempt biometric restore if user explicitly enabled it
        guard UserDefaults.standard.bool(forKey: "useFaceID") else { return }

        KeychainHelper.authenticateWithBiometrics { success in
            guard success,
                  let session = KeychainHelper.loadSession(),
                  let token = session["token"],
                  let username = session["username"],
                  let serverURL = session["serverURL"] else {
                return
            }
            DispatchQueue.main.async {
                authManager.token = token
                authManager.username = username
                authManager.serverURL = serverURL
                Task {
                    await authManager.fetchPermissions(for: username, token: token, serverURL: serverURL)
                }
            }
        }
    }
}
