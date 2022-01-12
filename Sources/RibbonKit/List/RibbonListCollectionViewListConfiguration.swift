//  Copyright © 2022 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListCollectionViewListConfiguration: Hashable {

    public var appearance: UICollectionLayoutListConfiguration.Appearance
    public var backgroundColor: UIColor?
    public var showsSeparators: Bool = true

    public init(
        appearance: UICollectionLayoutListConfiguration.Appearance,
        backgroundColor: UIColor? = nil,
        showsSeparators: Bool = true
    ) {
        self.appearance = appearance
        self.backgroundColor = backgroundColor
        self.showsSeparators = showsSeparators
    }
    
    func asCollectionLayoutListConfiguration() -> UICollectionLayoutListConfiguration {
        var config = UICollectionLayoutListConfiguration(appearance: appearance)
        config.backgroundColor = backgroundColor
        config.showsSeparators = showsSeparators
        return config
    }
}
