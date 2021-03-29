//  Copyright © 2020 Roman Blum. All rights reserved.

import UIKit

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(NSCoder.string(for: self))
    }
}
