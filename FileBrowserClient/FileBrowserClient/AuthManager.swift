//
//  AuthManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//


import Foundation

struct UserPermission: Codable {
    let admin: Bool
    let execute: Bool
    let create: Bool
    let rename: Bool
    let modify: Bool
    let delete: Bool
    let share: Bool
    let download: Bool
}

class AuthManager: ObservableObject {
    @Published var token: String? = nil
    @Published var serverURL: String? = nil
    @Published var permissions: UserPermission? = nil

    var isAuthenticated: Bool {
        return token != nil && serverURL != nil
    }

    func logout() {
        token = nil
        serverURL = nil
    }
}

struct UserPermissions: Codable {
    let rename: Bool
    let delete: Bool
    let download: Bool
    let share: Bool
    let create: Bool
    // Add more if needed
}

struct UserAccount: Codable {
    let username: String
    let perm: UserPermission
}

extension AuthManager {

    func fetchPermissions(for username: String, token: String, serverURL: String) {
        guard let url = URL(string: "\(serverURL)/api/users") else { return }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("❌ Failed to fetch permissions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let users = try JSONDecoder().decode([UserAccount].self, from: data)
                if let current = users.first(where: { $0.username == username }) {
                    DispatchQueue.main.async {
                        self.permissions = current.perm
                        print("✅ Permissions loaded for user \(username): \(current.perm)")
                    }
                } else {
                    print("❌ User not found in /api/users")
                }
            } catch {
                print("❌ JSON decode failed: \(error)")
            }
        }.resume()
    }
}
