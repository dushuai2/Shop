// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension Input.Field {
    /// Label with no user interaction and pre-set value.
    class Label {
        let label: String
        let name: String
        var value: String

        var isEnabled: Bool = true

        init(label: String, name: String, value: String) {
            self.label = label
            self.name = name
            self.value = value
        }
    }
}

extension Input.Field.Label: InputField, CellRepresentable {
    var cellType: (UICollectionViewCell & DequeueableCell).Type { Input.Table.LabelViewCell.self }

    func configure(cell: UICollectionViewCell) throws {
        guard let labelCell = cell as? Input.Table.LabelViewCell else { throw errorForIncorrectView(cell) }
        labelCell.configure(with: self)
    }
}
