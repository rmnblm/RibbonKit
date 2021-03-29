//  Copyright © 2020 Roman Blum. All rights reserved.

#if os(tvOS)
import UIKit

final class RibbonListReusableHeaderView: UICollectionReusableView, ReusableView {
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func setupView() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingTrailingConstant: CGFloat
        #if os(iOS)
        leadingTrailingConstant = 15
        #else
        leadingTrailingConstant = 0
        #endif
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailingConstant),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailingConstant),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
}
#endif
