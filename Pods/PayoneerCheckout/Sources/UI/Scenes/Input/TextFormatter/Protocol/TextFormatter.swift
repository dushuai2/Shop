// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

// Based on https://github.com/luximetr/AnyFormatKit (MIT License)
// Based on commit: fe937c1e83574ad66f87f4a3eedc592440304077

import Foundation

protocol TextFormatter {
    func format(_ unformattedText: String, addTrailingPattern: Bool) -> String

    /// Remove format pattern from the text. All characters specified in `formatPattern` (except `patternSymbol`) will be removed.
    func unformat(_ formattedText: String) -> String
}
