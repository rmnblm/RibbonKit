//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

open class RibbonListViewDiffableDataSource<Section: Hashable, Item: Hashable>: NSObject {

    public typealias CellProvider = (_ ribbonList: RibbonListView, _ indexPath: IndexPath, _ itemIdentifier: Item) -> UICollectionViewCell?
    public typealias SupplementaryViewProvider = (_ ribbonList: RibbonListView, _ elementKind: String, _ indexPath: IndexPath) -> UICollectionReusableView?

    public var supplementaryViewProvider: SupplementaryViewProvider?

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private unowned let _ribbonList: RibbonListView

    public init(ribbonList: RibbonListView, cellProvider: @escaping RibbonListViewDiffableDataSource<Section, Item>.CellProvider) {
        self._ribbonList = ribbonList
        super.init()

        let sectionLeadingCellRegistration = UICollectionView.CellRegistration<RibbonListSectionLeadingCell, Item> { _, _, _ in }

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: _ribbonList.collectionView, cellProvider: {
            [unowned self] collectionView, indexPath, itemIdentifier in
            guard indexPath.item == 0,
                  let leadingCellView = _ribbonList.viewForLeadingCell(inSection: indexPath.section) else {
                return cellProvider(_ribbonList, indexPath, itemIdentifier)
            }
            let cell = collectionView.dequeueConfiguredReusableCell(using: sectionLeadingCellRegistration, for: indexPath, item: itemIdentifier)
            cell.setView(leadingCellView)
            cell.hideContentView = true
            _ribbonList.sectionsWithLeadingCellComponent.insert(indexPath.section)
            return cell
        })

        dataSource.supplementaryViewProvider = {
            [unowned self] collectionView, kind, indexPath in

            switch kind {
            case "header":
                let hostView: RibbonListReusableHostView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                if let headerView = _ribbonList.headerView {
                    hostView.setView(headerView)
                    hostView.isUserInteractionEnabled = headerView.isUserInteractionEnabled
                }
                return hostView
            default:
                return self.supplementaryViewProvider?(_ribbonList, kind, indexPath)
            }
        }
    }

    public func apply(
        _ snapshot: NSDiffableDataSourceSnapshot<Section, Item>,
        animatingDifferences animated: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        dataSource.apply(
            snapshot,
            animatingDifferences: animated,
            completion: completion
        )
    }

    public func apply(
        _ snapshot: NSDiffableDataSourceSectionSnapshot<Item>,
        to section: Section,
        animatingDifferences animated: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        dataSource.apply(
            snapshot,
            to: section,
            animatingDifferences: animated,
            completion: completion
        )
    }
    
    public func snapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        dataSource.snapshot()
    }

    public func snapshot(for section: Section) -> NSDiffableDataSourceSectionSnapshot<Item> {
        dataSource.snapshot(for: section)
    }

    public func sections() -> [Section] { dataSource.snapshot().sectionIdentifiers }
    public func item(for indexPath: IndexPath) -> Item? { dataSource.itemIdentifier(for: indexPath) }
}
