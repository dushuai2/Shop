// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import SafariServices

class BasicPaymentService: PaymentService {
    // MARK: - Static methods
    static func isSupported(networkCode: String, paymentMethod: String?) -> Bool {
        if let paymentMethod = paymentMethod {
            if isSupported(method: paymentMethod) { return true }
        }

        if isSupported(code: networkCode) { return true }

        return false
    }

    /// Find appropriate interaction code for specified operation type.
    static func getFailureInteractionCode(forOperationType operationType: String?) -> Interaction.Code {
        switch operationType {
        case "PRESET", "UPDATE", "ACTIVATION": return .ABORT
        default:
            // "CHARGE", "PAYOUT" and other operation types
            return .VERIFY
        }
    }

    private static func isSupported(method: String) -> Bool {
        let supportedMethods: [PaymentMethod] = [.DEBIT_CARD, .CREDIT_CARD]
        guard let paymentMethod = PaymentMethod(rawValue: method) else {
            return false
        }

        return supportedMethods.contains(paymentMethod)
    }

    private static func isSupported(code: String) -> Bool {
        let supportedCodes = ["SEPADD", "PAYPAL", "WECHATPC-R"]
        return supportedCodes.contains(code)
    }

    // MARK: -

    weak var delegate: PaymentServiceDelegate?

    let connection: Connection
    private lazy var redirectCallbackHandler: RedirectCallbackHandler = .init()
    private var responseParser: ResponseParser?

    required init(using connection: Connection) {
        self.connection = connection
    }

    func send(paymentRequest: PaymentRequest) {
        let chargeRequestBody = ChargeRequest.Body(inputFields: paymentRequest.inputFields)
        let chargeRequest = ChargeRequest(from: paymentRequest.operationURL, body: chargeRequestBody)
        let chargeOperation = SendRequestOperation(connection: connection, request: chargeRequest)
        chargeOperation.downloadCompletionBlock = { result in
            let parser = ResponseParser(operationType: paymentRequest.operationURL.lastPathComponent, connectionType: type(of: self.connection.self))
            let response = parser.parse(paymentRequestResponse: result)

            switch response {
            case .result(let result):
                log(.debug, "Payment result received. Interaction code: %@, reason: %@", result.interaction.code, result.interaction.reason)
            case .redirect(let url):
                log(.debug, "Redirecting user to an external url: %@", url.absoluteString)
                self.redirectCallbackHandler.delegate = self.delegate
                self.redirectCallbackHandler.subscribeForNotification()
            }

            self.delegate?.paymentService(didReceiveResponse: response)
        }

        chargeOperation.start()
    }
}
