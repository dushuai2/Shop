// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Base request protocol that will be used for `Connection`.
protocol Request {
    associatedtype Response

    func decodeResponse(with data: Data?) throws -> Response
    func build() throws -> URLRequest
}

extension Request where Response == Data {
    func decodeResponse(with data: Data?) throws -> Response {
        guard let data = data else {
            let error = InternalError(description: "Server returned no data")
            throw error
        }

        return data
    }
}

extension Request where Response: Decodable {
    func decodeResponse(with data: Data?) throws -> Response {
        guard let data = data else {
            let error = InternalError(description: "Server returned no data")
            throw error
        }

        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension Request where Response == Void {
    func decodeResponse(with data: Data?) throws -> Response {
        return Void()
    }
}
