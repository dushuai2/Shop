// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Error {
    /// Returns NSError if `Self` is a retryable network error, otherwhise returns `nil`.
	var asNetworkError: NSError? {
		let nsError = self as NSError

		let allowedCodes: [URLError.Code] = [.notConnectedToInternet, .dataNotAllowed]
		let allowedCodesNumber = allowedCodes.map { $0.rawValue }
		if nsError.domain == NSURLErrorDomain, allowedCodesNumber.contains(nsError.code) {
			return nsError
		} else {
			return nil
		}
	}
}
