// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension List.Table.DataSource {
    /// Row for a combined network, containing primary and secondary labels.
    class GroupedNetworkRow {
        let networks: [PaymentNetwork]

        private let genericLogo: UIImage
        private var maxDisplayableLogos = 0 // used as a temporary solution, need to clean-up

        init(networks: [PaymentNetwork], genericLogo: UIImage) {
            self.networks = networks
            self.genericLogo = genericLogo
        }
    }
}

// MARK: Computed variables

extension List.Table.DataSource.GroupedNetworkRow {
    private var primaryLabel: String {
        guard let firstNetwork = networks.first else {
            return String()
        }

        return firstNetwork.translation.translation(forKey: "groups.cards.title")
    }

    private var secondaryLabel: String {
        let labels = networks.map { $0.label }
        return labels.joined(separator: " / ")
    }

    private var logoImages: [UIImage] {
        if networks.count > maxDisplayableLogos {
            return [genericLogo]
        }

        var allLogos = [UIImage]()

        for network in networks {
            switch network.logo {
            // Network doesn't have a logo, we don't want to show "some" logos that may confuse an user, show a generic icon
            case .none: return [genericLogo]

            // Logo is being downloadedd, just show an empty space to avoid flickering
            case .notLoaded: return .init()

            case .loaded(let loadResult):
                switch loadResult {
                // Logo was failed to download, show a generic logo, don't show "some" logos
                case .failure: return [genericLogo]

                // Checks were passed, add logo to a stack
                case .success(let image):
                    allLogos.append(image)
                }
            }
        }

        return allLogos
    }
}

extension List.Table.DataSource.GroupedNetworkRow {
    func dequeueConfiguredReusableCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(List.Table.DetailedLabelCell.self, for: indexPath)

        // Set model
        cell.primaryLabel?.text = primaryLabel
        cell.secondaryLabel?.text = secondaryLabel

        // TODO: We agreed to remove multiple images support so that's why we use the first image (it's card's icon). Better to updated model later to fully remove multiple logos support.
        cell.logoView?.image = logoImages.first

        // Set cell position
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)

        if numberOfRows == 1 {
            cell.cellIndex = .singleCell
        } else {
            switch indexPath.row {
            case let row where row == 0: cell.cellIndex = .first
            case let row where row == numberOfRows - 1: cell.cellIndex = .last
            default: cell.cellIndex = .middle
            }
        }

        return cell
    }
}
