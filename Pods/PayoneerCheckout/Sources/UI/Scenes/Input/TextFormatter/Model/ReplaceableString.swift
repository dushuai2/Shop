// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

struct ReplaceableString {
    var originText: String
    var changesRange: NSRange
    var replacementText: String
}
