// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension Input.Table {
    class ImagesCollectionView: UICollectionView {
        override func reloadData() {
            super.reloadData()

            self.invalidateIntrinsicContentSize()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            invalidateIntrinsicContentSize()
        }

        override var intrinsicContentSize: CGSize {
            return collectionViewLayout.collectionViewContentSize
        }
    }
}
