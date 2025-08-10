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
                        .lineLimit(1) // force single line
                        .truncationMode(.tail) // middle truncation for long URLs
                }
            }

            Button(action: {
                showAddServerAlert = true
            }) {
                Label("Add new server", systemImage: "plus")
                    .lineLimit(1)
            }
        } label: {
            HStack {
                Text(serverURL.isEmpty ? "Server URL" : serverURL)
                    .foregroundColor(serverURL.isEmpty ? .gray : .primary)
                    .lineLimit(1) // force single line
                    .truncationMode(.tail)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
        }
        // Using .sheet instead of .alert to allow for a custom form
        .sheet(isPresented: $showAddServerAlert) {
            VStack {
                Text("Add New Server")
                    .font(.title2)
                    .padding()

                TextField("Server URL", text: $newServerURL)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Add", action: {
                    addNewServer()
                    showAddServerAlert = false // Dismiss sheet
                })
                .padding()
                .buttonStyle(.borderedProminent)

                Button("Cancel", role: .cancel) {
                    showAddServerAlert = false // Dismiss sheet
                }
                .padding()
            }
            .padding()
            .presentationDetents([.fraction(0.3)]) // 30% of the screen height
        }
    }
}
