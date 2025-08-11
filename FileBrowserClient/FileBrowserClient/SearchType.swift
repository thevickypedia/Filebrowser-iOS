//
//  SearchType.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 8/11/25.
//


enum SearchType: CaseIterable, Hashable {
    case files, image, music, video, pdf

    var iconName: String {
        switch self {
        case .files: return "doc"
        case .image: return "photo"
        case .music: return "speaker.wave.2"
        case .video: return "video"
        case .pdf: return "doc.text.fill"
        }
    }

    var queryPrefix: String? {
        switch self {
        case .files:
            return nil // No prefix for default "files" type
        case .image:
            return "type:image"
        case .music:
            return "type:audio"
        case .video:
            return "type:video"
        case .pdf:
            return "type:pdf"
        }
    }

    var displayName: String {
        String(describing: self)
    }
}
