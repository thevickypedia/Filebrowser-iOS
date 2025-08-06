//
//  FileListAlerts.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/6/25.
//

import SwiftUI

struct ErrorAlert: ViewModifier {
    @Binding var title: String?
    @Binding var message: String?

    func body(content: Content) -> some View {
        content.alert(title ?? "Network Error", isPresented: .constant(message != nil)) {
            Button("OK") { message = nil }
        } message: {
            Text(message ?? "")
        }
    }
}

// todo: Move all alerts here
// struct CreateFileAlert: ViewModifier {
//    @Binding var showingCreateFileAlert: Bool
//    @Binding var newResourceName: String
//    var createAction: () -> Void
//
//    func body(content: Content) -> some View {
//        content.alert("Create New File", isPresented: $showingCreateFileAlert) {
//            TextField("Filename", text: $newResourceName)
//            Button("Create", action: createAction)
//            Button("Cancel", role: .cancel) { }
//        }
//    }
// }
