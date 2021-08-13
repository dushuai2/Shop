// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit
import Foundation

extension Input {
    final class TextHeader {
        let logo: UIImage?
        let label: String
        var detailedLabel: String?
        var isEnabled: Bool = true

        init(logo: UIImage?, label: String) {
            self.logo = logo
            self.label = label
        }

        /// Initializes header with transformed label and detailed label from `maskedAccount` data.
        convenience init(from registeredAccount: RegisteredAccount) {
            let label: String

            // Use custom transformation
            if let number = registeredAccount.apiModel.maskedAccount.number {
                // Expected input number format: `41 *** 1111`
                let maskedNumber = "•••• " + number.suffix(4)
                label = [registeredAccount.networkLabel, maskedNumber].joined(separator: " ")
                // Output: VISA •••• 1234
            } else if let iban = registeredAccount.apiModel.maskedAccount.iban {
                label = iban.prefix(2) + " •••• " + iban.suffix(2)
                // Output: DE •••• 24
            } else {
                // Fallback to server's display label
                label = registeredAccount.apiModel.maskedAccount.displayLabel ?? ""
            }

            self.init(logo: registeredAccount.logo?.value, label: label)

            if let expiryMonth = registeredAccount.apiModel.maskedAccount.expiryMonth, let expiryYear = registeredAccount.apiModel.maskedAccount.expiryYear {
                detailedLabel = String(format: "%02d", expiryMonth) + " / " + String(expiryYear).suffix(2)
            }
        }
    }
}

extension Input.TextHeader: CellRepresentable {
    var cellType: (UICollectionViewCell & DequeueableCell).Type {
        if detailedLabel == nil {
            return Input.Table.LogoTextView.self
        } else {
            return Input.Table.DetailedTextLogoView.self
        }
    }

    func configure(cell: UICollectionViewCell) throws {
        switch cell {
        case let view as Input.Table.LogoTextView: view.configure(with: self)
        case let view as Input.Table.DetailedTextLogoView: view.configure(with: self)
        default: throw errorForIncorrectView(cell)
        }
    }
}
