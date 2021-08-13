// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension BasicPaymentService {
    struct ResponseParser {
        private let supportedRedirectTypes = ["PROVIDER", "3DS2-HANDLER"]
        let operationType: String
        let connectionType: Connection.Type
    }
}

extension BasicPaymentService.ResponseParser {
    /// Parse server's http data response to enumeration
    func parse(paymentRequestResponse: Result<OperationResult, Error>) -> PaymentServiceParsedResponse {
        let operationResult: OperationResult

        // Unwrap Result enumeration
        do {
            operationResult = try paymentRequestResponse.get()
        } catch {
            // Return server's error info if it replied with error
            if let errorInfo = error as? ErrorInfo {
                return .result(.failure(errorInfo))
            }

            let interactionCode = BasicPaymentService.getFailureInteractionCode(forOperationType: operationType)

            // Get interaction
            let interaction: Interaction
            if connectionType.isRecoverableError(error) {
                // It is a network error
                interaction = Interaction(code: interactionCode, reason: .COMMUNICATION_FAILURE)
            } else {
                interaction = Interaction(code: interactionCode, reason: .CLIENTSIDE_ERROR)
            }

            let customErrorInfo = CustomErrorInfo(resultInfo: error.localizedDescription, interaction: interaction, underlyingError: error)
            return .result(.failure(customErrorInfo))
        }

        // Check if an external browser should be opened
        if let redirect = operationResult.redirect, let redirectType = redirect.type, self.supportedRedirectTypes.contains(redirectType) {
            let parser = RedirectParser(redirect: redirect, links: operationResult.links)

            do {
                let url = try parser.createRedirectURL()
                return .redirect(url)
            } catch {
                let interactionCode = BasicPaymentService.getFailureInteractionCode(forOperationType: operationType)
                let interaction = Interaction(code: interactionCode, reason: .CLIENTSIDE_ERROR)
                let paymentError = CustomErrorInfo(resultInfo: error.localizedDescription, interaction: interaction, underlyingError: error)
                return .result(.failure(paymentError))
            }
        }

        return .result(.success(operationResult))
    }
}

// MARK: - Redirect parser

/// Parser class for `Redirect` object
private struct RedirectParser {
    let redirect: Redirect

    /// Links property from `OperationResult`
    let links: [String: URL]?

    /// Construct an url from `Redirect` object which should be opened in a browser to continue the charge request.
    func createRedirectURL() throws -> URL {
        switch redirect.method {
        case .GET:
            guard let components = URLComponents(url: redirect.url, resolvingAgainstBaseURL: false) else {
                throw InternalError(description: "Incorrect redirect url provided: %@", redirect.url.absoluteString)
            }

            return try create(from: components, replacingQueryItemsWith: redirect.parameters)
        case .POST:
            guard let links = self.links else {
                throw InternalError(description: "Redirect method is POST but OperationResult's links are empty")
            }

            guard let redirectURL = links["redirect"] else {
                throw InternalError(description: "Redirect method is POST but OperationResult's links don't contain redirect key. Links: %@", links)
            }

            return redirectURL
        }
    }

    private func create(from inputComponents: URLComponents, replacingQueryItemsWith parameters: [Parameter]?) throws -> URL {
        var components = inputComponents

        // Add or replace query items with parameters from `Redirect` object
        if let parameters = parameters, !parameters.isEmpty {
            var queryItems = components.queryItems ?? [URLQueryItem]()

            queryItems += parameters.map {
                URLQueryItem(name: $0.name, value: $0.value)
            }

            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw InternalError(description: "Unable to build URL from components")
        }

        return url
    }
}
