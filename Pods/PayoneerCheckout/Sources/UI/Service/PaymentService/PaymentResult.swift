// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Class contains payment result, `operationResult` or `errorInfo` is always present (one of them).
@objc public class PaymentResult: NSObject {
    @objc public var operationResult: OperationResult? {
        guard case let .success(unwrappedOperationResult) = result else {
            return nil
        }

        return unwrappedOperationResult
    }

    @objc public var errorInfo: ErrorInfo? {
        guard case let .failure(error) = result else {
            return nil
        }

        return error
    }

    /// Contains value if something went wrong inside framework. In the most cases it would contain `InternalError` type.
    @objc public var cause: Error? {
        return (errorInfo as? CustomErrorInfo)?.underlyingError
    }

    /// Contains result info from `OperationResult` or `ErrorInfo`
    @objc public var resultInfo: String { result.resultInfo }

    /// A reference to `Interaction` object inside `operationResult` or `errorInfo`.
    @objc public var interaction: Interaction { result.interaction }

    // MARK: Internal

    private let result: Result<OperationResult, ErrorInfo>

    internal init(operationResult: Result<OperationResult, ErrorInfo>) {
        self.result = operationResult
    }
}
