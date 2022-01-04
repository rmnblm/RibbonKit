//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public enum RibbonListDimension: Hashable {
    case estimated(CGFloat)
    case absolute(CGFloat)
    case fractionalHeight(CGFloat)
    case fractionalWidth(CGFloat)

    public static var zero: RibbonListDimension { .absolute(0.0) }

    var value: CGFloat {
        switch self {
        case .absolute(let value),
            .estimated(let value),
            .fractionalHeight(let value),
            .fractionalWidth(let value):
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
        case .fractionalWidth(let value):
            return .fractionalWidth(value)
        }
    }
}
