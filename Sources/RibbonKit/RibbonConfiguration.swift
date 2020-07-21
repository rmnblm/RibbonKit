//  Copyright © 2020 Swisscom. All rights reserved.

import CoreGraphics

public struct RibbonConfiguration {
    public let itemSize: CGSize
    public let minimumLineSpacing: CGFloat

    public init(
        itemSize: CGSize,
        minimumLineSpacing: CGFloat
    ) {
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
    }

    public static let `default` = RibbonConfiguration(
        itemSize: Constants.defaultItemSize,
        minimumLineSpacing: Constants.defaultMinimumLineSpacing
    )
}
