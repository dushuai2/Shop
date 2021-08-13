// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

#if canImport(UIKit)
import UIKit
#endif

final class AssetProvider {
    private static var bundle: Bundle {
        .init(for: AssetProvider.self)
    }

    #if canImport(UIKit)
    static var iconCard: UIImage? {
        return UIImage(named: "iconCard", in: bundle, compatibleWith: nil)
    }

    static var iconClose: UIImage? {
        return UIImage(named: "iconClose", in: bundle, compatibleWith: nil)
    }

    static var iconCVVQuestionMark: UIImage? {
        return UIImage(named: "iconCVVQuestionMark", in: bundle, compatibleWith: nil)
    }

    static var cvvCard: UIImage? {
        return UIImage(named: "cvvCard", in: bundle, compatibleWith: nil)
    }

    static var cvvAMEX: UIImage? {
        return UIImage(named: "cvvAMEX", in: bundle, compatibleWith: nil)
    }

    static var iconClear: UIImage? {
        return UIImage(named: "iconClear", in: bundle, compatibleWith: nil)
    }

    static var disclosureIndicator: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "chevron.right")
        } else {
            return UIImage(named: "disclosureIndicator", in: bundle, compatibleWith: nil)
        }
    }
    #endif

    static func getGroupingRulesData() throws -> Data {
        guard let url = bundle.url(forResource: "groups", withExtension: "json") else {
            throw InternalError(description: "Unable to build a path for groups.json")
        }

        return try Data(contentsOf: url)
    }

    static func getValidationsData() throws -> Data {
        guard let url = bundle.url(forResource: "validations", withExtension: "json") else {
            throw InternalError(description: "Unable to build a path for validations.json")
        }

        return try Data(contentsOf: url)
    }

    static func getValidationsDefaultData() throws -> Data {
        guard let url = bundle.url(forResource: "validations-default", withExtension: "json") else {
            throw InternalError(description: "Unable to build a path for validations-default.json")
        }

        return try Data(contentsOf: url)
    }
}
