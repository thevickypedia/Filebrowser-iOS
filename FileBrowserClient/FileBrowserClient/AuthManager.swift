//
//  AuthManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import Foundation

struct UserPermission: Codable {
    var admin: Bool
    var execute: Bool
    var create: Bool
    var rename: Bool
    var modify: Bool
    var delete: Bool
    var share: Bool
    var download: Bool
}

class AuthManager: ObservableObject {
    @Published var token: String?
    @Published var serverURL: String?
    @Published var iss: String?
    @Published var iat: TimeInterval?
    @Published var exp: TimeInterval?
    @Published var permissions: UserPermission?
    @Published var username: String?
    @Published var userAccount: UserAccount?

    var isAuthenticated: Bool {
        return token != nil && serverURL != nil
    }

    func logout() {
        token = nil
        serverURL = nil
    }
}

struct UserAccount: Codable {
    let id: Int
    let username: String
    var locale: String
    var viewMode: String
    var hideDotfiles: Bool
    var dateFormat: Bool?
    var lockPassword: Bool
    var perm: UserPermission
    var commands: [String]?
}

extension AuthManager {

    func fetchUserAccount(for username: String, token: String, serverURL: String) async {
        guard let url = URL(string: "\(serverURL)/api/users") else { return }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let users = try JSONDecoder().decode([UserAccount].self, from: data)
            if let current = users.first(where: { $0.username == username }) {
                await MainActor.run {
                    self.userAccount = current
                    Log.info("✅ Loaded user ID: \(current.id)")
                }
            }
        } catch {
            Log.error("❌ Failed to load user account: \(error)")
        }
    }

    func fetchPermissions(for username: String, token: String, serverURL: String) async {
        guard let url = URL(string: "\(serverURL)/api/users") else { return }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let users = try JSONDecoder().decode([UserAccount].self, from: data)
            if let current = users.first(where: { $0.username == username }) {
                await MainActor.run {
                    self.permissions = current.perm
                    self.userAccount = current
                    Log.debug("✅ Permissions + user loaded for \(username)")
                }
            } else {
                Log.error("❌ User not found in /api/users")
            }
        } catch {
            Log.error("❌ Failed to fetch permissions: \(error)")
        }
    }
}
