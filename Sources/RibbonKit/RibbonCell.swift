//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit

class RibbonCell: UITableViewCell, ReusableView {

    var configuration: RibbonConfiguration?

    private var didRegisterCells = false

    private(set) lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.tag = 0
        configuration = nil
    }

    private func setupCell() {
        backgroundColor = .clear
        backgroundView = nil

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
}
