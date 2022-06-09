//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListSectionLayout: Hashable {

    public enum Orientation: Hashable {
        case horizontal
        case vertical
        case list(RibbonListCollectionViewListConfiguration)
        case single
    }
    
    public let orientation: Orientation
    public let numberOfRows: Int
    public let heightDimension: RibbonListDimension
    public let itemWidthDimensions: [RibbonListDimension]
    public var itemsConfiguration: ItemsConfiguration

    public static func horizontal(
        heightDimension: RibbonListDimension,
        itemWidthDimensions: [RibbonListDimension]
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .horizontal,
            numberOfRows: 1,
            heightDimension: heightDimension,
            itemWidthDimensions: itemWidthDimensions.isEmpty ? [.estimated(80)] : itemWidthDimensions,
            itemsConfiguration: .default
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
            itemWidthDimensions: [itemWidthDimension],
            itemsConfiguration: .default
        )
    }
    
    public static func list(_ configuration: RibbonListCollectionViewListConfiguration) -> RibbonListSectionLayout {
        return .init(
            orientation: .list(configuration),
            numberOfRows: 1,
            heightDimension: .fractionalHeight(1),
            itemWidthDimensions: [.fractionalWidth(1)],
            itemsConfiguration: .default
        )
    }
    
    /// Create a new section with an horizontal layout, each Row is made up of items and you cannot scroll horizontally.
    /// Items are displayed on new lines. (For example: every 3 items you'll have a new row)
    /// - Parameters:
    ///   - heightDimension: Height of each row
    ///   - portraitItems: Number of items in portrait
    ///   - landscapeItems: Number of items in landscape
    /// - Returns: New horizontal RibbonListSectionLayout
    public static func single(
        heightDimension: RibbonListDimension,
        itemsConfiguration: ItemsConfiguration
    ) -> RibbonListSectionLayout {
        return .init(
            orientation: .single,
            numberOfRows: 1,
            heightDimension: heightDimension,
            itemWidthDimensions: [.estimated(1)],
            itemsConfiguration: itemsConfiguration
        )
    }

    public static var `default` = horizontal(heightDimension: .absolute(80), itemWidthDimensions: [.absolute(80)])
}
