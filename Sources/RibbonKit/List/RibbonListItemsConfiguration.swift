//  Copyright © 2021 Roman Blum. All rights reserved.

import Foundation
import CoreGraphics

protocol ItemsConfigurable {
    var portraitItems: Int { get }
    var landscapeItems: Int { get }
}

public struct ItemsConfiguration: Hashable {
    
    #if os(iOS)
    public struct PhoneItemsConfiguration: ItemsConfigurable, Hashable {
        public let portraitItems: Int
        public let landscapeItems: Int
        
        public init(portraitItems: Int = 3, landscapeItems: Int = 6) {
            self.portraitItems = portraitItems
            self.landscapeItems = landscapeItems
        }
    }
    
    public struct PadItemsConfiguration: ItemsConfigurable, Hashable {
        public let portraitItems: Int
        public let landscapeItems: Int
        
        public init(portraitItems: Int = 5, landscapeItems: Int = 8) {
            self.portraitItems = portraitItems
            self.landscapeItems = landscapeItems
        }
    }

    public var phoneConfiguration: PhoneItemsConfiguration
    public var padConfiguration: PadItemsConfiguration
    #endif

    #if os(tvOS)
    public struct TvItemsConfiguration: Hashable {
        public let items: Int

        public init(items: Int = 8) {
            self.items = items
        }
    }

    public var tvConfiguration: TvItemsConfiguration
    #endif

    public var aspectRatio: CGFloat
    
    #if os(iOS)
    public init(
        phoneConfiguration: PhoneItemsConfiguration = .init(),
        padConfiguration: PadItemsConfiguration = .init(),
        aspectRatio: CGFloat
    ) {
        self.phoneConfiguration = phoneConfiguration
        self.padConfiguration = padConfiguration
        self.aspectRatio = aspectRatio
    }
    #endif

    #if os(tvOS)
    public init(
        tvConfiguration: TvItemsConfiguration = .init(),
        aspectRatio: CGFloat
    ) {
        self.tvConfiguration = tvConfiguration
        self.aspectRatio = aspectRatio
    }
    #endif
}
