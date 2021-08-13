// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Input.Field {
    final class BankCode: BasicText {}
}

extension Input.Field.BankCode: TextInputField {}

extension Input.Field.BankCode: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_BANK_CODE")
        case .missingValue: return translator.translation(forKey: "error.MISSING_BANK_CODE")
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.BankCode: CellRepresentable, DefinesKeyboardStyle {}
#endif
