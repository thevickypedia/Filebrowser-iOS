//
//  BackgroundLogin.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/30/25.
//

import SwiftUI

struct BackgroundLogin {
    var auth: AuthManager

    @State private var reauthTimer: Timer?
    @State private var reauthDispatchWorkItem: DispatchWorkItem?

    func backgroundLogout() {
        // Reset auth timer and reauth work item
        reauthTimer?.invalidate()
        reauthTimer = nil
        reauthDispatchWorkItem?.cancel()
        reauthDispatchWorkItem = nil
    }

    // TODO: Make func return a status struct
    func attemptLogin() {
        // TODO: This is always empty, as @State is not persisted in non-Views
        if auth.serverURL.isEmpty || auth.username.isEmpty || auth.password.isEmpty {
            Log.error("serverURL or username or password is empty!")
            return
        }
        if auth.serverURL.hasSuffix("/") {
            auth.serverURL.removeLast()
        }
        guard let url = URL(string: "\(auth.serverURL)/api/login") else {
            Log.error("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if auth.transitProtection {
            let hexUsername = convertStringToHex(auth.username)
            let hexPassword = convertStringToHex(auth.password)
            let hexRecaptcha = convertStringToHex("")
            
            let combined = "\\u" + hexUsername + "," + "\\u" + hexPassword + "," + "\\u" + hexRecaptcha
            
            guard let payload = combined.data(using: .utf8)?.base64EncodedString() else {
                Log.error("Failed to encode credentials")
                return
            }
            
            request.setValue(payload, forHTTPHeaderField: "Authorization")
            request.httpBody = nil
        } else {
            let credentials = [
                "username": auth.username,
                "password": auth.password
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: [])
            } catch {
                Log.error("Failed to encode credentials")
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                Log.error("Invalid response")
                return
            }
            guard httpResponse.statusCode == 200 else {
                Log.error("\(httpResponse.statusCode)")
                return
            }
            guard let responseData = data else {
                Log.error("No response data received")
                return
            }
            guard let jwt = String(data: responseData, encoding: .utf8) else {
                Log.error("Failed to extract JWT")
                return
            }
            guard let payload = decodeJWT(jwt: jwt) else {
                Log.error("Failed to decode token")
                return
            }
            // MARK: Set auth params
            DispatchQueue.main.async {
                auth.token = jwt
                auth.tokenPayload = payload
            }
            logTokenInfo()
            KeychainHelper.saveSession(
                session: StoredSession(
                    token: jwt,
                    username: auth.username,
                    serverURL: auth.serverURL,
                    transitProtection: auth.transitProtection,
                    // MARK: Always store during background login
                    password: auth.password
                )
            )
        }.resume()
    }

    func logTokenInfo() {
        Log.info("Issuer: \(auth.tokenPayload?.iss ?? "Unknown")")
        Log.info("Issued: \(timeStampToString(from: auth.tokenPayload?.iat))")
        Log.info("Expiration: \(timeStampToString(from: auth.tokenPayload?.exp))")
        Log.info("Time Left: \(timeLeftString(until: auth.tokenPayload?.exp))")
    }

    func startReauthTimer(at startTime: TimeInterval) {
        // Invalidate existing timer before creating a new one - since called from both regular login and faceID login
        reauthTimer?.invalidate()
        reauthDispatchWorkItem?.cancel()

        // Only start the timer if Face ID is enabled and a session exists
        // Password is stored in keychain only when FaceID is enabled
        guard let session = KeychainHelper.loadSession(),
              session.password != nil else {
            Log.warn("FaceID or session unavailable to start re-auth timer")
            return
        }

        let workItem = DispatchWorkItem {
            DispatchQueue.main.async {
                self.reauthTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                    Task {
                        await self.reauthenticateWithStoredSession(session)
                    }
                }
            }
        }
        reauthDispatchWorkItem = workItem

        let delay = startTime - Date().timeIntervalSince1970 - 30  // NOTE: Add a 30s buffer
        if delay > 0 {
            let fireDate = Date(timeIntervalSince1970: startTime)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy HH:mm:ss"
            let formattedDate = formatter.string(from: fireDate)
            Log.info("Session is still valid for \(Int(delay / 60)) minutes, workItem will be initiated on: \(formattedDate)")
            let deadline = DispatchTime.now() + delay
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: workItem)
        } else {
            Log.error("Session has already expired or near expiry, initiating workItem immediately.")
            DispatchQueue.main.async(execute: workItem)
        }
    }

    private func reauthenticateWithStoredSession(_ session: StoredSession) async {
        guard session.serverURL == auth.serverURL else {
            Log.warn("⚠️ Background reauth failed: Mismatched serverURL")
            return
        }

        guard let payload = decodeJWT(jwt: session.token) else {
            Log.warn("⚠️ Background reauth failed: could not decode token")
            return
        }

        let now = Date().timeIntervalSince1970
        if now >= payload.exp - 30 {  // NOTE: Add a 30s buffer
            Log.info("🔄 Token expired. Refreshing in background.")
            if session.password != nil {
                // MARK: After a successful login, the startReauthTimer will kick off with new expiration time
                attemptLogin()
            } else {
                Log.warn("❌ Token expired but no password saved. Cannot reauthenticate.")
            }
        } else {
            Log.trace("✅ Token still valid. No need to refresh.")
        }
    }
}
