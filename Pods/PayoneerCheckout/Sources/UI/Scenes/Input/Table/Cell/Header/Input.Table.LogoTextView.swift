// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import UIKit

private extension CGFloat {
    static let logoWidth: CGFloat = 40
    static let imageLabelSpacing: CGFloat = 16
}

extension Input.Table {
    class LogoTextView: UICollectionViewCell, DequeueableCell {
        private let label: UILabel
        private let logoView: UIImageView

        override init(frame: CGRect) {
            label = .init(frame: frame)
            logoView = .init(frame: frame)

            super.init(frame: frame)

            // FIXME: Add a checkmark for a view
//            self.accessoryType = .checkmark

            label.font = UIFont.preferredThemeFont(forTextStyle: .body)

            self.addSubview(label)
            self.addSubview(logoView)

            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .themedText
            label.lineBreakMode = .byTruncatingMiddle
            logoView.translatesAutoresizingMaskIntoConstraints = false
            logoView.contentMode = .scaleAspectFit

            logoView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor),

                logoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                logoView.topAnchor.constraint(equalTo: label.topAnchor),
                logoView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
                logoView.widthAnchor.constraint(equalToConstant: .logoWidth),

                label.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: .imageLabelSpacing)
            ])
         }

         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
    }
}

extension Input.Table.LogoTextView {
    func configure(with model: Input.TextHeader) {
        logoView.image = model.logo
        label.text = model.label
    }
}
#endif
