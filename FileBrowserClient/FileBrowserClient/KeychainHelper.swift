//
//  KeychainHelper.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/8/25.
//

import Foundation
import LocalAuthentication
import Security

enum KeychainHelper {
    static let key = "savedSession"
    static let knownServersKey = "knownServers"
    static func saveSession(token: String, username: String, serverURL: String, password: String? = nil) {
        var session: [String: String] = [
            "token": token,
            "username": username,
            "serverURL": serverURL
        ]
        if let password = password {
            session["password"] = password
        }
        if let data = try? JSONEncoder().encode(session) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
            ]
            SecItemDelete(query as CFDictionary) // overwrite
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    static func loadSession() -> [String: String]? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let session = try? JSONDecoder().decode([String: String].self, from: data) else {
            return nil
        }
        return session
    }

    static func deleteSession() {
        Log.info("Deleting session information from keychain")
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }

    static func authenticateWithBiometrics(reason: String = "Authenticate to restore session", completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            completion(false)
        }
    }

    static func saveKnownServers(_ servers: [String]) {
        let data = try? JSONEncoder().encode(servers)
        guard let encodedData = data else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: knownServersKey,
            kSecValueData as String: encodedData
        ]

        // Delete existing data to replace it with the new data
        SecItemDelete(query as CFDictionary)

        // Add the new data to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            Log.error("Failed to save known servers: \(status)")
            return
        }
    }

    static func loadKnownServers() -> [String] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: knownServersKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let servers = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return servers
    }

    static func deleteKnownServer(_ serverURL: String) {
        // Load the current known servers
        var knownServers = loadKnownServers()

        // Remove the serverURL from the list
        knownServers.removeAll { $0 == serverURL }

        // Save the updated list of known servers back to the Keychain
        saveKnownServers(knownServers)
    }

    static func deleteKnownServers() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: knownServersKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}
