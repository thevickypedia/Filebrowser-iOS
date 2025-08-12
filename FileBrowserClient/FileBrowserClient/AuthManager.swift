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

    func fetchPermissions(for username: String, token: String, serverURL: String) async -> String? {
        guard let url = URL(string: "\(serverURL)/api/users") else {
            return "❌ Failed to construct url for: \(serverURL)"
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                Log.error("❌ Response was not HTTPURLResponse")
                return "Response was not HTTPURLResponse"
            }

            guard httpResponse.statusCode == 200 else {
                let errorMessage = "HTTP error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                Log.error("❌ \(errorMessage)")
                return errorMessage
            }

            let users = try JSONDecoder().decode([UserAccount].self, from: data)
            if let current = users.first(where: { $0.username == username }) {
                await MainActor.run {
                    self.permissions = current.perm
                    self.userAccount = current
                    Log.debug("✅ Permissions + user loaded for \(username)")
                }
            } else {
                let errorMessage = "User [\(username)] not found in /api/users"
                Log.error("❌ \(errorMessage)")
                return errorMessage
            }
        } catch {
            Log.error("❌ Failed to fetch permissions for \(username): \(error.localizedDescription)")
            return error.localizedDescription
        }
        return nil
    }
}
