// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import Foundation
import UIKit

extension List.Table {
    /// Cell with one image and one label.
    /// - Note: set `cellIndex`
    final class SingleLabelCell: List.Table.BorderedCell, DequeueableCell {
        weak var networkLabel: UILabel?
        weak var networkLogoView: UIImageView?

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

extension List.Table.SingleLabelCell {
    fileprivate func addContentViews() {
        let networkLabel = UILabel(frame: .zero)
        networkLabel.translatesAutoresizingMaskIntoConstraints = false
        networkLabel.font = UIFont.preferredThemeFont(forTextStyle: .body)
        networkLabel.textColor = .themedText
        customContentView.addSubview(networkLabel)
        self.networkLabel = networkLabel

        let networkLogoView = UIImageView(image: nil)
        networkLogoView.translatesAutoresizingMaskIntoConstraints = false
        networkLogoView.contentMode = .scaleAspectFit
        customContentView.addSubview(networkLogoView)
        self.networkLogoView = networkLogoView

        NSLayoutConstraint.activate([
            networkLabel.topAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.topAnchor, constant: .defaultSpacing),
            networkLabel.bottomAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.bottomAnchor, constant: -.defaultSpacing),
            networkLabel.trailingAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.trailingAnchor),

            networkLogoView.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 2 * .defaultSpacing),
            networkLogoView.topAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.topAnchor),
            networkLogoView.bottomAnchor.constraint(equalTo: customContentView.layoutMarginsGuide.bottomAnchor),
            networkLogoView.widthAnchor.constraint(equalToConstant: .imageWidth),
            networkLogoView.trailingAnchor.constraint(equalTo: networkLabel.leadingAnchor, constant: -2 * CGFloat.defaultSpacing)
        ])

        networkLogoView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        networkLogoView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

// MARK: - Constants

private extension CGFloat {
    static var imageWidth: CGFloat { return 50 }
    static var defaultSpacing: CGFloat { return 8 }
}
#endif
