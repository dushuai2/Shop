// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

// MARK: - Request

/// Request for `CHARGE` operation.
struct ChargeRequest: PostRequest {
    let url: URL
    let queryItems = [URLQueryItem]()
    let body: Body?

    var operationType: String { url.lastPathComponent }

    typealias Response = OperationResult

    /// - Parameter url: value from `links.operation` for charge operation
    init(from url: URL, body: Body) {
        self.url = url
        self.body = body
    }
}

// MARK: - Body

extension ChargeRequest {
    struct Body: Encodable {
        var account = [String: String]()
        var autoRegistration: Bool?
        var allowRecurrence: Bool?
        let browserData: BrowserData

        /// - Parameter inputFields: dictionary with input fields of `CHARGE` request
        init(inputFields: [String: String]) {
            for (name, value) in inputFields {
                switch name {
                case Input.Field.Checkbox.Constant.allowRegistration: autoRegistration = Bool(stringValue: value)
                case Input.Field.Checkbox.Constant.allowRecurrence: allowRecurrence = Bool(stringValue: value)
                default: account[name] = value
                }
            }

            self.browserData = BrowserDataBuilder.build()
        }
    }
}
