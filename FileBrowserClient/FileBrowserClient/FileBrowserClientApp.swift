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
        KeychainHelper.authenticateWithBiometrics { success in
            guard success, let session = KeychainHelper.loadSession(),
                  let token = session["token"],
                  let username = session["username"],
                  let serverURL = session["serverURL"] else {
                return
            }
            authManager.token = token
            authManager.username = username
            authManager.serverURL = serverURL
            Task {
                await authManager.fetchPermissions(for: username, token: token, serverURL: serverURL)
            }
        }
    }
}
