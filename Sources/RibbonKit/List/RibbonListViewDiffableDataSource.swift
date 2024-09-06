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

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: _ribbonList.collectionView, cellProvider: {
            [unowned self] _, indexPath, itemIdentifier in
            cellProvider(_ribbonList, indexPath, itemIdentifier)
        })

        dataSource.supplementaryViewProvider = {
            [unowned self] collectionView, kind, indexPath in

            switch kind {
            case RibbonListView.Constants.supplementaryLeadingKind:
                let hostView: RibbonListSectionLeadingCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                if let leadingCellView = _ribbonList.viewForLeadingCell(inSection: indexPath.section) {
                    hostView.setView(leadingCellView)
                    #if os(tvOS)
                    if let focusedCell = _ribbonList.collectionView.visibleCells.first(where: { $0.isFocused }),
                       let focusedIndexPath = _ribbonList.collectionView.indexPath(for: focusedCell) {
                        if _ribbonList.shouldHideLeadingCellOnFocusLoss(inSection: indexPath.section) {
                            hostView.hideContentView = focusedIndexPath.section != indexPath.section
                        }
                    }
                    else if _ribbonList.shouldHideLeadingCellOnFocusLoss(inSection: indexPath.section) {
                        hostView.hideContentView = true
                    }
                    #endif
                    _ribbonList.sectionsWithLeadingCellComponent.insert(indexPath.section)
                }
                else {
                    _ribbonList.sectionsWithLeadingCellComponent.remove(indexPath.section)
                }
                return hostView
            case RibbonListView.Constants.headerKind:
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

    public func reconfigureItem(_ itemId: Item, animatingDifferences: Bool = true) {
        reconfigureItems([itemId], animatingDifferences: animatingDifferences)
    }

    public func reconfigureItems(_ itemIds: [Item], animatingDifferences: Bool = true) {
        var snapshot = snapshot()
        snapshot.reconfigureItems(itemIds)
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
