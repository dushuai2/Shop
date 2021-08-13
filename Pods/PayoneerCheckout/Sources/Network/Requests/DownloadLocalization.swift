// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

// MARK: - Request

/// Gets active LIST session details
///
/// Retrieves available payment capabilities for active `LIST` session.
struct DownloadLocalization: GetRequest {
    var url: URL
    let queryItems = [URLQueryItem]()
    typealias Response = [String: String]

    /// - Parameter url: `self` link from payment session
    init(from url: URL) {
        self.url = url
    }
}
