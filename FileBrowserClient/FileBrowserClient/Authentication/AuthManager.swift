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
    @Published var oneTimePasscodeSecret: String = ""
    @Published var transitProtection: Bool = false
    @Published var tokenPayload: JWTPayload?
    @Published var serverVersion: String?
    @Published var clientVersion: String?

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

enum SortBy: String, Codable {
    case name
    case modified
    case size
}

struct Sorting: Codable {
    let by: SortBy
    let asc: Bool
}

struct UserAccount: Codable {
    let id: Int
    let username: String?
    let password: String?
    let scope: String?
    let locale: String
    let lockPassword: Bool
    let viewMode: String  // MARK: Mobile app uses it's own view mode
    let singleClick: Bool
    var redirectAfterCopyMove: Bool  // MARK: Updated by settings page
    let perm: UserPermission
    let commands: [String]?
    let sorting: Sorting?  // MARK: Mobile app uses it's own sort option
    let rules: [String]?
    var hideDotfiles: Bool  // MARK: Updated by settings page
    var dateFormat: Bool  // MARK: Updated by settings page
    var aceEditorTheme: String?
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
