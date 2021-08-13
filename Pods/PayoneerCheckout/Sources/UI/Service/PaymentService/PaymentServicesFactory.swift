// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

class PaymentServicesFactory {
    var services: [PaymentService.Type] = .init()
    let connection: Connection

    init(connection: Connection) {
        self.connection = connection
    }

    /// Register all known services
    func registerServices() {
        register(paymentService: BasicPaymentService.self)
    }

    private func register(paymentService: PaymentService.Type) {
        services.append(paymentService)
    }

    /// Lookup for appropriate payment service and create an instance if found
    func createPaymentService(forNetworkCode networkCode: String, paymentMethod: String?) -> PaymentService? {
        for service in services where service.isSupported(networkCode: networkCode, paymentMethod: paymentMethod) {
            return service.init(using: connection)
        }

        return nil
    }

    func isSupported(networkCode: String, paymentMethod: String?) -> Bool {
        for service in services where service.isSupported(networkCode: networkCode, paymentMethod: paymentMethod) {
            return true
        }

        return false
    }
}
