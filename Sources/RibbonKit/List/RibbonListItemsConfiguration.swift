//  Copyright © 2021 Roman Blum. All rights reserved.

import Foundation

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
    
    public var phoneConfiguration: PhoneItemsConfiguration
    public var padConfiguration: PadItemsConfiguration
    
    static var `default` = ItemsConfiguration(phoneConfiguration: .init(), padConfiguration: .init())

    public init(
        phoneConfiguration: PhoneItemsConfiguration,
        padConfiguration: PadItemsConfiguration
    ) {
        self.phoneConfiguration = phoneConfiguration
        self.padConfiguration = padConfiguration
    }
}
