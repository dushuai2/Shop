// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Input.Field.Validation {
    struct ExpiryDate {
        /// Return information if date is in future
        /// - Returns: nil if unable to construct a date
        static func isInFuture(expiryMonth: Int, expiryYear: Int) -> Bool? {
            var components = DateComponents()
            components.month = expiryMonth
            components.year = expiryYear

            let calendar = Calendar.current
            guard let expiryDate = calendar.date(from: components) else { return nil }

            let result = calendar.compare(expiryDate, to: Date(), toGranularity: .month)

            switch result {
            case .orderedAscending:
                // expiryDate is in the past
                return false
            default:
                // expiryDate is the same or in future
                return true
            }
        }
    }
}
