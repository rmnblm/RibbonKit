//  Copyright © 2020 Roman Blum. All rights reserved.

#if os(iOS)
import UIKit

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
        get { tableView.contentOffset }
        set { tableView.contentOffset = newValue }
    }

    /// The custom distance that the content view is inset from the safe area or scroll view edges.
    public var contentInset: UIEdgeInsets {
        get { tableView.contentInset }
        set { tableView.contentInset = newValue }
    }

    /// The view that is displayed above the table's content.
    ///
    /// Use this property to specify a header view for your entire list. The header view is the first item to appear in the list's view's scrolling content, and it is separate from the header views you add to individual sections. The default value of this property is nil.
    /// When assigning a view to this property, set the height of that view to a nonzero value. The ribbon list respects only the height of your view's frame rectangle; it adjusts the width of your header view automatically to match the ribbon list's width.
    open var headerView: UIView? {
        get { tableView.tableHeaderView }
        set { tableView.tableHeaderView = newValue }
    }

    /// The background view of the ribbon list.
    ///
    /// Assign a background view to change the color behind your ribbon list's sections and rows. The default value of this property is nil.
    /// When you assign a view to this property, the ribbon list automatically resizes that view to match its own bounds. Your background view appears behind all ribbons and does not scroll with the rest of the list's content.
    open var backgroundView: UIView? {
        get { tableView.backgroundView }
        set { tableView.backgroundView = newValue }
    }
    
    open override var mask: UIView? {
        get { tableView.mask }
        set { tableView.mask = newValue }
    }

    private let tableView: UITableView
    private var cellRegistrations: [CellRegistration] = []
    private var displayingCollectionViews: [Int: UICollectionView] = [:]
    private var storedOffsets: [Int: CGFloat] = [:]
    
    private var focusUpdatePreviouslyFocusedIndexPath: IndexPath?
    private var focusUpdateNextFocusedIndexPath: IndexPath?

    /// Initializes and returns a ribbon list having the given frame and style.
    ///
    /// - Parameters:
    ///     - frame: A rectangle specifying the initial location and size of the ribbon list in its superview’s coordinates. The frame of the table view changes as list cells are added and deleted. The default value is `.zero` for usage with UIKit's auto layout.
    ///     - style: A constant that specifies the style of the ribbon list. For a list of valid styles, see UITableView.Style. The default is `.grouped`.
    /// - Returns: Returns an initialized RibbonList object.
    public init(frame: CGRect = .zero, style: UITableView.Style = .grouped) {
        tableView = UITableView(frame: frame, style: style)
        super.init(frame: frame)
        setupView()
    }

    /// RibbonKit does not support initialization by storyboard or xib.
    ///
    /// Do not call this initializer. It will crash.
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        #if os(iOS)
        tableView.separatorStyle = .none
        #endif
        tableView.register(RibbonCell.self)
    }

    /// Returns the ribbon cell at the specified index path.
    ///
    ///
    /// - Parameters:
    ///     - indexPath: The index path locating the row in the ribbon list.
    /// - Returns: An object representing a cell of the list, or nil if the cell is not visible or indexPath is out of range.
    open func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        let collectionView = displayingCollectionViews[indexPath.section]
        let fakeIndexPath = IndexPath(row: indexPath.row, section: 0)
        return collectionView?.cellForItem(at: fakeIndexPath)
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
        cellRegistrations.append(.init(reuseIdentifier: identifier, cellClass: cellClass))
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
        let collectionView = displayingCollectionViews[indexPath.section]
        let fakeIndexPath = IndexPath(row: indexPath.row, section: 0)
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: identifier, for: fakeIndexPath) else {
            fatalError("Could not dequeue cell with reuse identifier \(identifier) for indexPath \(indexPath). Did you register the cell?")
        }
        return cell
    }

    /// Registers a class for use in creating new ribbon list header or footer views.
    ///
    /// Before dequeueing any header or footer views, call this method or the `register(_:forHeaderFooterViewReuseIdentifier:)` method to tell the ribbon list how to create new instances of your views. If a view of the specified type is not currently in a reuse queue, the ribbon list uses the provided information to create a one automatically.
    ///
    /// If you previously registered a class file with the same reuse identifier, the class you specify in the cellClass parameter replaces the old entry. You may specify nil for cellClass if you want to unregister the class from the specified reuse identifier.
    /// - Parameters:
    ///     - cellClass: The class of the header or footer view that you want to register. You must specify either `UITableViewHeaderFooterView` or a subclass of it.
    ///     - identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    open func register(_ cellClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        tableView.register(cellClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// Returns a reusable header or footer view located by its identifier.
    ///
    /// For performance reasons, a ribbon list's delegate should generally reuse `UITableViewHeaderFooterView` objects when it is asked to provide them. A ribbon list maintains a queue or list of `UITableViewHeaderFooterView` objects that the ribbon list's delegate has marked for reuse. It marks a view for reuse by assigning it a reuse identifier when it creates it (that is, in the `init(reuseIdentifier:)` method of `UITableViewHeaderFooterView`).
    ///
    /// You can use this method to access specific template header and footer views that you previously created. You can access a view’s reuse identifier through its `reuseIdentifier` property.
    ///
    /// - Parameters:
    ///     - identifier: A string identifying the header or footer view to be reused. This parameter must not be nil.
    open func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    /// Returns the header view associated with the specified section.
    ///
    /// - Parameters:
    ///     - section: An index number that identifies a section of the list.
    open func headerView(for section: Int) -> UITableViewHeaderFooterView? {
        tableView.headerView(forSection: section)
    }
    
    /// Sets the y-offset from the content view's origin that corresponds to the receiver's origin.
    open func setContentOffsetY(_ contentOffsetY: CGFloat, animated: Bool) {
        tableView.setContentOffset(.init(x: 0, y: contentOffsetY), animated: animated)
    }
    
    /// Retrieves layout information for an item at the specified index path with a corresponding cell.
    ///
    /// - Parameters:
    ///     - indexPath: The index path of the item.
    open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let collectionView = displayingCollectionViews[indexPath.section]
        let fakeIndexPath = IndexPath(row: indexPath.row, section: 0)
        return collectionView?.collectionViewLayout.layoutAttributesForItem(at: fakeIndexPath)
    }
    
    /// Retrieves layout information for an item at the specified index path with a corresponding cell.
    ///
    /// - Parameters:
    ///     - indexPath: The index path of the item.
    open func layoutAttributesForSupplementaryView(ofKind kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let collectionView = displayingCollectionViews[indexPath.section]
        let fakeIndexPath = IndexPath(row: indexPath.row, section: 0)
        return collectionView?.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: kind, at: fakeIndexPath)
    }
    
    /// TODO
    open func frameForCell(at indexPath: IndexPath) -> CGRect? {
        guard let cell = cellForItem(at: indexPath) else { return nil }
        return cell.convert(cell.frame, to: self)
    }
    
    /// TODO
    open func frameForHeader(at section: Int) -> CGRect? {
        guard let headerView = headerView(for: section) else { return nil }
        return headerView.frame
    }

    /// Reloads the items and sections of the ribbon list.
    ///
    /// Call this method to reload all the data that is used to construct the list, including items, section headers and footers, index arrays, and so on. For efficiency, the ribbon list redisplays only those rows that are visible. It adjusts offsets if the list shrinks as a result of the reload. The ribbon list's delegate or data source calls this method when it wants the ribbon list to completely reload its data.
    open func reloadData() {
        CATransaction.begin()
        displayingCollectionViews.removeAll()
        storedOffsets.removeAll()
        tableView.reloadData()
        CATransaction.commit()
    }

    private func sectionMutations(for indexPaths: [IndexPath]) -> [Int: [IndexPath]] {
        return indexPaths
            .reduce([Int: [IndexPath]]()) { (dict, indexPath) in
                var dict = dict
                dict[indexPath.section, default: []].append(IndexPath(item: indexPath.item, section: 0))
                return dict
            }
    }

    open func insertItems(at indexPaths: [IndexPath]) {
        let mutations = sectionMutations(for: indexPaths)
        mutations.forEach {
            guard let collectionView = displayingCollectionViews[$0.key] else { return }
            collectionView.insertItems(at: $0.value)
        }
    }

    open func deleteItems(at indexPaths: [IndexPath]) {
        let mutations = sectionMutations(for: indexPaths)
        mutations.forEach {
            guard let collectionView = displayingCollectionViews[$0.key] else { return }
            collectionView.deleteItems(at: $0.value)
        }
    }

    open func reloadItems(at indexPaths: [IndexPath]) {
        let mutations = sectionMutations(for: indexPaths)
        mutations.forEach {
            guard let collectionView = displayingCollectionViews[$0.key] else { return }
            collectionView.reloadItems(at: $0.value)
        }
    }

    open func reloadSection(at section: Int) {
        guard let collectionView = displayingCollectionViews[section] else { return }
        collectionView.reloadData()
    }
}

extension RibbonListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.ribbonList(self, heightForSectionAt: indexPath.section) ?? UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.ribbonList(self, heightForHeaderInSection: section) ?? .leastNormalMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return delegate?.ribbonList(self, heightForFooterInSection: section) ?? .leastNormalMagnitude
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.ribbonListDidScroll(self)
    }
}

extension RibbonListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource?.ribbonList(self, viewForHeaderInSection: section)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return dataSource?.ribbonList(self, viewForFooterInSection: section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RibbonCell = tableView.dequeueReusableCell(for: indexPath)
        displayingCollectionViews[indexPath.section] = cell.collectionView
        cell.registerCellsIfNecessary(registrations: cellRegistrations)
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.section
        cell.collectionView.contentOffset.x = storedOffsets[indexPath.section] ?? 0

        let configuration = dataSource?.ribbonList(self, configurationForSectionAt: indexPath.section) ?? .default
        cell.setConfiguration(configuration)

        return cell
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        displayingCollectionViews.removeValue(forKey: indexPath.section)
        guard let cell = cell as? RibbonCell else { return }
        storedOffsets[indexPath.section] = cell.collectionView.contentOffset.x
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?.ribbonList(self, titleForHeaderInSection: section)
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataSource?.ribbonList(self, titleForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let newContext: RibbonListViewFocusUpdateContext
        if context.previouslyFocusedIndexPath == nil && context.nextFocusedIndexPath != nil {
            newContext = RibbonListViewFocusUpdateContext(
                previouslyFocusedIndexPath: nil,
                nextFocusedIndexPath: focusUpdateNextFocusedIndexPath
            )
        }
        else if context.previouslyFocusedIndexPath != nil && context.nextFocusedIndexPath == nil {
            newContext = RibbonListViewFocusUpdateContext(
                previouslyFocusedIndexPath: focusUpdatePreviouslyFocusedIndexPath,
                nextFocusedIndexPath: nil
            )
        }
        else if context.previouslyFocusedIndexPath != nil && context.nextFocusedIndexPath != nil {
            newContext = RibbonListViewFocusUpdateContext(
                previouslyFocusedIndexPath: focusUpdatePreviouslyFocusedIndexPath,
                nextFocusedIndexPath: focusUpdateNextFocusedIndexPath
            )
        }
        else {
            newContext = RibbonListViewFocusUpdateContext(
                previouslyFocusedIndexPath: nil,
                nextFocusedIndexPath: nil
            )
        }
        
        focusUpdatePreviouslyFocusedIndexPath = nil
        focusUpdateNextFocusedIndexPath = nil
        
        delegate?.ribbonList(self, didUpdateFocusIn: newContext, with: coordinator)
    }
}

extension RibbonListView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        delegate?.ribbonList(self, didSelectItemAt: fakeIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        delegate?.ribbonList(self, didDeselectItemAt: fakeIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        delegate?.ribbonList(self, willDisplay: cell, forItemAt: fakeIndexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let previousIndexPath = context.previouslyFocusedIndexPath {
            focusUpdatePreviouslyFocusedIndexPath = IndexPath(row: previousIndexPath.row, section: collectionView.tag)
        }
        if let nextIndexPath = context.nextFocusedIndexPath {
            focusUpdateNextFocusedIndexPath = IndexPath(row: nextIndexPath.row, section: collectionView.tag)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        return delegate?.ribbonList(self, canFocusItemAt: fakeIndexPath) ?? true
    }

    #if os(iOS)
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        return delegate?.ribbonList(self, contextMenuConfigurationForItemAt: fakeIndexPath, point: point)
    }
    #endif
}

extension RibbonListView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.ribbonList(self, numberOfItemsInSection: collectionView.tag) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        return dataSource?.ribbonList(self, cellForItemAt: fakeIndexPath) ?? UICollectionViewCell()
    }
}
#endif
