//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public enum RibbonListLayoutDimension: Hashable {
    case estimated(CGFloat)
    case absolute(CGFloat)
    case fractionalHeight(CGFloat)

    public static var zero: RibbonListLayoutDimension { .absolute(0.0) }

    var value: CGFloat {
        switch self {
        case .absolute(let value), .estimated(let value), .fractionalHeight(let value):
            return value
        }
    }

    var uiDimension: NSCollectionLayoutDimension {
        switch self {
        case .absolute(let value):
            return .absolute(value)
        case .estimated(let value):
            return .estimated(value)
        case .fractionalHeight(let value):
            return .fractionalHeight(value)
        }
    }
}
