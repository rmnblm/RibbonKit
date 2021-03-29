//  Copyright © 2020 Roman Blum. All rights reserved.

#if os(tvOS)
import UIKit

final class RibbonListResaubleHostView: UICollectionReusableView, ReusableView {
    override func prepareForReuse() {
        super.prepareForReuse()
        hostView?.removeFromSuperview()
    }

    var hostView: UIView? {
        willSet {
            hostView?.removeFromSuperview()
            guard let view = newValue else { return }
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            updateConstraintsIfNeeded()
        }
    }
}
#endif
