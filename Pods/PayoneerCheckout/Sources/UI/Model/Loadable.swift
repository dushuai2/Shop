// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

enum Loadable<T> {
    case loaded(Result<T, Error>)
    case notLoaded(URL)

    var value: T? {
        guard case let .loaded(loadedResult) = self else { return nil }

        return try? loadedResult.get()
    }
}

extension Loadable where T == UIImage {
    /// Initialize loadable image object, it will be set to `.loaded` if local asset with such identifier exists. Returns `nil` if no local asset was found and URL wasn't specified.
    init?(identifier: String, url: URL?) {
        let bundle = Bundle(for: PaymentNetwork.self)
        if let image = UIImage(named: identifier, in: bundle, compatibleWith: nil) {
            self = .loaded(.success(image))
            return
        }

        if let url = url {
            self = .notLoaded(url)
        } else {
            return nil
        }
    }
}
