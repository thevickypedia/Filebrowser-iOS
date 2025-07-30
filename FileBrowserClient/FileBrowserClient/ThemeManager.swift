//
//  ThemeManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/30/25.
//


import SwiftUI

class ThemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil // nil = system default
}
