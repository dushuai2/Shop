// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

struct TextFormatPattern {
    let textPattern: String
    let patternSymbol: Character

    init(textPattern: String, patternSymbol: Character = "#") {
        self.textPattern = textPattern
        self.patternSymbol = patternSymbol
    }
}
