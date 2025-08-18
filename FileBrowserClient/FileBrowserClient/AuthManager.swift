//
//  AuthManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import Foundation

class AuthManager: ObservableObject {
    @Published var token: String?
    @Published var serverURL: String?
    @Published var username: String?
    @Published var tokenPayload: JWTPayload?

    var isAuthenticated: Bool {
        return token != nil && serverURL != nil
    }
}

struct JWTPayload: Codable {
    let iat: TimeInterval
    let iss: String
    let exp: TimeInterval
    var user: UserAccount
}

struct UserAccount: Codable {
    let lockPassword: Bool
    let locale: String
    let perm: UserPermission
    let singleClick: Bool
    let id: Int
    let commands: [String]?
    let viewMode: String
    // MARK: Updated by settings page
    var hideDotfiles: Bool
    var dateFormat: Bool
}

struct UserPermission: Codable {
    let share: Bool
    let admin: Bool
    let rename: Bool
    let modify: Bool
    let delete: Bool
    let execute: Bool
    let download: Bool
    let create: Bool
}

extension AuthManager {

    func serverHandShake(for userID: String, token: String, serverURL: String) async -> String? {
        guard let url = URL(string: "\(serverURL)/api/users/\(userID)") else {
            return "❌ Failed to construct url for: \(serverURL)"
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                Log.error("❌ Response was not HTTPURLResponse")
                return "Response was not HTTPURLResponse"
            }

            guard httpResponse.statusCode == 200 else {
                // DO NOT CHANGE: Used to validate server hand-shake in biometrics login
                let errorMessage = "HTTP error: [\(httpResponse.statusCode)] - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                Log.error("❌ \(errorMessage)")
                return "\(httpResponse.statusCode)"
            }
        } catch {
            Log.error("❌ Failed to fetch permissions for UserID \(userID): \(error.localizedDescription)")
            return error.localizedDescription
        }
        return nil
    }
}
