//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit

extension UIEdgeInsets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(NSCoder.string(for: self))
    }
}
