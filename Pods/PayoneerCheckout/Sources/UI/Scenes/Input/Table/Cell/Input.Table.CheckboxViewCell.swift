// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import UIKit

private struct UIConstant {
    static let defaultSpacing: CGFloat = 8
}

extension Input.Table {
    /// Cell that represents a checkbox (UISwitch).
    /// Upon some actions calls `delegate`, don't forget to set it.
    ///
    /// - Warning: after initialization before using you have to set `indexPath` to cell's indexPath
    class CheckboxViewCell: UICollectionViewCell, DequeueableCell {
        weak var delegate: InputCellDelegate?

        private let label: UILabel
        let checkbox: UISwitch

        override init(frame: CGRect) {
            label = .init(frame: .zero)
            checkbox = .init(frame: .zero)

            super.init(frame: frame)

            // Configure label
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.textColor = .themedText
            label.font = UIFont.preferredThemeFont(forTextStyle: .body)

            // Configure checkbox
            checkbox.addTarget(self, action: #selector(checkboxValueChanged), for: .valueChanged)

            // Layout
            contentView.addSubview(label)
            contentView.addSubview(checkbox)

            label.translatesAutoresizingMaskIntoConstraints = false
            checkbox.translatesAutoresizingMaskIntoConstraints = false

            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            checkbox.setContentHuggingPriority(.defaultLow, for: .vertical)

            let bottomLabelConstraint = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            bottomLabelConstraint.priority = .defaultHigh

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: checkbox.leadingAnchor, constant: -UIConstant.defaultSpacing),
                bottomLabelConstraint,
                label.topAnchor.constraint(equalTo: contentView.topAnchor),

                checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                checkbox.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
                checkbox.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor)
            ])
        }

        @objc private func checkboxValueChanged(_ sender: UISwitch) {
            delegate?.inputCellValueDidChange(to: checkbox.isOn.stringValue, cell: self)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - Cell configuration

extension Input.Table.CheckboxViewCell {
    func configure(with model: Input.Field.Checkbox) {
        label.text = model.label
        checkbox.isOn = model.isOn
        checkbox.onTintColor = self.tintColor
        checkbox.isEnabled = model.isEnabled
    }
}

extension Input.Table.CheckboxViewCell: ContainsInputCellDelegate {}
#endif
