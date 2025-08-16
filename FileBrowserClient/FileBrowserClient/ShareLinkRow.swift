//
//  ShareLinkRow.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/16/25.
//

import SwiftUI

struct ShareResponse: Codable {
    let hash: String
    let path: String
    let userID: Int
    let expire: Int
    let passwordHash: String?
    let token: String?

    enum CodingKeys: String, CodingKey {
        case hash
        case path
        case userID
        case expire
        case passwordHash = "password_hash"
        case token
    }
}

struct ShareLinks {
    let unsigned: URL?
    let presigned: URL?
}

struct ShareLinkRow: View {
    var title: String
    var url: URL
    var onCopy: (StatusPayload) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text(url.absoluteString)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .font(.footnote)
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = url.absoluteString
                    onCopy(StatusPayload(
                        text: "📋 \(title) copied to clipboard",
                        color: .green,
                        duration: 3
                    ))
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.vertical, 4)
    }
}
