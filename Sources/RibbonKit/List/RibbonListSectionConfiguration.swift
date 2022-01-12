//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListSectionConfiguration: Hashable {

    public var layout: RibbonListSectionLayout
    public var interItemSpacing: CGFloat
    public var interGroupSpacing: CGFloat
    public var sectionInsets: UIEdgeInsets
    public var headerInsets: UIEdgeInsets
    public var footerInsets: UIEdgeInsets
    public var listConfiguration: RibbonListCollectionViewListConfiguration

    public init(
        layout: RibbonListSectionLayout,
        interItemSpacing: CGFloat = 6.0,
        interGroupSpacing: CGFloat = 6.0,
        sectionInsets: UIEdgeInsets = .zero,
        headerInsets: UIEdgeInsets = .zero,
        footerInsets: UIEdgeInsets = .zero,
        listConfiguration: RibbonListCollectionViewListConfiguration = .init(appearance: .plain)
    ) {
        self.layout = layout
        self.interItemSpacing = interItemSpacing
        self.interGroupSpacing = interGroupSpacing
        self.sectionInsets = sectionInsets
        self.headerInsets = headerInsets
        self.footerInsets = footerInsets
        self.listConfiguration = listConfiguration
    }

    public static let `default` = RibbonListSectionConfiguration(layout: .horizontal(heightDimension: .absolute(80), itemWidthDimension: .absolute(80)))
}

extension UIEdgeInsets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(NSCoder.string(for: self))
    }
}
