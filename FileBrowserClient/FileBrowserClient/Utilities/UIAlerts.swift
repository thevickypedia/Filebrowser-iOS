//
//  UIAlerts.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/27/25.
//

import SwiftUI

struct ToastMessagePayload {
    var text: String?
    var color: Color = .accentColor
    var duration: TimeInterval = 2.5
}

struct PreviewErrorPayload {
    var text: String
    var color: Color = .white
}
