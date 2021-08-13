// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

private extension CGFloat {
    static let logoWidth: CGFloat = 40
    static let imageLabelSpacing: CGFloat = 16
}

extension Input.Table {
    class DetailedTextLogoView: UICollectionViewCell, DequeueableCell {
        private let label: UILabel
        private let detailedLabel: UILabel
        private let logoView: UIImageView

        override init(frame: CGRect) {
            label = .init(frame: .zero)
            detailedLabel = .init(frame: .zero)
            logoView = .init(frame: .zero)

            super.init(frame: frame)

            // FIXME: Return checkmark
//            self.accessoryType = .checkmark

            label.font = UIFont.preferredThemeFont(forTextStyle: .body)
            label.lineBreakMode = .byTruncatingMiddle
            detailedLabel.font = UIFont.preferredThemeFont(forTextStyle: .footnote)
            label.textColor = .themedText
            detailedLabel.textColor = .themedText

            self.addSubview(label)
            self.addSubview(detailedLabel)
            self.addSubview(logoView)

            label.translatesAutoresizingMaskIntoConstraints = false
            detailedLabel.translatesAutoresizingMaskIntoConstraints = false

            logoView.translatesAutoresizingMaskIntoConstraints = false
            logoView.contentMode = .scaleAspectFit
            logoView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: .imageLabelSpacing),
                label.topAnchor.constraint(equalTo: self.topAnchor),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor),

                detailedLabel.topAnchor.constraint(equalTo: label.bottomAnchor),
                detailedLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                detailedLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                detailedLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

                logoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                logoView.topAnchor.constraint(equalTo: label.topAnchor),
                logoView.bottomAnchor.constraint(equalTo: detailedLabel.bottomAnchor),
                logoView.widthAnchor.constraint(equalToConstant: .logoWidth)
            ])
         }

         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
    }
}

extension Input.Table.DetailedTextLogoView {
    func configure(with model: Input.TextHeader) {
        logoView.image = model.logo
        label.text = model.label
        detailedLabel.text = model.detailedLabel
    }
}
