//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

class RibbonListSectionLeadingCell: UICollectionViewCell, ReusableView {

    var currentView: UIView?

    var hideContentView: Bool = false {
        didSet {
            guard oldValue != hideContentView else { return }
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                currentView?.alpha = hideContentView ? 0.0 : 1.0
            }
        }
    }

    override var canBecomeFocused: Bool { false }

    required init?(coder: NSCoder) { nil }

    override init(frame: CGRect) {
        super.init(frame: frame)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        isUserInteractionEnabled = true
        currentView?.removeFromSuperview()
    }
}
