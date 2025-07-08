//
//  ContentView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var serverURL = ""
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var token: String?
    @EnvironmentObject var auth: AuthManager
    @State private var isLoggedIn = false
    @State private var rememberMe = false
    @State private var showLogoutMessage = false

    @StateObject private var fileListViewModel = FileListViewModel()

    var body: some View {
        if isLoggedIn {
            NavigationStack {
                FileListView(
                    path: "/",
                    isLoggedIn: $isLoggedIn,
                    logoutHandler: handleLogout
                )
                .environmentObject(fileListViewModel)
            }
        } else {
            loginView
        }
    }

    var loginView: some View {
        VStack(spacing: 20) {
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

            if showLogoutMessage {
                Text("⚠️ Logout successful!")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .padding()
            } else if let token = token {
                Text("✅ Login successful!")
                    .font(.caption)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("FileBrowser Login")
    }

    func handleLogout() {
        isLoggedIn = false
        showLogoutMessage = true
        if !rememberMe {
            username = ""
            password = ""
        }
    }

    func login() {
        isLoading = true
        errorMessage = nil
        token = nil

        guard let url = URL(string: "\(serverURL)/api/login") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        let credentials = [
            "username": username,
            "password": password
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: [])
        } catch {
            errorMessage = "Failed to encode credentials"
            isLoading = false
            return
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

                        // ✅ Configure the view model
                        fileListViewModel.configure(token: jwt, serverURL: serverURL)
                        isLoggedIn = true
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
