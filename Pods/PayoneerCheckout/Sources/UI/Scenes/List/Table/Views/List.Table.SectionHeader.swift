// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import UIKit

extension List.Table {
    class SectionHeader: UIView {
        weak var textLabel: UILabel?

        override init(frame: CGRect) {
            super.init(frame: frame)

            self.preservesSuperviewLayoutMargins = true

            let textLabel = UILabel(frame: frame)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.textColor = Theme.shared.textColor
            textLabel.font = UIFont.preferredThemeFont(forTextStyle: .footnote)

            addSubview(textLabel)
            self.textLabel = textLabel

            NSLayoutConstraint.activate([
                textLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                textLabel.topAnchor.constraint(equalTo: self.topAnchor),
                textLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
                textLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

private extension CGFloat {
    static var topPadding: CGFloat { return 30 }
}
#endif
