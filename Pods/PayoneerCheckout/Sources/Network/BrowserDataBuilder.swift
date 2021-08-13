// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

class BrowserDataBuilder {
    static func build() -> BrowserData {
        let size = UIScreen.main.bounds
        let colorDepth = 32 // colorDepth is always 32 bit for now for Apple products and it can't be obtained from a system
        let timeZone = TimeZone.current.identifier
        let language = Locale.current.languageCode

        return .init(javaEnabled: false, language: language, colorDepth: colorDepth, timezone: timeZone, browserScreenHeight: Int(size.height), browserScreenWidth: Int(size.width))
    }
}

struct BrowserData: Encodable {
    var javaEnabled: Bool
    var language: String?
    var colorDepth: Int
    var timezone: String
    var browserScreenHeight: Int
    var browserScreenWidth: Int
}
