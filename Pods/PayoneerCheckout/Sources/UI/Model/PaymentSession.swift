// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

final class PaymentSession {
    let networks: [PaymentNetwork]
    let registeredAccounts: [RegisteredAccount]?

    /// Same as `ListResult.operationType`
    let operationType: String

    init(operationType: String, networks: [TranslatedModel<ApplicableNetwork>], accounts: [TranslatedModel<AccountRegistration>]?) {
        self.operationType = operationType
        let buttonLocalizationKey = "button.operation." + operationType.uppercased() + ".label"

        self.networks = networks.map {
            .init(from: $0.model, submitButtonLocalizationKey: buttonLocalizationKey, localizeUsing: $0.translator)
        }

        self.registeredAccounts = accounts?.map {
            RegisteredAccount(from: $0.model, submitButtonLocalizationKey: buttonLocalizationKey, localizeUsing: $0.translator)
        }
    }
}
