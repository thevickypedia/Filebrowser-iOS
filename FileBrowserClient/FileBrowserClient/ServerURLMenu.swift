//
//  ServerURLMenu.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/9/25.
//

import SwiftUI

struct ServerURLMenu: View {
    @Binding var serverURL: String
    @Binding var showAddServerAlert: Bool
    let knownServers: [String]
    @Binding var newServerURL: String
    @State var addNewServer: () -> Void

    var body: some View {
        Menu {
            ForEach(knownServers, id: \.self) { url in
                Button(action: {
                    serverURL = url
                }) {
                    Text(url)
                }
            }

            Button(action: {
                showAddServerAlert = true
            }) {
                Text("➕ Add new server")
            }
        } label: {
            HStack {
                Text(serverURL.isEmpty ? "Server URL" : serverURL)
                    .foregroundColor(serverURL.isEmpty ? .gray : .primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
        }
        .alert("Add New Server", isPresented: $showAddServerAlert, actions: {
            TextField("Server URL", text: $newServerURL)
            Button("Add", action: addNewServer)
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Enter the full server URL.")
        })
    }
}
