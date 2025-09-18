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

struct CreateFileAlert: ViewModifier {
    @Binding var createFile: Bool
    @Binding var fileName: String
    var action: () -> Void

    func body(content: Content) -> some View {
        content.alert("Create New File", isPresented: $createFile) {
            TextField("Filename", text: $fileName)
            Button("Create", action: action)
            Button("Cancel", role: .cancel) { }
        }
    }
 }

struct CreateFolderAlert: ViewModifier {
    @Binding var createFolder: Bool
    @Binding var folderName: String
    var action: () -> Void

    func body(content: Content) -> some View {
        content.alert("Create New Folder", isPresented: $createFolder) {
            TextField("Folder Name", text: $folderName)
            Button("Create", action: action)
            Button("Cancel", role: .cancel) { }
        }
    }
 }

struct DeleteConfirmAlert: ViewModifier {
    @Binding var isPresented: Bool
    var selectedCount: Int
    var deleteAction: () -> Void

    func body(content: Content) -> some View {
        content.alert("Delete Selected?", isPresented: $isPresented) {
            Button("Delete", role: .destructive, action: deleteAction)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete \(selectedCount) items?")
        }
    }
}

struct RenameAlert: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var renameInput: String
    var renameAction: () -> Void

    func body(content: Content) -> some View {
        content.alert("Rename", isPresented: $isPresented) {
            TextField("New name", text: $renameInput)
            Button("Rename", action: renameAction)
            Button("Cancel", role: .cancel) {}
        }
    }
}
