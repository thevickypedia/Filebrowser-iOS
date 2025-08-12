//
//  KeychainHelper.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/8/25.
//

import Foundation
import LocalAuthentication
import Security

// TODO: BUG INTRODUCED!!
// TODO: FaceID doesn't work unless username and password are entered.
// TODO: Credentials are not used, but is required to immediately swap to FaceID
enum KeychainHelper {
    static let key = "savedSession"
    static let knownServersKey = "knownServers"

    static func makeKeychainQuery(username: String, serverURL: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: serverURL
        ]
    }

    static func saveSession(token: String, username: String, serverURL: String, password: String? = nil) {
        Log.info("Saving session for \(username): \(serverURL)")
        var session: [String: String] = [
            "token": token,
            "username": username,
            "serverURL": serverURL
        ]
        if let password = password {
            session["password"] = password
        }

        guard let data = try? JSONEncoder().encode(session) else { return }

        var query = makeKeychainQuery(username: username, serverURL: serverURL)
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly

        // Overwrite existing entry
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    static func loadSession(username: String, serverURL: String) -> [String: String]? {
        Log.info("Loading session for \(username): \(serverURL)")
        var query = makeKeychainQuery(username: username, serverURL: serverURL)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let session = try? JSONDecoder().decode([String: String].self, from: data) else {
            return nil
        }

        return session
    }

    static func deleteSession(username: String, serverURL: String) {
        Log.info("Deleting session for \(username): \(serverURL)")
        let query = makeKeychainQuery(username: username, serverURL: serverURL)
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
            print("Failed to save known servers: \(status)")
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
