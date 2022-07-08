//  Copyright © 2021 Roman Blum. All rights reserved.

import Foundation
import CoreGraphics

protocol ItemsConfigurable {
    var portraitItems: Int { get }
    var landscapeItems: Int { get }
}

public struct ItemsConfiguration: Hashable {
    
    public struct PhoneItemsConfiguration: ItemsConfigurable, Hashable {
        public let portraitItems: Int
        public let landscapeItems: Int
        
        public init(portraitItems: Int = 1, landscapeItems: Int = 2) {
            self.portraitItems = portraitItems
            self.landscapeItems = landscapeItems
        }
    }
    
    public struct PadItemsConfiguration: ItemsConfigurable, Hashable {
        public let portraitItems: Int
        public let landscapeItems: Int
        
        public init(portraitItems: Int = 2, landscapeItems: Int = 4) {
            self.portraitItems = portraitItems
            self.landscapeItems = landscapeItems
        }
    }
    
    public struct TvItemsConfiguration: Hashable {
        public let items: Int

        public init(items: Int = 10) {
            self.items = items
        }
    }
    
    public var phoneConfiguration: PhoneItemsConfiguration
    public var padConfiguration: PadItemsConfiguration
    public var tvConfiguration: TvItemsConfiguration
    public var aspectRatio: CGFloat
    
    static var `default` = ItemsConfiguration(
        phoneConfiguration: .init(),
        padConfiguration: .init(),
        tvConfiguration: .init()
    )

    public init(
        phoneConfiguration: PhoneItemsConfiguration,
        padConfiguration: PadItemsConfiguration,
        tvConfiguration: TvItemsConfiguration
    ) {
        self.phoneConfiguration = phoneConfiguration
        self.padConfiguration = padConfiguration
        self.tvConfiguration = tvConfiguration
        self.aspectRatio = 0
    }
    
    public init(
        aspectRatio: CGFloat
    ) {
        self.phoneConfiguration = .init()
        self.padConfiguration = .init()
        self.tvConfiguration = .init()
        self.aspectRatio = aspectRatio
    }
}
