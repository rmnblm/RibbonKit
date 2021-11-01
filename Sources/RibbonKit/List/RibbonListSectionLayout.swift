//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListSectionLayout: Hashable {

    public enum Orientation { case horizontal, vertical }

    public let orientation: Orientation
    public let numberOfRows: Int
    public let heightDimension: RibbonListLayoutDimension
    public let itemWidthDimensions: [RibbonListLayoutDimension]

    public static func horizontal(
        heightDimension: RibbonListLayoutDimension,
        itemWidthDimensions: [RibbonListLayoutDimension]
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .horizontal,
            numberOfRows: 1,
            heightDimension: heightDimension,
            itemWidthDimensions: itemWidthDimensions.isEmpty ? [.estimated(80)] : itemWidthDimensions
        )
    }

    public static func horizontal(
        heightDimension: RibbonListLayoutDimension,
        itemWidthDimension: RibbonListLayoutDimension
    ) -> RibbonListSectionLayout {
        return .horizontal(
            heightDimension: heightDimension,
            itemWidthDimensions: [itemWidthDimension]
        )
    }

    public static func vertical(
        numberOfRows: Int,
        heightDimension: RibbonListLayoutDimension,
        itemWidthDimension: RibbonListLayoutDimension
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .vertical,
            numberOfRows: numberOfRows,
            heightDimension: heightDimension,
            itemWidthDimensions: [itemWidthDimension]
        )
    }

    public static var `default` = horizontal(heightDimension: .absolute(80), itemWidthDimensions: [.absolute(80)])
}
