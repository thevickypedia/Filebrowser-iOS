//
//  Error.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 10/10/25.
//

import Network
import UniformTypeIdentifiers

extension Error {
    var isNetworkError: Bool {
        let nsError = self as NSError
        // Network-related error domains
        let networkErrorDomains = [
            NSURLErrorDomain,
            kCFErrorDomainCFNetwork as String
        ]
        if networkErrorDomains.contains(nsError.domain) {
            // Specific network error codes that are resumable
            let resumableErrorCodes = [
                NSURLErrorNetworkConnectionLost,
                NSURLErrorNotConnectedToInternet,
                NSURLErrorTimedOut,
                NSURLErrorCannotConnectToHost,
                NSURLErrorDataNotAllowed,
                NSURLErrorCallIsActive
            ]
            return resumableErrorCodes.contains(nsError.code)
        }
        return false
    }
}
