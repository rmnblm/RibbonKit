//  Copyright © 2020 Roman Blum. All rights reserved.

import UIKit

final class RibbonListReusableHostView: UICollectionReusableView, ReusableView {

    private var currentView: UIView?

    override func prepareForReuse() {
        super.prepareForReuse()
        currentView?.removeFromSuperview()
    }

    func setView(_ view: UIView) {
        defer { currentView = view }
        currentView?.removeFromSuperview()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
