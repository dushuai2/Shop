// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

// Based on https://github.com/luximetr/AnyFormatKit (MIT License)
// Based on commit: fe937c1e83574ad66f87f4a3eedc592440304077

import Foundation

class PatternFormatter: TextFormatter {
    /// String, that will use for formatting of string replacing patter symbol, example: patternSymbol - "#", format - "### (###) ###-##-##"
    let textPattern: String
    let replaceable: Character

    /// - Parameters:
    ///   - textPattern: example: `## ## ## #`
    ///   - replaceableCharacter: character, that will be replaced by input characters in textPattern
    init(textPattern: String, replaceableCharacter: Character) {
        self.textPattern = textPattern
        self.replaceable = replaceableCharacter
    }

    /// Formatting text with current textPattern
    /// - Parameter unformattedText: String, that need to be convert with current textPattern
    /// - Returns: formatted text with current textPattern
    func format(_ unformattedText: String, addTrailingPattern: Bool) -> String {
        var formatted = String()
        var unformattedIndex = 0
        var patternIndex = 0

        while patternIndex < textPattern.count {
            guard let patternCharacter = textPattern.characterAt(patternIndex) else { break }

            if unformattedIndex < unformattedText.count {
                if patternCharacter == replaceable {
                    // Current character needed to be replaced with data
                    if let unformattedCharacter = unformattedText.characterAt(unformattedIndex) {
                        formatted.append(unformattedCharacter)
                    }
                    unformattedIndex += 1
                } else {
                    // Append a pattern character (like " ")
                    formatted.append(patternCharacter)
                }
            } else {
                // Formatted all text, add trail until we meet next replaceable character
                // E.g. if pattern is ## ##, input is "22", we will add one space before next # to add a trail. Output will be "22 "
                if !addTrailingPattern { break }

                // Don't add trail after replaceable character is met
                if patternCharacter == replaceable { break }

                formatted.append(patternCharacter)
            }

            patternIndex += 1
        }

        return formatted
    }

    func unformat(_ formatted: String) -> String {
        let patternSymbolCharacterSet = CharacterSet(charactersIn: String(replaceable))
        let charactersToRemove = textPattern.remove(charactersIn: patternSymbolCharacterSet)
        let setToRemove = CharacterSet(charactersIn: charactersToRemove)

        return formatted.remove(charactersIn: setToRemove)
    }
}
