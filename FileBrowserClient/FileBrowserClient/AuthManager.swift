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
    @Published var token: String? = nil
    @Published var serverURL: String? = nil
    @Published var permissions: UserPermission? = nil
    @Published var username: String? = nil
    @Published var userAccount: UserAccount? = nil

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
    var dateFormat: StringOrBool?
    var lockPassword: Bool
    var perm: UserPermission
    var commands: [String]?
}

enum StringOrBool: Codable {
    case string(String)
    case bool(Bool)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self) {
            self = .string(str)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else {
            throw DecodingError.typeMismatch(
                StringOrBool.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Bool")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let str): try container.encode(str)
        case .bool(let bool): try container.encode(bool)
        }
    }
}

struct Sorting: Codable {
    var by: String
    var asc: Bool
}

struct Terminal: Codable {
    var command: String
    var enabled: Bool
}

extension AuthManager {

    func fetchUserAccount(for username: String, token: String, serverURL: String) {
        guard let url = URL(string: "\(serverURL)/api/users") else { return }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                Log.error("❌ Failed to fetch user list")
                return
            }

            do {
                let users = try JSONDecoder().decode([UserAccount].self, from: data)
                if let current = users.first(where: { $0.username == username }) {
                    DispatchQueue.main.async {
                        self.userAccount = current
                        Log.info("✅ Loaded user ID: \(current.id)")
                    }
                } else {
                    Log.error("❌ User not found")
                }
            } catch {
                Log.error("❌ Failed to decode user list: \(error)")
            }
        }.resume()
    }

    func fetchPermissions(for username: String, token: String, serverURL: String) {
        guard let url = URL(string: "\(serverURL)/api/users") else { return }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                Log.error("❌ Failed to fetch permissions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let users = try JSONDecoder().decode([UserAccount].self, from: data)
                if let current = users.first(where: { $0.username == username }) {
                    DispatchQueue.main.async {
                        self.permissions = current.perm
                        self.userAccount = current
                        Log.debug("✅ Permissions + user loaded for \(username)")
                    }
                } else {
                    Log.error("❌ User not found in /api/users")
                }
            } catch {
                Log.error("❌ JSON decode failed: \(error)")
            }
        }.resume()
    }
}
