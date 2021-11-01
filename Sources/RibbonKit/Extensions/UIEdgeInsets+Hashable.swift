//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

extension UIEdgeInsets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(NSCoder.string(for: self))
    }
}
