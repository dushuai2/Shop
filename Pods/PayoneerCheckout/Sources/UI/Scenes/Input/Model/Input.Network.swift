// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension Input {
    class Network {
        let operationURL: URL

        /// Indicates payment method this network belongs to.
        let paymentMethod: String?

        let translation: TranslationProvider
        let switchRule: SmartSwitch.Rule?
        let networkCode: String

        let uiModel: UIModel

        init(operationURL: URL, paymentMethod: String?, networkCode: String, translator: TranslationProvider, switchRule: SmartSwitch.Rule?, uiModel: UIModel) {
            self.operationURL = operationURL
            self.paymentMethod = paymentMethod
            self.networkCode = networkCode
            self.translation = translator
            self.switchRule = switchRule
            self.uiModel = uiModel
        }
    }
}

extension Input.Network: Equatable {
    static func == (lhs: Input.Network, rhs: Input.Network) -> Bool {
        return lhs.networkCode == rhs.networkCode
    }
}

extension Input.Network {
    class UIModel {
        let label: String
        let logo: UIImage?
        let inputFields: [InputField]

        /// Checkboxes that must be arranged in another section (used for recurrence and registration)
        let separatedCheckboxes: [InputField]

        let submitButton: Input.Field.Button
        init(label: String, logo: UIImage?, inputFields: [InputField], separatedCheckboxes: [InputField], submitButton: Input.Field.Button) {
            self.label = label
            self.logo = logo
            self.inputFields = inputFields
            self.separatedCheckboxes = separatedCheckboxes
            self.submitButton = submitButton
        }
    }
}
