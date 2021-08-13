// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import UIKit

/// Controls keyboard's appearance
protocol DefinesKeyboardStyle where Self: TextInputField {
    var contentType: UITextContentType? { get }
    var keyboardType: UIKeyboardType { get }
    var autocapitalizationType: UITextAutocapitalizationType { get }
}

extension DefinesKeyboardStyle where Self: TextInputField {
    var contentType: UITextContentType? { nil }
    var autocapitalizationType: UITextAutocapitalizationType { .none }
}

extension DefinesKeyboardStyle where Self: InputElementModel {
    var keyboardType: UIKeyboardType {
        switch inputElement.inputElementType {
        case .some(.numeric): return .numbersAndPunctuation
        case .some(.integer): return .numberPad
        default: return .default
        }
    }

    var allowedCharacters: CharacterSet? {
        switch inputElement.inputElementType {
        case .some(.integer): return .decimalDigits
        case .some(.numeric):
            var set = CharacterSet.decimalDigits
            set.insert(charactersIn: " -")
            return set
        default: return nil
        }
    }
}

#endif
