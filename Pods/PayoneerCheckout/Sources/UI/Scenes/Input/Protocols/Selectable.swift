// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

protocol Selectable {
    var isSelected: Bool { get }
}

extension Sequence where Element: Selectable {
    /// Returns first selected item (`isSelected = true`)
    func firstSelection() -> Element? {
        for element in self where element.isSelected {
            return element
        }

        return nil
    }
}
