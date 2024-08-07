//  Copyright © 2020 Roman Blum. All rights reserved.

#if os(iOS)
import UIKit

final class RibbonCollectionView: UICollectionView {
    override func accessibilityElementCount() -> Int {
        guard let dataSource = dataSource else { return 0 }
        let numberOfSections = dataSource.numberOfSections?(in: self) ?? 1
        return (0..<numberOfSections)
            .reduce(0, { $0 + dataSource.collectionView(self, numberOfItemsInSection: $1) })
    }
}

final class RibbonCell: UITableViewCell, ReusableView {

    private var didRegisterCells = false

    private lazy var collectionViewLayout: PagingCollectionViewLayout = {
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private(set) lazy var collectionView: RibbonCollectionView = {
        let collectionView = RibbonCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.tag = 0
    }

    private func setupCell() {
        backgroundColor = .clear
        backgroundView = UIView()

        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func registerCellsIfNecessary(registrations: [CellRegistration]) {
        guard !didRegisterCells else { return }
        defer { didRegisterCells = true }
        registrations.forEach { collectionView.register($0.cellClass, forCellWithReuseIdentifier: $0.reuseIdentifier) }
    }

    func setConfiguration(_ configuration: RibbonConfiguration) {
        collectionViewLayout.sectionInset = configuration.sectionInsets
        collectionViewLayout.itemSize = configuration.itemSize
        collectionViewLayout.minimumLineSpacing = configuration.minimumLineSpacing
        collectionViewLayout.minimumInteritemSpacing = configuration.interItemSpacing
        collectionViewLayout.invalidateLayout()
    }
}
#endif
