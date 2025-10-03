//
//  Request.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 10/2/25.
//

import Foundation

struct PreparedRequest {
    var session: URLSession
    var request: URLRequest
}

enum RequestMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case head = "HEAD"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ContentType: String {
    case json = "application/json"
    case octet = "application/offset+octet-stream"
}

struct RequestTimeout {
    let request: Double
    let resource: Double
}

class Request {
    // Entire auth object: serverURL, and token
    let auth: AuthManager?
    // TODO: Move base and fullUrls to prepare func, so functions can be modified with one State level instantiation
    // Base URL with hostname: serverURL
    let baseUrl: String?
    // Fully constructed URL
    let fullUrl: URL?

    init(auth: AuthManager? = nil, baseUrl: String? = nil, fullUrl: URL? = nil) {
        self.auth = auth
        self.baseUrl = baseUrl
        self.fullUrl = fullUrl
        if self.auth == nil && self.baseUrl == nil && self.fullUrl == nil {
            Log.error("Request was instanitiated without any URLs")
            // TODO: Throw an error
        }
    }

    private func urlJoin(url: String, path: String) -> String {
        if url.hasSuffix("/") {
            return url + path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }
        return url + "/" + path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }

    func error(url: URL? = nil, path: String? = nil) -> String {
        if let url = url {
            return "Failed to prepare request for: \(urlPath(url))"
        } else if let path = path {
            return "Failed to prepare request for: \(path)"
        }
        return "Failed to prepare request."
    }

    func prepare(
        path: String = "",
        method: RequestMethod = RequestMethod.get,
        contentType: ContentType = ContentType.json,
        timeout: RequestTimeout = RequestTimeout(request: 3.0, resource: 5.0)
    ) -> PreparedRequest? {
        if path.isEmpty {
            guard fullUrl != nil else {
                Log.error("Insufficient: Neither path, nor fullUrl was receved")
                return nil
            }
        }
        var requestURL: String
        var finalURL: URL
        // If fullUrl is received, no further modifications are required
        if let url = fullUrl {
            finalURL = url
        } else {
            if let url = baseUrl {
                requestURL = urlJoin(url: url, path: path)
            } else if let auth = auth {
                requestURL = urlJoin(url: auth.serverURL, path: path)
            } else {
                return nil
            }
            guard let url = URL(string: requestURL) else {
                Log.error("Invalid URL - \(requestURL)")
                return nil
            }
            finalURL = url
        }

        // Create a custom session with timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout.request
        config.timeoutIntervalForResource = timeout.resource
        let session = URLSession(configuration: config)

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        if let auth = auth, !auth.token.isEmpty {
            request.setValue(auth.token, forHTTPHeaderField: "X-Auth")
        }
        return PreparedRequest(session: session, request: request)
    }
}
