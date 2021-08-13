// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit
import Foundation

extension Input {
    final class ImagesHeader {
        var networks: [Network] = .init()
        var isEnabled: Bool = true

        init() {}

        convenience init(for networks: [Input.Network]) {
            self.init()
            self.networks = networks
        }
    }
}

extension Input.ImagesHeader: CellRepresentable {
    var cellType: (UICollectionViewCell & DequeueableCell).Type { Input.Table.ImagesView.self }

    func configure(cell: UICollectionViewCell) {
        guard let imagesView = cell as? Input.Table.ImagesView else { return }
        imagesView.configure(with: self)
    }
}
