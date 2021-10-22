//  Copyright © 2020 Roman Blum. All rights reserved.

import UIKit

public struct RibbonConfiguration: Hashable {

    public var numberOfRows: Int
    public var sectionInsets: UIEdgeInsets
    public var itemSize: CGSize
    public var interItemSpacing: CGFloat
    public var headerInsets: UIEdgeInsets
    public var footerInsets: UIEdgeInsets

    public init(
        numberOfRows: Int = 1,
        itemSize: CGSize = .init(width: 80.0, height: 80.0),
        interItemSpacing: CGFloat = 6.0,
        sectionInsets: UIEdgeInsets = .zero,
        headerInsets: UIEdgeInsets = .init(top: 4, left: 15, bottom: 4, right: 15),
        footerInsets: UIEdgeInsets = .init(top: 4, left: 15, bottom: 4, right: 15)
    ) {
        self.numberOfRows = numberOfRows
        self.itemSize = itemSize
        self.interItemSpacing = interItemSpacing
        self.sectionInsets = sectionInsets
        self.headerInsets = headerInsets
        self.footerInsets = footerInsets
    }

    public static let `default` = RibbonConfiguration()

    public func calculatedSectionHeight() -> CGFloat {
        return RibbonConfiguration.sectionHeight(
            numberOfRows: numberOfRows,
            itemSize: itemSize,
            interItemSpacing: interItemSpacing
        )
    }

    public static func sectionHeight(numberOfRows rows: Int, itemSize: CGSize, interItemSpacing: CGFloat) -> CGFloat {
        return (CGFloat(rows) * itemSize.height) + max(interItemSpacing * CGFloat(rows - 1), 0)
    }
}
