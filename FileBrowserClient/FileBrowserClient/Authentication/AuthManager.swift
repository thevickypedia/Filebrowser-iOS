//
//  AuthManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//

import Foundation

class AuthManager: ObservableObject {
    @Published var token: String = ""
    @Published var serverURL: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var transitProtection: Bool = false
    @Published var tokenPayload: JWTPayload?

    var isValid: Bool {
        !self.serverURL.isEmpty && !self.token.isEmpty && self.tokenPayload != nil
    }

    var userPermissions: UserPermission? {
        return self.tokenPayload?.user.perm
    }

    var hasModifyPermissions: Bool {
        let permissions = userPermissions
        return permissions?.rename == true || permissions?.delete == true || permissions?.share == true
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

    func serverHandShake(for userID: String) async -> ServerResponse {
        let baseRequest = Request(baseURL: self.serverURL, token: self.token)
        guard let preparedRequest = baseRequest.prepare(pathComponents: ["api", "users", userID]) else {
            return ServerResponse(success: false, text: "Invalid URL: /api/users/\(userID)")
        }

        do {
            let (_, response) = try await preparedRequest.session.data(for: preparedRequest.request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return ServerResponse(success: false, text: "❌ Response was not HTTPURLResponse")
            }

            let responseText = formatHttpResponse(httpResponse)
            guard httpResponse.statusCode == 200 else {
                return ServerResponse(success: false, text: "❌ HTTP Error: \(responseText)", statusCode: httpResponse.statusCode)
            }
            return ServerResponse(success: true, text: "✅ Server hand shake successful: \(responseText)", statusCode: httpResponse.statusCode)
        } catch {
            return ServerResponse(
                success: false,
                text: "❌ Failed to fetch permissions for UserID \(userID): \(error.localizedDescription)"
            )
        }
    }
}
