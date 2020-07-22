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

    public static func sectionHeight(numberOfRows rows: Int, itemSize: CGSize, minimumInteritemSpacing: CGFloat) -> CGFloat {
        return (CGFloat(rows) * itemSize.height) + max(minimumInteritemSpacing * CGFloat(rows - 1), 0)
    }

    public static func sectionHeight(numberOfRows rows: Int, configuration: RibbonConfiguration) -> CGFloat {
        return sectionHeight(
            numberOfRows: rows,
            itemSize: configuration.itemSize,
            minimumInteritemSpacing: configuration.minimumInteritemSpacing
        )
    }
}
