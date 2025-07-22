//
//  AuthManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//


import Foundation

struct UserPermission: Codable {
    let rename: Bool
    let delete: Bool
    // reminder: Add others if/when needed
}

class AuthManager: ObservableObject {
    @Published var token: String? = nil
    @Published var serverURL: String? = nil
    @Published var currentUsername: String? = nil
    @Published var permissions: UserPermission? = nil

    var isAuthenticated: Bool {
        return token != nil && serverURL != nil
    }

    func logout() {
        token = nil
        serverURL = nil
        currentUsername = nil
        permissions = nil
    }
}
