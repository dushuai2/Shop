// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Simple request that just performs `POST` request on specified URL.
/// - Note: `queryItems` will always override items from the `url`
protocol PostRequest: Request {
    associatedtype Body

    var queryItems: [URLQueryItem] { get }
    var url: URL { get }
    var body: Body? { get }
    
    func encodeBody() throws -> Data?
}

extension PostRequest where Body: Encodable {
    func encodeBody() throws -> Data? {
        guard let body = self.body else { return nil }
        let encoder = JSONEncoder()
        return try encoder.encode(body)
    }
}

extension PostRequest {
    func build() throws -> URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw InternalError(description: "Internal error, incorrect PostRequest URL: %@", url.absoluteString)
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw InternalError(description: "Internal error, unable to create API request URL from URLComponents")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.POST.rawValue
        urlRequest.httpBody = try encodeBody()

        return urlRequest
    }
}
