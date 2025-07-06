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

                Spacer()
            }
            .padding()
            .navigationTitle("FileBrowser Login")
        }
    }

    func login() {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "\(serverURL)/api/login") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        let payload = [
            "username": username,
            "password": password
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "Invalid response"
                    return
                }

                if httpResponse.statusCode == 200 {
                    // Success - parse token or proceed
                    print("Login successful")
                } else {
                    errorMessage = "Login failed: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}
