// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension List.Table.DataSource {
    class AccountRow {
        let account: RegisteredAccount

        init(account: RegisteredAccount) {
            self.account = account
        }
    }
}

extension List.Table.DataSource.AccountRow {
    var label: String {
        // Example: VISA
        let network = account.networkLabel

        // Example: 41 *** 1111
        var number = account.apiModel.maskedAccount.number ?? String()
        number = String(number.suffix(4)) // 1111

        // Example: VISA •••• 1111
        return network + " •••• " + number
    }

    var image: UIImage? { account.logo?.value }
}

extension List.Table.DataSource.AccountRow: LoadableLogo {
    var logo: Loadable<UIImage>? {
        get { account.logo }
        set { account.logo = newValue }
    }
}
