// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit
import Foundation

extension Input.Field {
    final class Button {
        let label: String

        var buttonDidTap: ((Button) -> Void)?
        var isEnabled: Bool = true
        var isActivityIndicatorAnimating: Bool = false

        init(label: String) {
            self.label = label
        }
    }
}

extension Input.Field.Button: CellRepresentable {
    var cellType: (UICollectionViewCell & DequeueableCell).Type { Input.Table.ButtonCell.self }

    func configure(cell: UICollectionViewCell) throws {
        guard let buttonCell = cell as? Input.Table.ButtonCell else { throw errorForIncorrectView(cell) }
        buttonCell.configure(with: self)
    }
}
