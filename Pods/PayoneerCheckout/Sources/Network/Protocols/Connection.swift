// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Protocol responsible for sending requests, maybe faked when unit testing
protocol Connection {
    func send(request: URLRequest, completionHandler: @escaping ((Result<Data?, Error>) -> Void))
    static func isRecoverableError(_ error: Error) -> Bool
}
