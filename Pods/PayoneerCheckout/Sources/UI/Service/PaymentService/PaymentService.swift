// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit
import SafariServices

protocol PaymentService: class {
    /// Returns whether the service can make payments
    static func isSupported(networkCode: String, paymentMethod: String?) -> Bool

    func send(paymentRequest: PaymentRequest)
    var delegate: PaymentServiceDelegate? { get set }

    init(using connection: Connection)
}

protocol PaymentServiceDelegate: class {
    func paymentService(didReceiveResponse response: PaymentServiceParsedResponse)
}
