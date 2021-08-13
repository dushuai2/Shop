// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Provider is used to keep globally shared translations: built-in local translation and remote shared translation.
class SharedTranslationProvider: TranslationProvider {
    private let localTranslations: [String: String]
    private var remoteSharedTranslations: [String: String] = [:]

    var translations: [[String: String]] {
        return [remoteSharedTranslations, localTranslations]
    }

    init(localTranslations: [String: String] = TranslationKey.allCasesAsDictionary) {
        self.localTranslations = localTranslations
    }

    func download(from url: URL, using connection: Connection, completion: @escaping ((Error?) -> Void)) {
        let downloadLocalizationRequest = DownloadLocalization(from: url)
        let sendRequestOperation = SendRequestOperation(connection: connection, request: downloadLocalizationRequest)
        sendRequestOperation.downloadCompletionBlock = { result in
            switch result {
            case .success(let translation):
                self.remoteSharedTranslations = translation
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }

        sendRequestOperation.start()
    }
}

private extension TranslationKey {
    static var allCasesAsDictionary: [String: String] {
        var dictionary = [String: String]()

        for translation in TranslationKey.allCases {
            dictionary[translation.rawValue] = translation.localizedString
        }

        return dictionary
    }
}
