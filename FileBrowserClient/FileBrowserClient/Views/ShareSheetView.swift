//
//  ShareSheetView.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/16/25.
//

// ShareSheetView.swift
import SwiftUI

/// A share sheet view that is reusable across the app.
/// Bindings:
/// - isPresented: controls sheet presentation
/// - sharedObjects: backing dictionary for generated links
/// - shareMessage: ToastMessagePayload used by your StatusMessage modifier
struct ShareSheetView: View {
    let serverURL: String
    let token: String
    let file: FileItem

    // Add this closure for dismissing the sheet
    let onDismiss: () -> Void

    @State private var isShareInProgress = false
    @State private var durationDigit = ""
    @State private var shareDuration = "hours"
    @State private var sharePassword = ""
    let shareDurationOptions = ["minutes", "hours", "days"]
    @State private var sharedObjects: [String: ShareLinks] = [:]
    @State private var shareMessage: ToastMessagePayload?
    // Display as alerts
    @State private var errorTitle: String?
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    if isShareInProgress {
                        ProgressView("Generating link...")
                    }

                    if let shareLink = sharedObjects[file.path],
                       let unsigned = shareLink.unsigned,
                       let presigned = shareLink.presigned {
                        Section(header: Text("Links")) {
                            ShareLinkRow(title: "Unsigned URL", url: unsigned) { payload in
                                shareMessage = payload
                            }
                            ShareLinkRow(title: "Pre-Signed URL", url: presigned) { payload in
                                shareMessage = payload
                            }
                        }

                        Button("Delete") {
                            deleteShared(deleteHash: shareLink.hash)
                        }
                        .foregroundColor(.red)

                    } else {
                        Section(header: Text("Share Duration")) {
                            Text(file.path)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .textSelection(.enabled)
                            HStack {
                                TextField("0", text: $durationDigit)
                                    .keyboardType(.numbersAndPunctuation)
                                    .frame(width: 80)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Picker(selection: $shareDuration, label: Text("")) {
                                    ForEach(shareDurationOptions, id: \.self) { duration in
                                        Text(duration.capitalized).tag(duration)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }

                        Section(header: Text("Password")) {
                            SecureField("Enter password", text: $sharePassword)
                            if sharePassword.trimmingCharacters(in: .whitespaces).isEmpty {
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.yellow)
                                    Text("You are about to generate a **public** share link. It is recommended to add a password for additional security.")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }.padding(.top, 4)
                            }
                        }
                    }
                }

                // ✅ Buttons moved outside Form
                if sharedObjects[file.path] == nil {
                    HStack(spacing: 16) {
                        Button(action: {
                            onDismiss()
                        }) {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.red)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }

                        Button(action: {
                            guard let expiry = Int(durationDigit), expiry > 0 else {
                                shareMessage = ToastMessagePayload(text: "❌ Input time should be more than 0", color: .red, duration: 3)
                                return
                            }
                            submitShare()
                        }) {
                            Text("Share")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(isShareInProgress ? Color.gray : Color.blue)
                                .cornerRadius(8)
                        }
                        .disabled(isShareInProgress)
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Share", displayMode: .inline)
            .modifier(ToastMessage(payload: $shareMessage))
            .modifier(ErrorAlert(title: $errorTitle, message: $errorMessage))
        }
    }

    func deleteShared(deleteHash: String?) {
        guard let hash = deleteHash else {
            self.errorTitle = "Internal Error"
            self.errorMessage = "❌ Hash missing for shared link."
            return
        }
        guard let deleteURL = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "share", hash]
        ) else {
            self.errorTitle = "Internal Error"
            self.errorMessage = "❌ Failed to construct shared link"
            return
        }
        Log.debug("Delete share URL: \(deleteURL)")
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                self.errorTitle = "Server Error"
                guard error == nil else {
                    Log.error("❌ Request failed: \(error?.localizedDescription ?? "Unknown error")")
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    self.errorMessage = "Response was not HTTPURLResponse"
                    return
                }

                let responseText = formatHttpResponse(httpResponse)
                guard httpResponse.statusCode == 200 else {
                    Log.error("❌ Server error: \(responseText)")
                    self.errorMessage = responseText
                    return
                }
                sharedObjects.removeValue(forKey: file.path)
                shareMessage = ToastMessagePayload(text: "🗑️ Share link for \(file.name) has been removed", color: .red)
            }
        }.resume()
    }

    func submitShare() {
        if let existing = sharedObjects[file.path],
           existing.unsigned != nil,
           existing.presigned != nil {
            shareMessage = ToastMessagePayload(
                text: "⚠️ A share for \(file.name) already exists!",
                color: .yellow
            )
            return
        }
        isShareInProgress = true
        guard let expiryTime = Int(durationDigit), expiryTime > 0 else {
            shareMessage = ToastMessagePayload(
                text: "❌ Input time should be more than 0",
                color: .red
            )
            return
        }

        guard let shareURL = buildAPIURL(
            base: serverURL,
            pathComponents: ["api", "share", file.path],
            queryItems: [
                URLQueryItem(name: "expires", value: String(expiryTime)),
                URLQueryItem(name: "unit", value: shareDuration)
            ]
        ) else {
            self.errorTitle = "Internal Error"
            self.errorMessage = "❌ Failed to construct shared link"
            return
        }
        Log.debug("Share URL: \(shareURL)")

        var request = URLRequest(url: shareURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Auth")

        let body: [String: String] = [
            "password": sharePassword,
            "expires": String(expiryTime),
            "unit": shareDuration
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            Log.error("❌ Failed to encode JSON body: \(error.localizedDescription)")
            self.errorTitle = "Internal Error"
            self.errorMessage = "❌ Failed to encode JSON body: \(error.localizedDescription)"
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                defer {
                    isShareInProgress = false  // ✅ re-enable buttons after response
                }
                self.errorTitle = "Server Error"
                guard error == nil, let data = data else {
                    Log.error("❌ Request failed: \(error?.localizedDescription ?? "Unknown error")")
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    Log.error("❌ Server error: Response was not HTTPURLResponse")
                    self.errorMessage = "Response was not HTTPURLResponse"
                    return
                }

                let responseText = formatHttpResponse(httpResponse)
                guard httpResponse.statusCode == 200 else {
                    Log.error("❌ Server error: \(responseText)")
                    self.errorMessage = responseText
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        Log.info("✅ JSON Data: \(json)")
                        let sharedLink = try JSONDecoder().decode(ShareResponse.self, from: data)
                        let unsigned = buildAPIURL(
                            base: serverURL,
                            pathComponents: ["share", sharedLink.hash]
                        )
                        var preSigned: URL?
                        if let token = sharedLink.token {
                            preSigned = buildAPIURL(
                                base: serverURL,
                                pathComponents: ["api", "public", "dl", sharedLink.hash, file.path],
                                queryItems: [URLQueryItem(name: "token", value: token)]
                            )
                        } else {
                            preSigned = buildAPIURL(
                                base: serverURL,
                                pathComponents: ["api", "public", "dl", sharedLink.hash, file.path]
                            )
                        }
                        self.sharedObjects[file.path] = ShareLinks(
                            unsigned: unsigned,
                            presigned: preSigned,
                            hash: sharedLink.hash
                        )
                        let delay = Double(sharedLink.expire) - Date().timeIntervalSince1970
                        if delay > 0 {
                            Log.info("Shared link will be cleared after \(expiryTime) \(shareDuration) [\(delay)s]")
                            shareMessage = ToastMessagePayload(
                                text: "🔗 Share link for \(file.name) has been created", color: .green
                            )
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                shareMessage = ToastMessagePayload(
                                    text: "⚠️ Shared link for \(file.name) has expired",
                                    color: .yellow,
                                    duration: 3
                                )
                                self.sharedObjects.removeValue(forKey: file.path)
                            }
                        } else {
                            // If the expiration time is in the past, remove it immediately
                            self.sharedObjects.removeValue(forKey: file.path)
                        }
                    } else {
                        Log.error("❌ Malformed /api/share/ response")
                        self.errorTitle = "Internal Error"
                        self.errorMessage = "❌ Malformed /api/share/ response"
                    }
                } catch {
                    Log.error("❌ JSON parse error for share: \(error.localizedDescription)")
                    self.errorTitle = "Internal Error"
                    self.errorMessage = "❌ JSON parse error for share: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
