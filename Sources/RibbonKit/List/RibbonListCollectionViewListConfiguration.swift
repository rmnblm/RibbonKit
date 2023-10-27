//  Copyright © 2022 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListCollectionViewListConfiguration {

    public let id = UUID()
    public let appearance: UICollectionLayoutListConfiguration.Appearance
    public let backgroundColor: UIColor?

    #if os(iOS)
    public let showsSeparators: Bool
    public let leadingSwipeActionsConfiguration: UICollectionLayoutListConfiguration.SwipeActionsConfigurationProvider?
    public let trailingSwipeActionsConfiguration: UICollectionLayoutListConfiguration.SwipeActionsConfigurationProvider?
    #endif

    #if os(iOS)
    public init(
        appearance: UICollectionLayoutListConfiguration.Appearance,
        backgroundColor: UIColor? = nil,
        showsSeparators: Bool = true,
        leadingSwipeActionsConfiguration: UICollectionLayoutListConfiguration.SwipeActionsConfigurationProvider? = nil,
        trailingSwipeActionsConfiguration: UICollectionLayoutListConfiguration.SwipeActionsConfigurationProvider? = nil
    ) {
        self.appearance = appearance
        self.backgroundColor = backgroundColor
        self.showsSeparators = showsSeparators
        self.leadingSwipeActionsConfiguration = leadingSwipeActionsConfiguration
        self.trailingSwipeActionsConfiguration = trailingSwipeActionsConfiguration
    }
    #else
    public init(
        appearance: UICollectionLayoutListConfiguration.Appearance,
        backgroundColor: UIColor? = nil
    ) {
        self.appearance = appearance
        self.backgroundColor = backgroundColor
    }
    #endif

    func asCollectionLayoutListConfiguration() -> UICollectionLayoutListConfiguration {
        var config = UICollectionLayoutListConfiguration(appearance: appearance)
        #if os(iOS)
        config.showsSeparators = showsSeparators
        config.leadingSwipeActionsConfigurationProvider = leadingSwipeActionsConfiguration
        config.trailingSwipeActionsConfigurationProvider = trailingSwipeActionsConfiguration
        #endif
        config.backgroundColor = backgroundColor
        return config
    }
}

extension RibbonListCollectionViewListConfiguration: Hashable {
    public static func == (lhs: RibbonListCollectionViewListConfiguration, rhs: RibbonListCollectionViewListConfiguration) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
