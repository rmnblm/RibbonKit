//  Copyright © 2020 Roman Blum. All rights reserved.

import UIKit

#if os(tvOS)
/// A view that presents data using paginated items arranged in rows.
open class RibbonListView: UIView {

    /// The object that acts as the data source of the ribbon list.
    ///
    /// The data source must adopt the RibbonListViewDataSource protocol. The data source is not retained.
    open weak var dataSource: RibbonListViewDataSource?

    /// The object that acts as the delegate of the ribbon list.
    ///
    /// The delegate must adopt the RibbonListViewDelegate protocol. The delegate is not retained.
    open weak var delegate: RibbonListViewDelegate?

    /// The point at which the origin of the content view is offset from the origin of the scroll view.
    ///
    /// The default value is `.zero`.
    public var contentOffset: CGPoint {
        get { collectionView.contentOffset }
        set { collectionView.contentOffset = newValue }
    }

    /// The custom distance that the content view is inset from the safe area or scroll view edges.
    public var contentInset: UIEdgeInsets {
        get { collectionView.contentInset }
        set { collectionView.contentInset = newValue }
    }
    
    /// A Boolean value that determines whether scrolling is enabled.
    public var isScrollEnabled: Bool {
        get { collectionView.isScrollEnabled }
        set { collectionView.isScrollEnabled = newValue }
    }

    /// The section's scrolling behavior in relation to the main layout axis.
    public var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuousGroupLeadingBoundary

    /// The background view of the ribbon list.
    ///
    /// Assign a background view to change the color behind your ribbon list's sections and rows. The default value of this property is nil.
    /// When you assign a view to this property, the ribbon list automatically resizes that view to match its own bounds. Your background view appears behind all ribbons and does not scroll with the rest of the list's content.
    open var backgroundView: UIView? {
        get { collectionView.backgroundView }
        set { collectionView.backgroundView = newValue }
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: buildLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        collectionView.register(RibbonListResaubleHostView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(RibbonListResaubleHostView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        collectionView.register(RibbonListReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(RibbonListReusableFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()

    /// Initializes and returns a ribbon list having the given frame.
    ///
    /// - Parameters:
    ///     - frame: A rectangle specifying the initial location and size of the ribbon list in its superview’s coordinates. The frame of the table view changes as list cells are added and deleted. The default value is `.zero` for usage with UIKit's auto layout.
    /// - Returns: Returns an initialized RibbonList object.
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    /// RibbonKit does not support initialization by storyboard or xib.
    ///
    /// Do not call this initializer. It will crash.
    required public init?(coder: NSCoder) { nil }
    
    private func setupView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    /// Returns the ribbon cell at the specified index path.
    ///
    ///
    /// - Parameters:
    ///     - indexPath: The index path locating the row in the ribbon list.
    /// - Returns: An object representing a cell of the list, or nil if the cell is not visible or indexPath is out of range.
    open func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return collectionView.cellForItem(at: indexPath)
    }

    /// Registers a class for use in creating new ribbon list cells.
    ///
    /// Prior to dequeueing any cells, call this method or the `register(_:forCellReuseIdentifier:)` method to tell the ribbon list how to create new cells. If a cell of the specified type is not currently in a reuse queue, the ribbon list uses the provided information to create a new cell object automatically.
    ///
    /// If you previously registered a class with the same reuse identifier, the class you specify in the cellClass parameter replaces the old entry. You may specify nil for cellClass if you want to unregister the class from the specified reuse identifier.
    ///
    /// - Parameters:
    ///     - cellClass: The class of a cell that you want to use in the list (must be a UICollectionViewCell subclass).
    ///     - identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    open func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    /// Returns a reusable ribbon-list cell object for the specified reuse identifier and adds it to the list.
    ///
    /// Call this method only from the `ribbonList(_:cellForItemAt:)` method of your ribbon list data source object. This method returns an existing cell of the specified type, if one is available, or it creates and returns a new cell using the class or storyboard you provided earlier. Do not call this method outside of your data source's `ribbonList(_:cellForItemAt:)` method.
    ///
    /// - Parameters:
    ///     - identifier: A string identifying the cell object to be reused. This parameter must not be nil.
    ///     - indexPath: The index path specifying the location of the cell. Always specify the index path provided to you by your data source object. This method uses the index path to perform additional configuration based on the cell’s position in the ribbon list.
    /// - Returns: A UICollectionViewCell object with the associated reuse identifier. This method always returns a valid cell.
    open func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    /// Registers a class for use in creating supplementary views for the ribbon list.
    ///
    /// Prior to calling the `dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:)` method of the ribbon list, you must use this method or the `register(_:forSupplementaryViewOfKind:withReuseIdentifier:)` method to tell the ribbon list how to create a supplementary view of the given type. If a view of the specified type is not currently in a reuse queue, the ribbon list uses the provided information to create a view object automatically.
    ///
    /// If you previously registered a class file with the same reuse identifier, the class you specify in the cellClass parameter replaces the old entry. You may specify nil for cellClass if you want to unregister the class from the specified reuse identifier.
    /// - Parameters:
    ///     - viewClass: The class to use for the supplementary view.
    ///     - elementKind: The kind of supplementary view to create. This value is defined by the layout object. This parameter must not be nil.
    ///     - identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    open func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        collectionView.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
    }

    /// Dequeues a reusable supplementary view located by its identifier and kind.
    ///
    /// Call this method from your data source object when asked to provide a new supplementary view for the ribbon list. This method dequeues an existing view if one is available or creates a new one based on the class file you previously registered.
    ///
    /// You can use this method to access specific template header and footer views that you previously created. You can access a view’s reuse identifier through its `reuseIdentifier` property.
    ///
    /// - Parameters:
    ///     - elementKind: The kind of supplementary view to retrieve. This value is defined by the layout object. This parameter must not be nil.
    ///     - identifier: The reuse identifier for the specified view. This parameter must not be nil.
    ///     - indexPath: The index path specifying the location of the supplementary view in the ribbon list. The data source receives this information when it is asked for the view and should just pass it along. This method uses the information to perform additional configuration based on the view’s position in the ribbon list.
    open func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
    
    /// Sets the y-offset from the content view's origin that corresponds to the receiver's origin.
    open func setContentOffsetY(_ contentOffsetY: CGFloat, animated: Bool) {
        collectionView.setContentOffset(.init(x: 0, y: contentOffsetY), animated: animated)
    }

    /// Reloads the items and sections of the ribbon list.
    ///
    /// Call this method to reload all the data that is used to construct the list, including items, section headers and footers, index arrays, and so on. For efficiency, the ribbon list redisplays only those rows that are visible. It adjusts offsets if the list shrinks as a result of the reload. The ribbon list's delegate or data source calls this method when it wants the ribbon list to completely reload its data.
    open func reloadData() {
        CATransaction.begin()
        collectionView.reloadData()
        CATransaction.commit()
    }

    open func insertItems(at indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
    }

    open func deleteItems(at indexPaths: [IndexPath]) {
        collectionView.deleteItems(at: indexPaths)
    }

    open func reloadItems(at indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }

    open func reloadSection(at sections: IndexSet) {
        collectionView.reloadSections(sections)
    }
    
    public func frameForHeader(in section: Int) -> CGRect? {
        collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))?.frame
    }
    
    public func frameForFooter(in section: Int) -> CGRect? {
        collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section))?.frame
    }
    
    public func frameForCell(at indexPath: IndexPath) -> CGRect? {
        collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame
    }
    
    private func buildLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let configuration = self.dataSource?.ribbonList(self, configurationForSectionAt: sectionIndex) ?? .default
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / CGFloat(configuration.numberOfRows)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(configuration.itemSize.width),
                heightDimension: .absolute(self.delegate?.ribbonList(self, heightForSectionAt: sectionIndex) ?? configuration.calculatedSectionHeight())
            )
            let group: NSCollectionLayoutGroup
            if configuration.numberOfRows > 1 {
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: configuration.numberOfRows)
            }
            else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            }
            group.interItemSpacing = .fixed(configuration.interGroupSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = configuration.interItemSpacing
            section.orthogonalScrollingBehavior = self.orthogonalScrollingBehavior
            section.contentInsets = .init(
                top: configuration.sectionInsets.top,
                leading: configuration.sectionInsets.left,
                bottom: configuration.sectionInsets.bottom,
                trailing: configuration.sectionInsets.right
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(self.delegate?.ribbonList(self, heightForHeaderInSection: sectionIndex) ?? 44.0)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(self.delegate?.ribbonList(self, heightForFooterInSection: sectionIndex) ?? 44.0)
                ),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottomLeading
            )
            section.boundarySupplementaryItems = [header, footer]
            return section
        }
    }
}

extension RibbonListView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.ribbonList(self, didSelectItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.ribbonList(self, didDeselectItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.ribbonList(self, willDisplay: cell, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        let newContext = RibbonListViewFocusUpdateContext(previouslyFocusedIndexPath: context.previouslyFocusedIndexPath, nextFocusedIndexPath: context.nextFocusedIndexPath)
        return delegate?.ribbonList(self, shouldUpdateFocusIn: newContext) ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let newContext = RibbonListViewFocusUpdateContext(previouslyFocusedIndexPath: context.previouslyFocusedIndexPath, nextFocusedIndexPath: context.nextFocusedIndexPath)
        delegate?.ribbonList(self, didUpdateFocusIn: newContext, with: coordinator)
    }
    
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return delegate?.ribbonList(self, canFocusItemAt: indexPath) ?? true
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.ribbonListDidScroll(self)
    }

    #if os(iOS)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return delegate?.ribbonList(self, contextMenuConfigurationForItemAt: indexPath, point: point)
    }
    #endif
}

extension RibbonListView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let title = dataSource?.ribbonList(self, titleForHeaderInSection: indexPath.section) {
                let headerView: RibbonListReusableHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                headerView.label.text = title
                return headerView
            }
            let view: RibbonListResaubleHostView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            view.hostView = dataSource?.ribbonList(self, viewForHeaderInSection: indexPath.section)
            return view
        case UICollectionView.elementKindSectionFooter:
            if let title = dataSource?.ribbonList(self, titleForFooterInSection: indexPath.section) {
                let footerView: RibbonListReusableFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                footerView.label.text = title
                return footerView
            }
            let view: RibbonListResaubleHostView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            view.hostView = dataSource?.ribbonList(self, viewForFooterInSection: indexPath.section)
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.ribbonList(self, numberOfItemsInSection: section) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource?.ribbonList(self, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
}
#endif
