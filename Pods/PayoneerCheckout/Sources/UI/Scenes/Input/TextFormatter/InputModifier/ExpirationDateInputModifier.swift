// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

class ExpirationDateInputModifier: InputModifier {
    func modify(replaceableString: inout ReplaceableString) {
        if replaceableString.originText == "0" && replaceableString.replacementText == "0" && replaceableString.changesRange.location == 1 {
            replaceableString.replacementText = ""
            return
        }

        // Help user only on initial input
        guard replaceableString.originText.isEmpty else { return }

        guard let firstCharacter = replaceableString.replacementText.first else { return }

        switch firstCharacter {
        case "0", "1": return
        default:
            replaceableString.replacementText.insert("0", at: replaceableString.replacementText.startIndex)
            replaceableString.changesRange = NSRange(location: replaceableString.changesRange.location, length: replaceableString.changesRange.length)
        }
    }
}
