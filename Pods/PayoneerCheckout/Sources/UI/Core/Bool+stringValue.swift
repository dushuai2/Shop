// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Bool {
    var stringValue: String {
        return self ? "true" : "false"
    }
}

extension Bool {
    init?(stringValue: String) {
        switch stringValue {
        case "true": self = true
        case "false": self = false
        default: return nil
        }
    }
}
