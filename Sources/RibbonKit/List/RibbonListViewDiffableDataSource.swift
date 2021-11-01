//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

open class RibbonListViewDiffableDataSource<Section: Hashable, Item: Hashable>: NSObject {

    public typealias CellProvider = (_ ribbonList: RibbonListView, _ indexPath: IndexPath, _ itemIdentifier: Item) -> UICollectionViewCell?
    public typealias SupplementaryViewProvider = (_ ribbonList: RibbonListView, _ elementKind: String, _ indexPath: IndexPath) -> UICollectionReusableView?

    public var supplementaryViewProvider: SupplementaryViewProvider?

    private let dataSource: UICollectionViewDiffableDataSource<Section, Item>

    public init(ribbonList: RibbonListView, cellProvider: @escaping RibbonListViewDiffableDataSource<Section, Item>.CellProvider) {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: ribbonList.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            cellProvider(ribbonList, indexPath, itemIdentifier)
        })
        super.init()
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            switch kind {
            case "header":
                let hostView: RibbonListReusableHostView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                if let headerView = ribbonList.headerView {
                    hostView.setView(headerView)
                }
                return hostView
            default:
                return self?.supplementaryViewProvider?(ribbonList, kind, indexPath)
            }
        }
    }

    public func apply(_ snapshot: RibbonListViewDiffableDataSourceSnapshot<Section, Item>) {
        dataSource.apply(snapshot.snapshot)
    }
}
