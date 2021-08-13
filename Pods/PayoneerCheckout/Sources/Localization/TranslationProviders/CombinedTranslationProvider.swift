// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Translation provider that is used to combine multiple translations
class CombinedTranslationProvider {
    private let priorityTranslation: [String: String]
    private let otherProvider: TranslationProvider

    init(priorityTranslation: [String: String], otherProvider: TranslationProvider) {
        self.otherProvider = otherProvider
        self.priorityTranslation = priorityTranslation
    }
}

extension CombinedTranslationProvider: TranslationProvider {
    var translations: [[String: String]] {
        var resultingArray = [priorityTranslation]
        resultingArray.append(contentsOf: otherProvider.translations)
        return resultingArray
    }
}
