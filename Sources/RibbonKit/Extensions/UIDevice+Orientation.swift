//  Copyright © 2022 Roman Blum. All rights reserved.

#if os(iOS)

import UIKit

extension UIDevice {
    var isLandscape: Bool {
        if orientation == .unknown || orientation == .faceUp || orientation == .faceDown {
            return UIApplication.shared
                .windows
                .first(where: { $0.isKeyWindow })?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? true
        }
        return [UIDeviceOrientation.landscapeLeft, .landscapeRight].contains(orientation)
    }

    var isPortrait: Bool {
        if orientation == .unknown || orientation == .faceUp || orientation == .faceDown {
            return UIApplication.shared
                .windows
                .first(where: { $0.isKeyWindow })?
                .windowScene?
                .interfaceOrientation
                .isPortrait ?? true
        }
        return [UIDeviceOrientation.portrait, .portraitUpsideDown].contains(orientation)
    }
}

#endif
