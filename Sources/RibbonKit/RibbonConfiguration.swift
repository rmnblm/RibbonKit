//  Copyright © 2020 Swisscom. All rights reserved.

import CoreGraphics

public struct RibbonConfiguration {
    public let itemSize: CGSize
    public let minimumLineSpacing: CGFloat
    public let minimumInteritemSpacing: CGFloat

    public init(
        itemSize: CGSize = .init(width: 80.0, height: 80.0),
        minimumLineSpacing: CGFloat = 10.0,
        minimumInteritemSpacing: CGFloat = 10.0
    ) {
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }

    public static let `default` = RibbonConfiguration()
}
