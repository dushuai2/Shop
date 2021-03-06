// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import os

func log(_ type: LogType, _ message: StaticString, _ args: CVarArg...) {
    os_log(type.osLogType, message, args)
}

func log(_ error: Error) {
    // Log errors
    if let internalError = error as? InternalError {
        internalError.log()
        return
    }

    var text = String()
    dump(error, to: &text)
    log(.error, "%@", text)
}

enum LogType {
    case info, debug, error, fault

    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    var osLogType: OSLogType {
        switch self {
        case .debug: return OSLogType.debug
        case .error: return OSLogType.error
        case .fault: return OSLogType.fault
        case .info: return OSLogType.info
        }
    }
}
