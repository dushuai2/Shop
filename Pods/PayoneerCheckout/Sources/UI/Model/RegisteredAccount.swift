// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

final class RegisteredAccount {
    let apiModel: AccountRegistration
    let translation: TranslationProvider

    let networkLabel: String
    let submitButtonLabel: String
    var logo: Loadable<UIImage>?

    init(from apiModel: AccountRegistration, submitButtonLocalizationKey: String, localizeUsing localizer: TranslationProvider) {
        self.apiModel = apiModel
        self.translation = localizer

        self.networkLabel = localizer.translation(forKey: "network.label")
        self.submitButtonLabel = localizer.translation(forKey: submitButtonLocalizationKey)

        logo = Loadable<UIImage>(identifier: apiModel.code.lowercased(), url: apiModel.links["logo"])
    }

}
