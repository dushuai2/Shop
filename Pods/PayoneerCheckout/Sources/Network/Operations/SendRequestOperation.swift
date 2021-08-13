// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

// MARK: - Constants

private extension String {
    static var httpVendorHeader: String { "application/vnd.optile.payment.enterprise-v1-extensible+json" }
}

// MARK: - SendRequestOperation

class SendRequestOperation<T>: AsynchronousOperation where T: Request {
    let connection: Connection
    let request: T
    var downloadCompletionBlock: ((Result<T.Response, Error>) -> Void)?

    private(set) var result: Result<T.Response, Error>?

    init(connection: Connection, request: T) {
        self.connection = connection
        self.request = request
        super.init()
    }

    override func main() {
        var urlRequest: URLRequest

        do {
            urlRequest = try request.build()
        } catch {
            self.finish(with: .failure(error))
            return
        }

        let userAgentValue = UserAgentBuilder().createUserAgentValue()
        urlRequest.addValue(userAgentValue, forHTTPHeaderField: "User-Agent")

        urlRequest.addValue(.httpVendorHeader, forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(.httpVendorHeader, forHTTPHeaderField: "Accept")

        connection.send(request: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedResponse = try self.request.decodeResponse(with: data)
                    self.finish(with: .success(decodedResponse))
                } catch {
                    self.finish(with: .failure(error))
                }
            case .failure(let error):
                self.finish(with: .failure(error))
            }
        }
    }

    private func finish(with result: Result<T.Response, Error>) {
        self.result = result
        downloadCompletionBlock?(result)
        finish()
    }
}
