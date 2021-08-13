// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

private extension CGFloat {
    static var cornerRadius: CGFloat { return 4 }
    static var buttonHeight: CGFloat { 44 }
}

extension Input.Table {
    class ButtonCell: UICollectionViewCell, DequeueableCell {
        private let button: UIButton
        var model: Input.Field.Button?

        weak var activityIndicator: UIActivityIndicatorView?

        private func setActivityIndicator(isAnimating: Bool) {
            if isAnimating {
                button.setAttributedTitle(nil, for: .normal)
                button.backgroundColor = button.tintColor.withAlphaComponent(0.6)

                let activityIndicator = UIActivityIndicatorView(style: .white)
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(activityIndicator)

                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor)
                ])

                activityIndicator.startAnimating()
            } else {
                button.backgroundColor = button.tintColor

                activityIndicator?.stopAnimating()
                activityIndicator?.removeFromSuperview()
                activityIndicator = nil

                if let model = self.model {
                    updateButtonTitle(model: model)
                }
            }
        }

        override init(frame: CGRect) {
            button = .init(frame: .zero)
            button.setTitleColor(.themedButtonTextColor, for: .normal)
            button.layer.cornerRadius = .cornerRadius
            button.clipsToBounds = true

            super.init(frame: frame)

            contentView.addSubview(button)

            button.translatesAutoresizingMaskIntoConstraints = false

            let buttonBottomConstraint = button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            buttonBottomConstraint.priority = .defaultHigh

            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: contentView.topAnchor),
                buttonBottomConstraint,
                button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: .buttonHeight)
            ])

            button.addTarget(self, action: #selector(buttonDidTap), for: .primaryActionTriggered)
         }

        @objc private func buttonDidTap() {
            guard let model = self.model else { return }
            model.buttonDidTap?(model)
        }

         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
    }
}

extension Input.Table.ButtonCell {
    func configure(with model: Input.Field.Button) {
        self.model = model
        button.backgroundColor = button.tintColor
        updateButtonTitle(model: model)
        setActivityIndicator(isAnimating: model.isActivityIndicatorAnimating)
        button.isEnabled = model.isEnabled
    }

    fileprivate func updateButtonTitle(model: Input.Field.Button) {
        let attributedString = NSAttributedString(
            string: model.label,
            attributes: [
                .font: UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .semibold),
                .foregroundColor: UIColor.themedButtonTextColor
            ]
        )

        button.setAttributedTitle(attributedString, for: .normal)
    }
}
