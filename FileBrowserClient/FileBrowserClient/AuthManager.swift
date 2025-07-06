//
//  AuthManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/6/25.
//


import Foundation

class AuthManager: ObservableObject {
    @Published var token: String? = nil
    @Published var serverURL: String? = nil

    var isAuthenticated: Bool {
        return token != nil && serverURL != nil
    }

    func logout() {
        token = nil
        serverURL = nil
    }
}
