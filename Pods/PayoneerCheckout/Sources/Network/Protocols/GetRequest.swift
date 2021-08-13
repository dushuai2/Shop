// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Simple request that just performs `GET` request on specified URL.
/// - Note: `queryItems` will always override items from the `url`
protocol GetRequest: Request {
    var queryItems: [URLQueryItem] { get }
    var url: URL { get }
}

extension GetRequest {
    func build() throws -> URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw InternalError(description: "Internal error, incorrect GetRequest URL")
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw InternalError(description: "Internal error, unable to create API request URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.GET.rawValue

        return urlRequest
    }
}
