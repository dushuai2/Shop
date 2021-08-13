// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Input.Field {
    /// Generic input field model that is used for all `localizableInputElements` that doesn't have explict type
    class Generic: BasicText, TextInputField {
        var maxInputLength: Int? { nil }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.Generic: CellRepresentable, DefinesKeyboardStyle {}
#endif
