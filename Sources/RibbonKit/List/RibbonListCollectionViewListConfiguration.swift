//  Copyright © 2022 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListCollectionViewListConfiguration: Hashable {

    public var appearance: UICollectionLayoutListConfiguration.Appearance
    public var backgroundColor: UIColor?

    #if os(iOS)
    public var showsSeparators: Bool = true
    #endif

    public init(
        appearance: UICollectionLayoutListConfiguration.Appearance,
        backgroundColor: UIColor? = nil
    ) {
        self.appearance = appearance
        self.backgroundColor = backgroundColor
    }

    func asCollectionLayoutListConfiguration() -> UICollectionLayoutListConfiguration {
        var config = UICollectionLayoutListConfiguration(appearance: appearance)
        config.backgroundColor = backgroundColor
        #if os(iOS)
        config.showsSeparators = showsSeparators
        #endif
        return config
    }
}
