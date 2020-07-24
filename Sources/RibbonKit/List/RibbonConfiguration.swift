//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit

/// TODO
public struct RibbonConfiguration {

    /// TODO
    public let itemSize: CGSize

    /// TODO
    public let minimumLineSpacing: CGFloat

    /// TODO
    public let minimumInteritemSpacing: CGFloat

    /// TODO
    public let contentInset: UIEdgeInsets

    /// TODO
    public init(
        itemSize: CGSize = .init(width: 80.0, height: 80.0),
        minimumLineSpacing: CGFloat = 10.0,
        minimumInteritemSpacing: CGFloat = 10.0,
        contentInset: UIEdgeInsets = .zero
    ) {
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.contentInset = contentInset
    }

    /// TODO
    public static let `default` = RibbonConfiguration()

    /// TODO
    public func sectionHeight(numberOfRows rows: Int = 1) -> CGFloat {
        return RibbonConfiguration.sectionHeight(
            numberOfRows: rows,
            itemSize: itemSize,
            minimumInteritemSpacing: minimumInteritemSpacing
        )
    }

    /// TODO
    public static func sectionHeight(numberOfRows rows: Int, itemSize: CGSize, minimumInteritemSpacing: CGFloat) -> CGFloat {
        return (CGFloat(rows) * itemSize.height) + max(minimumInteritemSpacing * CGFloat(rows - 1), 0)
    }
}
