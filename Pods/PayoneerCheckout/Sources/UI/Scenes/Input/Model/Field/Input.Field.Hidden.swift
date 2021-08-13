// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension Input.Field {
    /// Label with no user interaction and pre-set value.
    class Hidden {
        let name: String
        var value: String

        init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
}

extension Input.Field.Hidden: InputField {}
