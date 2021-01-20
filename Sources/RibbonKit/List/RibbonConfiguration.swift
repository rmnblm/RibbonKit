//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit

/// TODO
public struct RibbonConfiguration: Hashable {

    /// TODO
    public let numberOfRows: Int

    /// TODO
    public let sectionHeight: CGFloat?

    /// TODO
    public let itemSize: CGSize

    /// TODO
    public let minimumLineSpacing: CGFloat

    /// TODO
    public let minimumInteritemSpacing: CGFloat

    /// TODO
    public let sectionInset: UIEdgeInsets

    /// TODO
    public init(
        numberOfRows: Int = 1,
        sectionHeight: CGFloat? = nil,
        itemSize: CGSize = .init(width: 80.0, height: 80.0),
        minimumLineSpacing: CGFloat = 6.0,
        minimumInteritemSpacing: CGFloat = 6.0,
        sectionInset: UIEdgeInsets = .zero
    ) {
        self.numberOfRows = numberOfRows
        self.sectionHeight = sectionHeight
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
    }

    /// TODO
    public static let `default` = RibbonConfiguration()

    /// TODO
    public func estimatedSectionHeight() -> CGFloat {
        if let sectionHeight = sectionHeight { return sectionHeight }
        return RibbonConfiguration.sectionHeight(
            numberOfRows: numberOfRows,
            itemSize: itemSize,
            minimumInteritemSpacing: minimumInteritemSpacing
        )
    }

    /// TODO
    public static func sectionHeight(numberOfRows rows: Int, itemSize: CGSize, minimumInteritemSpacing: CGFloat) -> CGFloat {
        return (CGFloat(rows) * itemSize.height) + max(minimumInteritemSpacing * CGFloat(rows - 1), 0)
    }
}
