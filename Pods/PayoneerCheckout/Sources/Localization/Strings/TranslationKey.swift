// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

// TODO: Should be moved to a local json file
enum TranslationKey: String, CaseIterable {
    case errorInternetTitle = "messages.error.internet.title"
    case errorInternetText = "messages.error.internet.text"

    case cancelLabel = "button.cancel.label"
    case retryLabel = "button.retry.label"

    var localizedString: String {
        switch self {
        case .errorInternetTitle: return "Oops!"
        case .errorInternetText: return "There was a problem with your internet connection"
        case .retryLabel: return "Retry"
        case .cancelLabel: return "Cancel"
        }
    }
}
