// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension List.Table.DataSource {
    /// Model for a single network.
    class SingleNetworkRow {
        let network: PaymentNetwork

        init(network: PaymentNetwork) {
            self.network = network
        }
    }
}

extension List.Table.DataSource.SingleNetworkRow {
    var label: String { network.label }
    var image: UIImage? { network.logo?.value }
}

extension List.Table.DataSource.SingleNetworkRow {
    var networks: [PaymentNetwork] { return [network] }
}

extension List.Table.DataSource.SingleNetworkRow: LoadableLogo {
    var logo: Loadable<UIImage>? {
        get { network.logo }
        set { network.logo = newValue }
    }
}
