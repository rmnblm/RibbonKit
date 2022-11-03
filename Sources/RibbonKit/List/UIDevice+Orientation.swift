//  Copyright © 2022 Roman Blum. All rights reserved.

import UIKit

extension UIDevice {
    var isLandscape: Bool {
        if orientation == .unknown {
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
        if orientation == .unknown {
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
