//
//  BackgroundLogin.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/30/25.
//

import SwiftUI

struct BackgroundLogin {
    var auth: AuthManager
    let baseRequest: Request

    @State private var reauthTimer: Timer?
    @State private var reauthDispatchWorkItem: DispatchWorkItem?

    func backgroundLogout() {
        // Reset auth timer and reauth work item
        Log.info("✖️ Invalidating reauth timer and dispatch work item")
        reauthTimer?.invalidate()
        reauthTimer = nil
        reauthDispatchWorkItem?.cancel()
        reauthDispatchWorkItem = nil
    }

    func loginResponse(_ responseText: String, success: Bool = false, statusCode: Int = 0) -> ServerResponse {
        if success {
            Log.info(responseText)
        } else {
            Log.error(responseText)
        }
        return ServerResponse(success: success, text: responseText, statusCode: statusCode)
    }

    @MainActor
    func updateAuthState(token: String, payload: JWTPayload) {
        auth.token = token
        auth.tokenPayload = payload
    }

    func attemptLogin() async -> ServerResponse {
        if auth.serverURL.isEmpty || auth.username.isEmpty || auth.password.isEmpty {
            return loginResponse("❌ serverURL or username or password is empty!")
        }

        guard var preparedRequest = baseRequest.prepare(
            pathComponents: ["api", "login"],
            method: RequestMethod.post,
        ) else {
            return loginResponse("Failed to prepare request for: /api/login")
        }
        if auth.transitProtection {
            let hexUsername = convertStringToHex(auth.username)
            let hexPassword = convertStringToHex(auth.password)
            let hexRecaptcha = convertStringToHex("")

            let combined = "\\u" + hexUsername + "," + "\\u" + hexPassword + "," + "\\u" + hexRecaptcha

            guard let payload = combined.data(using: .utf8)?.base64EncodedString() else {
                return loginResponse("❌ Failed to encode credentials")
            }

            preparedRequest.request.setValue(payload, forHTTPHeaderField: "Authorization")
            preparedRequest.request.httpBody = nil
        } else {
            let credentials = [
                "username": auth.username,
                "password": auth.password
            ]

            do {
                preparedRequest.request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: [])
            } catch {
                return loginResponse("❌ Failed to encode credentials")
            }
        }

        do {
            let (data, response) = try await preparedRequest.session.data(for: preparedRequest.request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return loginResponse("❌ Invalid response")
            }
            guard httpResponse.statusCode == 200 else {
                return loginResponse("❌ HTTP error \(httpResponse.statusCode)", statusCode: httpResponse.statusCode)
            }
            guard let jwt = String(data: data, encoding: .utf8) else {
                return loginResponse("❌ Failed to extract JWT", statusCode: httpResponse.statusCode)
            }
            guard let payload = decodeJWT(jwt: jwt) else {
                return loginResponse("❌ Failed to decode token", statusCode: httpResponse.statusCode)
            }

            await updateAuthState(token: jwt, payload: payload)

            logTokenInfo()
            KeychainHelper.saveSession(
                session: StoredSession(
                    token: jwt,
                    username: auth.username,
                    serverURL: auth.serverURL,
                    transitProtection: auth.transitProtection,
                    password: auth.password
                )
            )
            return loginResponse("🔄 Authentication Renewed", success: true, statusCode: httpResponse.statusCode)
        } catch {
            return loginResponse("❌ Network error: \(error.localizedDescription)")
        }
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
                self.reauthTimer = Timer.scheduledTimer(withTimeInterval: Constants.backgroundLoginFrequency, repeats: true) { _ in
                    Task {
                        await self.reauthenticateWithStoredSession(session)
                    }
                }
            }
        }
        reauthDispatchWorkItem = workItem

        let delay = startTime - Date().timeIntervalSince1970 - Constants.backgroundLoginBuffer
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

        Log.trace("Checking if token is still valid...")
        let now = Date().timeIntervalSince1970
        if now >= payload.exp - Constants.backgroundLoginBuffer {
            Log.info("🔄 Token expired. Refreshing in background.")
            if session.password != nil {
                // MARK: After a successful login, the startReauthTimer will kick off with new expiration time
                _ = await attemptLogin()
            } else {
                Log.warn("❌ Token expired but no password saved. Cannot reauthenticate.")
            }
        } else {
            Log.trace("✅ Token still valid. No need to refresh.")
        }
    }
}
