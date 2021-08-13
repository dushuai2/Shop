// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

class TranslatedModel<T> {
    let model: T
    let translator: TranslationProvider

    init(model: T, translator: TranslationProvider) {
        self.model = model
        self.translator = translator
    }
}
