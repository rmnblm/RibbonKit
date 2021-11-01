//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public struct RibbonConfiguration: Hashable {

    public var sectionInsets: UIEdgeInsets
    public var layout: RibbonListSectionLayout
    public var interItemSpacing: CGFloat
    public var interGroupSpacing: CGFloat
    public var headerInsets: UIEdgeInsets
    public var footerInsets: UIEdgeInsets

    public init(
        layout: RibbonListSectionLayout = .horizontal(heightDimension: .absolute(80), itemWidthDimensions: [.absolute(80)]),
        interItemSpacing: CGFloat = 6.0,
        interGroupSpacing: CGFloat = 6.0,
        sectionInsets: UIEdgeInsets = .zero,
        headerInsets: UIEdgeInsets = .zero,
        footerInsets: UIEdgeInsets = .zero
    ) {
        self.layout = layout
        self.interItemSpacing = interItemSpacing
        self.interGroupSpacing = interGroupSpacing
        self.sectionInsets = sectionInsets
        self.headerInsets = headerInsets
        self.footerInsets = footerInsets
    }

    public static let `default` = RibbonConfiguration()
}
