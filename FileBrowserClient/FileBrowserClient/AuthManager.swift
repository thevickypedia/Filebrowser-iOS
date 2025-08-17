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

    @Published var userAccount: UserAccount?
    @Published var jwtWrapper: JWTUserWrapper?

    var isAuthenticated: Bool {
        return token != nil && serverURL != nil
    }
}

struct JWTUserWrapper: Codable {
    let user: UserAccount
    let iss: String
    let iat: TimeInterval
    let exp: TimeInterval
}

struct UserAccount: Codable {
    let id: Int
    var locale: String
    var viewMode: String
    let singleClick: Bool
    var perm: UserPermission
    var commands: [String]?
    var lockPassword: Bool
    var hideDotfiles: Bool
    var dateFormat: Bool?
}

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


extension AuthManager {

    func fetchPermissions(for userID: Int, token: String, serverURL: String) async -> String? {
        guard let url = URL(string: "\(serverURL)/api/users/\(userID)") else {
            return "❌ Failed to construct url for: \(serverURL)"
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // guard logJsonData(data: data) else { return "Failed to parse server response" }
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
            Log.error("❌ Failed to fetch permissions for \(userID): \(error.localizedDescription)")
            return error.localizedDescription
        }
        return nil
    }
}
