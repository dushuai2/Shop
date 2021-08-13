// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Class is used when you need to create a custom `ErrorInfo` to keep track what error cause creation of local error info
final class CustomErrorInfo: ErrorInfo {
    /// Underlying error that caused payment error
    let underlyingError: Error?

    init(resultInfo: String, interaction: Interaction, underlyingError: Error? = nil) {
        self.underlyingError = underlyingError
        super.init(resultInfo: resultInfo, interaction: interaction)
    }

    @available(*, unavailable)
    required init(from decoder: Decoder) throws {
        fatalError("Can't be inited from decoder")
    }

    /// Create an instance with `ABORT` and `CLIENTSIDE_ERROR` Interaction
    static func createClientSideError(from error: Error) -> CustomErrorInfo {
        let interaction = Interaction(code: .ABORT, reason: .CLIENTSIDE_ERROR)
        return .init(resultInfo: error.localizedDescription, interaction: interaction, underlyingError: error)
    }
}
