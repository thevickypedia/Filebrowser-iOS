//
//  AppThemeManager.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 7/20/25.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil // nil = system default
}
