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

    var body: some View {
        NavigationView {
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

                if let token = token {
                    Text("Logged in with token:\n\(token)")
                        .font(.caption)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("FileBrowser Login")
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

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "No response from server"
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }

                if httpResponse.statusCode == 200 {
                    if let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let jwt = result["token"] as? String {
                        token = jwt
                        print("Login success. Token: \(jwt)")
                    } else {
                        errorMessage = "Unexpected response format"
                    }
                } else {
                    errorMessage = "Login failed: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}
