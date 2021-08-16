//  Copyright © 2020 Roman Blum. All rights reserved.

import UIKit

/// TODO
public struct RibbonConfiguration: Hashable {

    /// TODO
    public var numberOfRows: Int

    /// TODO
    public var sectionInsets: UIEdgeInsets
    
    /// TODO
    public var itemSize: CGSize
    
    /// TODO
    public var interItemSpacing: CGFloat

    #if os(tvOS)
    
    /// TODO
    public var headerInsets: UIEdgeInsets
    
    /// TODO
    public var footerInsets: UIEdgeInsets
    #endif
    
    #if os(iOS)
    /// TODO
    public var minimumLineSpacing: CGFloat
    #endif

    #if os(tvOS)
    /// TODO
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
    #endif
    
    #if os(iOS)
    /// TODO
    public init(
        numberOfRows: Int = 1,
        itemSize: CGSize = .init(width: 80.0, height: 80.0),
        interItemSpacing: CGFloat = 6.0,
        sectionInsets: UIEdgeInsets = .zero,
        minimumLineSpacing: CGFloat = 6.0
    ) {
        self.numberOfRows = numberOfRows
        self.itemSize = itemSize
        self.sectionInsets = sectionInsets
        self.minimumLineSpacing = minimumLineSpacing
        self.interItemSpacing = interItemSpacing
    }
    #endif

    /// TODO
    public static let `default` = RibbonConfiguration()

    /// TODO
    public func calculatedSectionHeight() -> CGFloat {
        return RibbonConfiguration.sectionHeight(
            numberOfRows: numberOfRows,
            itemSize: itemSize,
            interItemSpacing: interItemSpacing
        )
    }

    /// TODO
    public static func sectionHeight(numberOfRows rows: Int, itemSize: CGSize, interItemSpacing: CGFloat) -> CGFloat {
        return (CGFloat(rows) * itemSize.height) + max(interItemSpacing * CGFloat(rows - 1), 0)
    }
}
