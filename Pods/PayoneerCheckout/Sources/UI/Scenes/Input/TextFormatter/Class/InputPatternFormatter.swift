// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

// Based on https://github.com/luximetr/AnyFormatKit (MIT License)
// Based on commit: fe937c1e83574ad66f87f4a3eedc592440304077

import Foundation

class InputPatternFormatter {
    let formatter: PatternFormatter
    var inputModifiers = [InputModifier]()
    var shouldAddTrailingPattern: Bool = false

    private let caretPositionCorrector: CaretPositionCorrector

    /// - Parameters:
    ///   - textPattern: string with special characters, that will be used for formatting (e.g. `### ##`)
    ///   - patternSymbol: parameter, that represent character, that will be replaced in formatted string
    init(formatter: PatternFormatter) {
        self.formatter = formatter
        self.caretPositionCorrector = CaretPositionCorrector(textPattern: formatter.textPattern, patternSymbol: formatter.replaceable)
    }

    convenience init(textPattern: String, replaceableCharacter: Character = "#") {
        let formatter = PatternFormatter(textPattern: textPattern, replaceableCharacter: replaceableCharacter)
        self.init(formatter: formatter)
    }

    /// - WARNING: Don't use `#` as separator
    convenience init(maxStringLength: Int, separator: String, every n: Int) {
        let replaceableCharacter: Character = "#"
        var pattern = String()
        for _ in 1...maxStringLength {
            pattern += String(replaceableCharacter)
        }

        pattern.insert(separator: separator, every: n)

        self.init(textPattern: pattern, replaceableCharacter: replaceableCharacter)
    }

    func formatInput(replaceableString: ReplaceableString) -> FormattedTextValue {
        var modifiedInput = replaceableString
        for modifier in inputModifiers {
            modifier.modify(replaceableString: &modifiedInput)
        }

        let unformattedRange = self.unformattedRange(from: modifiedInput.changesRange)
        let oldUnformattedText = formatter.unformat(modifiedInput.originText) as NSString

        let newText = oldUnformattedText.replacingCharacters(in: unformattedRange, with: formatter.unformat(modifiedInput.replacementText))

        let shouldAddTrailingCharacters = self.shouldAddTrailingCharacters(for: modifiedInput)

        let formattedText = formatter.format(newText, addTrailingPattern: shouldAddTrailingCharacters)

        // Offset calculations
        let caretOffset: Int
        if modifiedInput.originText.count == modifiedInput.changesRange.upperBound {
            // If caret was at the end keep it in the end
            caretOffset = formattedText.count
        } else {
            caretOffset = getCorrectedCaretPosition(range: modifiedInput.changesRange, replacementString: modifiedInput.replacementText)
        }

        return FormattedTextValue(formattedText: formattedText, caretBeginOffset: caretOffset)
    }

    private func shouldAddTrailingCharacters(for replaceableString: ReplaceableString) -> Bool {
        guard self.shouldAddTrailingPattern else { return false }

        // Character was inserted, trail should be shown
        if !replaceableString.replacementText.isEmpty { return true }

        // Text is about to be deleted
        if let patternCharacter = formatter.textPattern.characterAt(replaceableString.changesRange.lowerBound), patternCharacter != formatter.replaceable {
            // User tries to remove a formatting pattern character, we allow to do that if user at the end of a string
            return false
        } else {
            // User deleted a data character, we will keep a trail
            return true
        }
    }

    /// Convert range in formatted string to range in unformatted string
    /// - Parameter range: range in formatted (with current textPattern) string
    /// - Returns: range in unformatted (with current textPattern) string
    func unformattedRange(from range: NSRange) -> NSRange {
        let newRange = NSRange(
            location: range.location - formatter.textPattern[..<formatter.textPattern.index(formatter.textPattern.startIndex, offsetBy: range.location)]
                .replacingOccurrences(of: String(formatter.replaceable), with: "").count,
            length: range.length - (formatter.textPattern as NSString).substring(with: range)
                .replacingOccurrences(of: String(formatter.replaceable), with: "").count)
        return newRange
    }

    private func getCorrectedCaretPosition(range: NSRange, replacementString: String) -> Int {
        let offset = caretPositionCorrector.calculateCaretPositionOffset(originalRange: range, replacementFiltered: replacementString)
        return offset
    }
}

// MARK: - String extensions

private extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

private extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.dropFirst().reversed()
            where distance(to: index).isMultiple(of: n) {
            insert(contentsOf: separator, at: index)
        }
    }

    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: n)
        return string
    }
}
