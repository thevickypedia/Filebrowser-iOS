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

struct RequestHeader {
    let key: String
    let value: String
}

func buildAPIURL(baseURL: String, pathComponents: [String], queryItems: [URLQueryItem]? = nil) -> URL? {
    guard var url = URL(string: baseURL) else { return nil }

    for component in pathComponents {
        url = url.appendingPathComponent(component.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
    }

    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    if let qItems = queryItems {
        components?.queryItems = qItems
    }

    return components?.url
}

private func urlJoin(url: String, path: String) -> String {
    if url.hasSuffix("/") {
        return url + path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
    return url + "/" + path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
}

class Request {
    let baseURL: String
    let token: String

    init(baseURL: String, token: String) {
        self.baseURL = baseURL
        self.token = token
    }

    func prepare(
        pathComponents: [String],
        queryItems: [URLQueryItem]? = nil,
        method: RequestMethod = .get,
        headers: [RequestHeader]? = nil,
        contentType: ContentType = ContentType.json,
        timeout: RequestTimeout = RequestTimeout(request: 3.0, resource: 5.0)
    ) -> PreparedRequest? {
        var requestURL: URL
        // Assumes as a pre-built URL path component
        if pathComponents.count == 1, let firstComponent = pathComponents.first, firstComponent.starts(with: "/api/") {
            guard let builtURL = URL(string: urlJoin(url: self.baseURL, path: pathComponents.first!)) else { return nil }
            requestURL = builtURL
        } else {
            guard let builtURL = buildAPIURL(
                baseURL: self.baseURL,
                pathComponents: pathComponents,
                queryItems: queryItems
            ) else { return nil }
            requestURL = builtURL
        }

        // Create a custom session with timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout.request
        config.timeoutIntervalForResource = timeout.resource
        let session = URLSession(configuration: config)

        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        if !token.isEmpty {
            request.setValue(token, forHTTPHeaderField: "X-Auth")
        }
        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        return PreparedRequest(session: session, request: request)
    }
}
