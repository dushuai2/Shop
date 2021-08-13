// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Input.Field {
    final class BIC: BasicText {}
}

extension Input.Field.BIC: TextInputField {}

extension Input.Field.BIC: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_BIC")
        case .missingValue: return translator.translation(forKey: "error.MISSING_BIC")
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.BIC: CellRepresentable, DefinesKeyboardStyle {}
#endif
