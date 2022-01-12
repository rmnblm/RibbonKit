//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListSectionLayout: Hashable {

    public enum Orientation { case horizontal, vertical, list }

    public let orientation: Orientation
    public let numberOfRows: Int
    public let heightDimension: RibbonListDimension
    public let itemWidthDimensions: [RibbonListDimension]

    public static func horizontal(
        heightDimension: RibbonListDimension,
        itemWidthDimensions: [RibbonListDimension]
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .horizontal,
            numberOfRows: 1,
            heightDimension: heightDimension,
            itemWidthDimensions: itemWidthDimensions.isEmpty ? [.estimated(80)] : itemWidthDimensions
        )
    }

    public static func horizontal(
        heightDimension: RibbonListDimension,
        itemWidthDimension: RibbonListDimension
    ) -> RibbonListSectionLayout {
        return .horizontal(
            heightDimension: heightDimension,
            itemWidthDimensions: [itemWidthDimension]
        )
    }

    public static func vertical(
        numberOfRows: Int,
        heightDimension: RibbonListDimension,
        itemWidthDimension: RibbonListDimension
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .vertical,
            numberOfRows: numberOfRows,
            heightDimension: heightDimension,
            itemWidthDimensions: [itemWidthDimension]
        )
    }
    
    public static func list() -> RibbonListSectionLayout {
        return .init(
            orientation: .list,
            numberOfRows: 1,
            heightDimension: .fractionalHeight(1),
            itemWidthDimensions: [.fractionalWidth(1)]
        )
    }

    public static var `default` = horizontal(heightDimension: .absolute(80), itemWidthDimensions: [.absolute(80)])
}
