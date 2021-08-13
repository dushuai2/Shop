// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import Foundation
import UIKit

extension List.Table {
    /// Cell with multiple images, primary and secondary labels.
    /// - Note: set `cellIndex`
    final class DetailedLabelCell: List.Table.BorderedCell, DequeueableCell {
        weak var primaryLabel: UILabel?
        weak var secondaryLabel: UILabel?
        weak var logoView: UIImageView?

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            addContentViews()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - Content views

extension List.Table.DetailedLabelCell {
    fileprivate func addContentViews() {
        let primaryLabel = UILabel(frame: .zero)
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.font = UIFont.preferredThemeFont(forTextStyle: .body)
        primaryLabel.textColor = .themedText
        customContentView.addSubview(primaryLabel)
        self.primaryLabel = primaryLabel

        let secondaryLabel = UILabel(frame: .zero)
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = UIFont.preferredThemeFont(forTextStyle: .footnote)
        secondaryLabel.textColor = .themedDetailedText
        customContentView.addSubview(secondaryLabel)
        self.secondaryLabel = secondaryLabel

        let logoView = UIImageView(frame: .zero)
        logoView.tintColor = .themedDetailedText
        logoView.contentMode = .scaleAspectFill
        logoView.translatesAutoresizingMaskIntoConstraints = false
        customContentView.addSubview(logoView)
        self.logoView = logoView

        // Layout

        NSLayoutConstraint.activate([
            primaryLabel.topAnchor.constraint(greaterThanOrEqualTo: customContentView.layoutMarginsGuide.topAnchor),
            primaryLabel.bottomAnchor.constraint(equalTo: customContentView.centerYAnchor, constant: .verticalSpacing / -4),
            primaryLabel.trailingAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.trailingAnchor),

            secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.leadingAnchor),
            secondaryLabel.topAnchor.constraint(equalTo: customContentView.centerYAnchor, constant: .verticalSpacing / 4),
            secondaryLabel.bottomAnchor.constraint(greaterThanOrEqualTo: customContentView.layoutMarginsGuide.bottomAnchor),
            secondaryLabel.trailingAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.trailingAnchor),

            logoView.leadingAnchor.constraint(equalTo: leftBorder.leadingAnchor, constant: 2 * CGFloat.defaultSpacing),
            logoView.topAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.topAnchor),
            logoView.bottomAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.bottomAnchor),
            logoView.trailingAnchor.constraint(equalTo: primaryLabel.leadingAnchor, constant: -2 * CGFloat.defaultSpacing),
            logoView.widthAnchor.constraint(equalToConstant: .imageWidth)
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    static var imageWidth: CGFloat { return 50 }
    static var defaultSpacing: CGFloat { return 8 }
    static var verticalSpacing: CGFloat { return 4 }
}
#endif
