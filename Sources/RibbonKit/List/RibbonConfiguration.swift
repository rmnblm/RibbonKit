//  Copyright © 2020 Roman Blum. All rights reserved.

import UIKit

public struct RibbonConfiguration: Hashable {

    public var numberOfRows: Int
    public var sectionInsets: UIEdgeInsets
    public var itemSize: CGSize
    public var interItemSpacing: CGFloat
    public var interGroupSpacing: CGFloat
    public var headerInsets: UIEdgeInsets
    public var footerInsets: UIEdgeInsets

    public init(
        numberOfRows: Int = 1,
        itemSize: CGSize = .init(width: 80.0, height: 80.0),
        interItemSpacing: CGFloat = 6.0,
        interGroupSpacing: CGFloat = 6.0,
        sectionInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 0),
        headerInsets: UIEdgeInsets = .zero,
        footerInsets: UIEdgeInsets = .zero
    ) {
        self.numberOfRows = numberOfRows
        self.itemSize = itemSize
        self.interItemSpacing = interItemSpacing
        self.interGroupSpacing = interGroupSpacing
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
