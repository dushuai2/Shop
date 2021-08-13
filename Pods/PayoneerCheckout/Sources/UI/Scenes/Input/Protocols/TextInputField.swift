// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// UI model for all text input fields
protocol TextInputField: InputField {
    var translator: TranslationProvider { get }
    var label: String { get }
    var placeholder: String { get }
    var maxInputLength: Int? { get }
    var patternFormatter: InputPatternFormatter? { get }
    var allowedCharacters: CharacterSet? { get }
}

extension TextInputField {
    var patternFormatter: InputPatternFormatter? { nil }
}

extension TextInputField {
    var placeholder: String {
        translator.translation(forKey: translationPrefix + "placeholder")
    }

    var label: String {
        translator.translation(forKey: translationPrefix + "label")
    }

    var translationPrefix: String { "account." + name + "." }
}
