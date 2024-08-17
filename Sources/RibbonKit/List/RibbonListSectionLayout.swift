//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListSectionLayout: Hashable {

    public enum Orientation: Hashable {
        case horizontal(leadingCellWidth: RibbonListDimension? = nil)
        case vertical
        case list(RibbonListCollectionViewListConfiguration)
        case wall(ItemsConfiguration)
        case single
    }
    
    public let orientation: Orientation
    public let numberOfRows: Int
    public let heightDimension: RibbonListDimension
    public let itemWidthDimensions: [RibbonListDimension]

    public static func single(
        heightDimension: RibbonListDimension
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .single,
            numberOfRows: 1,
            heightDimension: heightDimension,
            itemWidthDimensions: []
        )
    }

    public static func carousel(
        heightDimension: RibbonListDimension
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .single,
            numberOfRows: 1,
            heightDimension: heightDimension,
            itemWidthDimensions: [.fractionalHeight(1.0)]
        )
    }

    public static func horizontal(
        heightDimension: RibbonListDimension,
        itemWidthDimensions: [RibbonListDimension],
        leadingCellWidth: RibbonListDimension? = nil
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .horizontal(leadingCellWidth: leadingCellWidth),
            numberOfRows: 1,
            heightDimension: heightDimension,
            itemWidthDimensions: itemWidthDimensions.isEmpty ? [.estimated(80)] : itemWidthDimensions
        )
    }

    public static func horizontal(
        heightDimension: RibbonListDimension,
        itemWidthDimension: RibbonListDimension,
        leadingCellWidth: RibbonListDimension? = nil
    ) -> RibbonListSectionLayout {
        return .horizontal(
            heightDimension: heightDimension,
            itemWidthDimensions: [itemWidthDimension],
            leadingCellWidth: leadingCellWidth
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
    
    public static func list(_ configuration: RibbonListCollectionViewListConfiguration) -> RibbonListSectionLayout {
        return .init(
            orientation: .list(configuration),
            numberOfRows: 1,
            heightDimension: .fractionalHeight(1),
            itemWidthDimensions: [.fractionalWidth(1)]
        )
    }

    /// Create a new section with an horizontal layout, each Row is made up of items and you cannot scroll horizontally.
    /// Items are displayed on new lines. (For example: every 3 items you'll have a new row)
    /// - Parameters:
    ///   - heightDimension: Height of each row
    ///   - itemsConfiguration: Configuration of items to be displayed
    /// - Returns: New horizontal RibbonListSectionLayout
    public static func wall(
        itemsConfiguration: ItemsConfiguration
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .wall(itemsConfiguration),
            numberOfRows: 1,
            heightDimension: .fractionalHeight(1),
            itemWidthDimensions: [.fractionalWidth(1)]
        )
    }

    public static var `default` = horizontal(heightDimension: .absolute(80), itemWidthDimensions: [.absolute(80)])
}
