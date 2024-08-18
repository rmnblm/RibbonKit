//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

/// A view that presents data using paginated items arranged in rows.
open class RibbonListView: UIView {

    struct Constants {
        static let headerKind = "header"
        static let supplementaryLeftKind = "supplementaryLeft"
        static let sectionBackgroundKind = "sectionBackground"
    }

    /// The object that acts as the delegate of the ribbon list.
    ///
    /// The delegate must adopt the RibbonListViewDelegate protocol. The delegate is not retained.
    public weak var delegate: RibbonListViewDelegate?

    /// The point at which the origin of the content view is offset from the origin of the scroll view.
    ///
    /// The default value is `.zero`.
    public var contentOffset: CGPoint {
        get { collectionView.contentOffset }
        set { collectionView.contentOffset = newValue }
    }

    /// The size of the content view.
    public var contentSize: CGSize {
        collectionView.contentSize 
    }

    /// A Boolean value that controls whether the scroll indicators are visible.
    public var showsScrollIndicators: Bool {
        get {
            collectionView.showsVerticalScrollIndicator
            && collectionView.showsHorizontalScrollIndicator
        }
        set {
            collectionView.showsVerticalScrollIndicator = newValue
            collectionView.showsHorizontalScrollIndicator = newValue
        }
    }

    /// The custom distance that the content view is inset from the safe area or scroll view edges.
    public var contentInset: UIEdgeInsets {
        get { collectionView.contentInset }
        set { collectionView.contentInset = newValue }
    }

    /// The insets derived from the content insets and the safe area of the scroll view.
    public var adjustedContentInset: UIEdgeInsets {
        collectionView.adjustedContentInset
    }

    /// The vertical distance the scroll indicators are inset from the edge of the scroll view.
    public var verticalScrollIndicatorInsets: UIEdgeInsets {
        get { collectionView.verticalScrollIndicatorInsets }
        set { collectionView.verticalScrollIndicatorInsets = newValue }
    }

    public var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior {
        get { collectionView.contentInsetAdjustmentBehavior }
        set { collectionView.contentInsetAdjustmentBehavior = newValue }
    }

    /// The ribbon list's horizontal scrolling behavior.
    public var horizontalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuousGroupLeadingBoundary

    /// The ribbon list's vertical scrolling behavior.
    public var verticalScrollingBehaviour: RibbonListViewScrollingBehaviour = .sectionPaging

    /// The view that is displayed above the table's content.
    ///
    /// Use this property to specify a header view for your entire list. The header view is the first item to appear in the list's view's scrolling content, and it is separate from the header views you add to individual sections. The default value of this property is nil.
    /// When assigning a view to this property, a height must be specified using the delegate method `func ribbonListHeaderHeight(_:) -> RibbonListDimension`, returning a non-negative floating-point value.
    /// The ribbon list respects only the height of your view's frame rectangle; it adjusts the width of your header view automatically to match the ribbon list's width.
    public var headerView: UIView?

    /// The background view of the ribbon list.
    ///
    /// Assign a background view to change the color behind your ribbon list's sections and rows. The default value of this property is nil.
    /// When you assign a view to this property, the ribbon list automatically resizes that view to match its own bounds. Your background view appears behind all ribbons and does not scroll with the rest of the list's content.
    public var backgroundView: UIView? {
        get { collectionView.backgroundView }
        set { collectionView.backgroundView = newValue }
    }
    
    /// An array of visible cells currently displayed by the ribbon list.
    ///
    /// This method returns the complete list of visible cells displayed by the ribbon list.
    public var visibleCells: [UICollectionViewCell] { collectionView.visibleCells }

    private var layout: UICollectionViewCompositionalLayout!
    public private(set) var collectionView: UICollectionView!

    private var previouslyFocusedIndexPath: IndexPath?
    private var currentlyFocusedIndexPath: IndexPath?

    /// Initializes and returns a ribbon list having the given frame.
    ///
    /// - Parameters:
    ///     - frame: A rectangle specifying the initial location and size of the ribbon list in its superview’s coordinates. The frame of the table view changes as list cells are added and deleted. The default value is `.zero` for usage with UIKit's auto layout.
    /// - Returns: Returns an initialized RibbonList object.
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layout = buildLayout()
        collectionView = createCollectionView(using: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(RibbonListReusableHostView.self, forSupplementaryViewOfKind: Constants.headerKind)
        collectionView.register(RibbonListSectionLeadingCell.self, forSupplementaryViewOfKind: Constants.supplementaryLeftKind)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        #if os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceOrientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        #endif
    }

    deinit {
        #if os(iOS)
        NotificationCenter.default.removeObserver(self)
        #endif
    }

    #if os(iOS)
    @objc private func deviceOrientationDidChange(_ notification: Notification) {
        let orientation = UIDevice.current.orientation
        let unsupportedOrientations: [UIDeviceOrientation] = [.faceUp, .faceDown]
        guard !unsupportedOrientations.contains(orientation) else { return }
        reloadLayout()
    }
    #endif

    /// RibbonKit does not support initialization by storyboard or xib.
    ///
    /// Do not call this initializer. It will crash.
    required public init?(coder: NSCoder) { nil }

    /// Returns the collection view during initialization. Use this function to use an inherited UICollectionView.
    ///
    /// - Parameters:
    ///     - layout: The reference to the layout used during the lifetime of the ribbon list.
    /// - Returns: An object representing the underlying collection view.
    open func createCollectionView(using layout: UICollectionViewCompositionalLayout) -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    /// Invalidates the view’s and underlying collection view's intrinsic content size.
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        collectionView.invalidateIntrinsicContentSize()
    }

    /// Returns the ribbon cell at the specified index path.
    ///
    /// - Parameters:
    ///     - indexPath: The index path locating the row in the ribbon list.
    /// - Returns: An object representing a cell of the list, or nil if the cell is not visible or indexPath is out of range.
    public func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        collectionView.cellForItem(at: indexPath)
    }

    /// Gets the supplementary view at the specified index path.
    ///
    /// - Parameters:
    ///     - elementKind: The kind of supplementary view to locate. This value is defined by the layout object.
    ///     - indexPath: The index path of the supplementary view.
    public func supplementaryView(forElementKind elementKind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        collectionView.supplementaryView(forElementKind: elementKind, at: indexPath)
    }

    /// Dequeues a configured reusable cell object.
    ///
    /// - Parameters:
    ///     - registration: The cell registration for configuring the cell object.
    ///     - indexPath: The index path that specifies the location of the cell in the collection view.
    ///     - item: The item that provides data for the cell.
    /// - Returns: A configured reusable cell object.
    public func dequeueConfiguredReusableCell<Cell, Item>(using registration: UICollectionView.CellRegistration<Cell, Item>, for indexPath: IndexPath, item: Item?) -> Cell where Cell: UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
    }

    /// Dequeues a configured reusable supplementary view object.
    ///
    /// - Parameters:
    ///     - registration: The supplementary registration for configuring the supplementary view object.
    ///     - indexPath: The index path that specifies the location of the supplementary view in the collection view.
    /// - Returns: A configured reusable supplementary view object.
    public func dequeueConfiguredReusableSupplementary<Supplementary>(using registration: UICollectionView.SupplementaryRegistration<Supplementary>, for indexPath: IndexPath) -> Supplementary where Supplementary: UICollectionReusableView {
        collectionView.dequeueConfiguredReusableSupplementary(using: registration, for: indexPath)
    }
    
    /// Sets the offset from the content view’s origin that corresponds to the receiver’s origin.
    public func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        collectionView.setContentOffset(contentOffset, animated: animated)
    }

    /// Reloads the items and sections of the ribbon list.
    ///
    /// Call this method to reload all the data that is used to construct the list, including items, section headers and footers, index arrays, and so on. For efficiency, the ribbon list redisplays only those rows that are visible. It adjusts offsets if the list shrinks as a result of the reload. The ribbon list's delegate or data source calls this method when it wants the ribbon list to completely reload its data.
    public func reloadData() {
        collectionView.reloadData()
    }

    /// Reloads the RibbonList's layout.
    public func reloadLayout() {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        if headerView != nil {
            let headerSize = delegate?.ribbonListHeaderHeight(self) ?? .estimated(44)
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: headerSize.uiDimension
                ),
                elementKind: Constants.headerKind,
                alignment: .top
            )
            header.zIndex = 1000
            config.boundarySupplementaryItems = [header]
        }
        config.interSectionSpacing = interSectionSpacing
        layout.configuration = config
    }

    /// The amount of space between the sections in the layout.
    ///
    /// The default value of this property is 0.0.
    public var interSectionSpacing: CGFloat = 0 {
        didSet {
            reloadLayout()
        }
    }

    /// Retrieves layout information for an item at the specified index path with a corresponding cell.
    ///
    /// - Parameters:
    ///     - indexPath: The index path of the item.
    /// - Returns: A layout attributes object containing the information to apply to the item’s cell.
    public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)
    }

    /// Retrieves the layout attributes for the specified supplementary view.
    ///
    /// - Parameters:
    ///     - kind: A string that identifies the type of the supplementary view.
    ///     - indexPath: The index path of the item.
    /// - Returns: A layout attributes object containing the information to apply to the supplementary view.
    public func layoutAttributesForSupplementaryView(ofKind kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: kind, at: indexPath)
    }

    public var isScrolledToTop: Bool {
        contentOffset.y == -adjustedContentInset.top
    }

    public private(set) var isScrollingToTop = false
    public func scrollToTop() {
        guard !isScrolledToTop, !isScrollingToTop else { return }
        isScrollingToTop = true
        setContentOffset(CGPoint(x: contentOffset.x, y: -adjustedContentInset.top), animated: true)
    }

    private func buildLayout() -> UICollectionViewCompositionalLayout {
        let layout = RibbonListViewCompositionalLayout(sectionProvider: {
            [weak self] sectionIndex, layoutEnvironment in
            guard let self else { return nil }

            let configuration = delegate?.ribbonList(self, configurationForSectionAt: sectionIndex) ?? .default
            let section: NSCollectionLayoutSection
            if configuration.layout.orientation == .single {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: configuration.layout.heightDimension.uiDimension
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: configuration.layout.heightDimension.uiDimension
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = horizontalScrollingBehavior
            } else if configuration.layout.orientation == .vertical {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1 / CGFloat(configuration.layout.numberOfRows))
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: configuration.layout.itemWidthDimensions.first?.uiDimension ?? .estimated(80),
                    heightDimension: configuration.layout.heightDimension.uiDimension
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitem: item,
                    count: configuration.layout.numberOfRows
                )
                group.interItemSpacing = .fixed(configuration.interItemSpacing)
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = horizontalScrollingBehavior
            }
            else if case .horizontal(let leadingCellWidth) = configuration.layout.orientation {
                let items: [NSCollectionLayoutItem] = (0..<configuration.layout.itemWidthDimensions.count).map { itemIndex in
                    let itemWidth = configuration.layout.itemWidthDimensions[itemIndex]
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: itemWidth.uiDimension,
                        heightDimension: .fractionalHeight(1)
                    )
                    return NSCollectionLayoutItem(layoutSize: itemSize)
                }
                
                let itemGroupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(1),
                    heightDimension: configuration.layout.heightDimension.uiDimension
                )
                let itemsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: itemGroupSize, subitems: items)
                
                if let leadingCellWidth {
                    let supplementarySize = NSCollectionLayoutSize(
                        widthDimension: leadingCellWidth.uiDimension,
                        heightDimension: configuration.layout.heightDimension.uiDimension
                    )
                    itemsGroup.supplementaryItems = [NSCollectionLayoutSupplementaryItem(
                        layoutSize: supplementarySize,
                        elementKind: Constants.supplementaryLeftKind,
                        containerAnchor: NSCollectionLayoutAnchor(edges: [.leading, .top]),
                        itemAnchor: NSCollectionLayoutAnchor(edges: [.trailing, .top])
                    )]
                }
                itemsGroup.interItemSpacing = .fixed(configuration.interItemSpacing)
                section = NSCollectionLayoutSection(group: itemsGroup)
                section.orthogonalScrollingBehavior = horizontalScrollingBehavior
            }
            else if case .wall(let config) = configuration.layout.orientation {
                var numberOfItems = 1
                #if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .phone {
                    numberOfItems = UIDevice.current.isPortrait ? config.phoneConfiguration.portraitItems : config.phoneConfiguration.landscapeItems
                } else if UIDevice.current.userInterfaceIdiom == .pad {
                    numberOfItems = UIDevice.current.isPortrait ? config.padConfiguration.portraitItems : config.padConfiguration.landscapeItems
                }
                #endif

                #if os(tvOS)
                numberOfItems = config.tvConfiguration.items
                #endif

                let fWidth = 1.0 / CGFloat(numberOfItems)
                let fHeight = fWidth * config.aspectRatio
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(fWidth),
                    heightDimension: .fractionalWidth(fHeight)
                )

                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(fHeight)
                )

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfItems)
                group.interItemSpacing = .fixed(configuration.interItemSpacing)

                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
            }
            else if case .list(let config) = configuration.layout.orientation {
                section = NSCollectionLayoutSection.list(
                    using: config.asCollectionLayoutListConfiguration(),
                    layoutEnvironment: layoutEnvironment
                )
            }
            else {
                let listConfig: UICollectionLayoutListConfiguration = .init(appearance: .plain)
                section = NSCollectionLayoutSection.list(
                    using: listConfig,
                    layoutEnvironment: layoutEnvironment
                )
            }

            if configuration.layout.orientation != .single {
                section.interGroupSpacing = configuration.interGroupSpacing
                var leadingInset: CGFloat = configuration.sectionInsets.left
                if case .horizontal(let leadingCellWidth) = configuration.layout.orientation,
                   leadingCellWidth != nil,
                   configuration.sectionInsets.left == 0 {
                    // Cheap Trick: With no inset the supplementary left view won't be dequeued nor presented on screen
                    leadingInset = 0.1
                }
                section.contentInsets = .init(
                    top: configuration.sectionInsets.top,
                    leading: leadingInset,
                    bottom: configuration.sectionInsets.bottom,
                    trailing: configuration.sectionInsets.right
                )
            }

            var header: NSCollectionLayoutBoundarySupplementaryItem?
            if let headerHeight = delegate?.ribbonList(self, heightForHeaderInSection: sectionIndex), headerHeight.value > 0.0 {
                header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: headerHeight.uiDimension
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .topLeading
                )
            }

            var footer: NSCollectionLayoutBoundarySupplementaryItem?
            if let footerHeight = delegate?.ribbonList(self, heightForFooterInSection: sectionIndex), footerHeight.value > 0.0 {
                footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: footerHeight.uiDimension
                    ),
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottomLeading
                )
            }

            section.boundarySupplementaryItems = [header, footer].compactMap { $0 }

            let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: Constants.sectionBackgroundKind)
            section.decorationItems = [sectionBackground]
            return section
        })
        layout.delegate = self
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: Constants.sectionBackgroundKind)
        return layout
    }
    
    private var presentingContextMenuIndexPath: IndexPath?
    private var forcedFocusIndexPath: IndexPath?
    var sectionsWithLeadingCellComponent = Set<Int>()
}

extension RibbonListView: RibbonListViewCompositionalLayoutDelegate {
    func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        switch verticalScrollingBehaviour {
        case .none:
            return proposedContentOffset
        case .manual:
            return delegate?.ribbonList(self, targetContentOffsetForProposedContentOffset: proposedContentOffset) ?? proposedContentOffset
        case .itemPaging:
            guard let currentlyFocusedIndexPath else {
                return proposedContentOffset
            }

            if let cellFrame = collectionView.collectionViewLayout.layoutAttributesForItem(at: currentlyFocusedIndexPath)?.frame {
                return .init(x: proposedContentOffset.x, y: cellFrame.origin.y - contentInset.top)
            }

            return proposedContentOffset
        case .sectionPaging:
            guard let currentlyFocusedIndexPath else {
                return proposedContentOffset
            }

            let sectionHeaderIndexPath = IndexPath(item: 0, section: currentlyFocusedIndexPath.section)
            if let headerFrame = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader, at: sectionHeaderIndexPath
            )?.frame {
                return .init(x: proposedContentOffset.x, y: headerFrame.origin.y - contentInset.top)
            }

            if let cellFrame = collectionView.collectionViewLayout.layoutAttributesForItem(at: currentlyFocusedIndexPath)?.frame {
                return .init(x: proposedContentOffset.x, y: cellFrame.origin.y - contentInset.top)
            }

            return proposedContentOffset
        }
    }
}

extension RibbonListView: UICollectionViewDelegate {
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isScrolledToTop {
            isScrollingToTop = false
            delegate?.ribbonListDidScrollToTop(self)
        }
        delegate?.ribbonListDidEndScrollingAnimation(self)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.ribbonListWillBeginDecelerating(self)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.ribbonListDidEndDecelerating(self)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.ribbonList(self, didSelectItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.ribbonList(self, didDeselectItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.ribbonList(self, willDisplay: cell, forItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.ribbonList(self, didEndDisplaying: cell, forItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        delegate?.ribbonList(self, didEndDisplayingSupplementaryView: view, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        delegate?.ribbonList(self, canFocusItemAt: indexPath) ?? true
    }

    public func viewForLeadingCell(inSection section: Int) -> UIView? {
        delegate?.ribbonList(self, viewForLeadingCellInSection: section)
    }

    private func moveFocusToLastItem(in section: Int) -> Bool {
        let numberOfItemsInNextSection = collectionView.numberOfItems(inSection: section)
        guard numberOfItemsInNextSection > 0 else { return false }
        let moveTo = IndexPath(
            item: max(numberOfItemsInNextSection - 1, 0),
            section: section
        )
        self.forcedFocusIndexPath = moveTo
        collectionView.scrollToItem(at: moveTo, at: .top, animated: true)
        collectionView.setNeedsFocusUpdate()
        collectionView.updateFocusIfNeeded()
        return true
    }

    private func focusMightSkipSection(context: RibbonListViewFocusUpdateContext) -> Bool {
        guard let previousIndexPath = context.previouslyFocusedIndexPath else { return false }
        if context.nextFocusedIndexPath == nil {
            // Handle the case in which the focus is about to move outside the ribbonListView's collectionView
            if (previousIndexPath.section == 0 || previousIndexPath.section == collectionView.numberOfSections - 1) {
                // If the currently focused indexPath's section is 0 or equal to the last section's index, focus is allowed to leave the collection view
                return false
            }
            return moveFocusToLastItem(in: previousIndexPath.section - 1)
        }
        guard let nextIndexPath = context.nextFocusedIndexPath else {
             return false
        }
        let isMovingUp = previousIndexPath.section > nextIndexPath.section
        if isMovingUp {
            if abs(previousIndexPath.section - nextIndexPath.section) > 1 {
                return moveFocusToLastItem(in: previousIndexPath.section - 1)
            }
        }
        return false
    }

    public func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        let newContext = RibbonListViewFocusUpdateContext(previouslyFocusedIndexPath: context.previouslyFocusedIndexPath, nextFocusedIndexPath: context.nextFocusedIndexPath)
        if let shouldUpdateFocus = delegate?.ribbonList(self, shouldUpdateFocusIn: newContext) {
            return shouldUpdateFocus
        }

        if focusMightSkipSection(context: newContext) {
            return false
        }
        return true
    }

    public func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        if let forcedFocusIndexPath {
            let indexPath = forcedFocusIndexPath
            self.forcedFocusIndexPath = nil
            return indexPath
        }
        return delegate?.indexPathForPreferredFocusedView(in: self)
    }

    func scroll(section: Int, horizontallyTo xPosition: CGFloat? = nil, animated: Bool = true) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: section)) else { return }
        let scroll = cell.superview as! UIScrollView
        let destinationXPosition = xPosition ?? -abs(scroll.contentInset.left)
        scroll.setContentOffset(
            CGPoint(x: destinationXPosition, y: scroll.contentOffset.y),
            animated: animated
        )
    }

    private func supplementaryLeftCell(forSection section: Int) -> RibbonListSectionLeadingCell? {
        collectionView.supplementaryView(
            forElementKind: Constants.supplementaryLeftKind,
            at: IndexPath(item: 0, section: section)
        ) as? RibbonListSectionLeadingCell
    }

    public func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        previouslyFocusedIndexPath = context.previouslyFocusedIndexPath
        currentlyFocusedIndexPath = context.nextFocusedIndexPath
        let newContext = RibbonListViewFocusUpdateContext(
            previouslyFocusedIndexPath: context.previouslyFocusedIndexPath,
            nextFocusedIndexPath: context.nextFocusedIndexPath
        )
        let nextSection = newContext.nextFocusedIndexPath?.section
        let prevSection = newContext.previouslyFocusedIndexPath?.section
        let nextItem = newContext.nextFocusedIndexPath?.item
        if newContext.nextFocusedIndexPath?.section != newContext.previouslyFocusedIndexPath?.section {
            if let nextSection,
               let cell = supplementaryLeftCell(forSection: nextSection) {
                cell.hideContentView = false
            }
            if let prevSection,
               let cell = supplementaryLeftCell(forSection: prevSection) {
                cell.hideContentView = true
            }
        }
        else if let nextSection,
                  sectionsWithLeadingCellComponent.contains(nextSection),
                  nextItem == 0 {
            if let nextFocusedView = context.nextFocusedView,
               let cell = supplementaryLeftCell(forSection: nextSection),
               cell.containsSubview(nextFocusedView) {
                DispatchQueue.main.async { [self] in
                    scroll(section: nextSection, horizontallyTo: cell.frame.origin.x)
                }
            }
        }
        delegate?.ribbonList(self, didUpdateFocusIn: newContext, with: coordinator)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.ribbonListDidScroll(self)
    }

    public func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        delegate?.ribbonList(self, targetContentOffsetForProposedContentOffset: proposedContentOffset) ?? proposedContentOffset
    }

    #if os(tvOS)
    @available(tvOS 17.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count == 1, let indexPath = indexPaths.first else { return nil }
        presentingContextMenuIndexPath = indexPath
        return delegate?.ribbonList(
            self,
            contextMenuConfigurationForItemAt: indexPath,
            point: point
        )
    }

    @available(tvOS 17.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        delegate?.ribbonList(self, previewForHighlightingContextMenuWithConfiguration: configuration, at: indexPath) ?? contextMenuDefaultTargetedPreview(at: indexPath)
    }

    @available(tvOS 17.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        delegate?.ribbonList(self, previewForDismissingContextMenuWithConfiguration: configuration, at: indexPath) ?? contextMenuDefaultTargetedPreview(at: indexPath)
    }

    @available(tvOS 17.0, *)
    public func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        guard let presentingContextMenuIndexPath else { return }
        delegate?.ribbonList(self, willEndContextMenuInteraction: configuration, at: presentingContextMenuIndexPath, animator: animator)
        guard let animator else {
            self.presentingContextMenuIndexPath = nil
            return
        }
        animator.addCompletion { [weak self] in
            guard let self else { return }
            self.presentingContextMenuIndexPath = nil
        }
    }
    #endif

    @available(iOS 15.0, tvOS 17.0, *)
    private func contextMenuDefaultTargetedPreview(at indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        let parameters = UIPreviewParameters()
        let visibleRect = cell.contentView.bounds.insetBy(dx: -10, dy: -10)
        let visiblePath = UIBezierPath(roundedRect: visibleRect, cornerRadius: 20.0)
        parameters.visiblePath = visiblePath
        parameters.backgroundColor = delegate?.ribbonListContextMenuPreviewBackgroundColor(self, forItemAt: indexPath) ?? UIColor.clear
        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    }

    #if os(iOS)
    public func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let presentingContextMenuIndexPath else { return }
        delegate?.ribbonList(self, willPerformPreviewActionForMenuWith: configuration, at: presentingContextMenuIndexPath, animator: animator)
        animator.addCompletion { [weak self] in
            guard let self else { return }
            self.presentingContextMenuIndexPath = nil
        }
    }

    @available(iOS 16.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count == 1, let indexPath = indexPaths.first else { return nil }
        presentingContextMenuIndexPath = indexPath
        return delegate?.ribbonList(
            self,
            contextMenuConfigurationForItemAt: indexPath,
            point: point
        )
    }

    @available(iOS 16.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        delegate?.ribbonList(self, previewForHighlightingContextMenuWithConfiguration: configuration, at: indexPath) ?? contextMenuDefaultTargetedPreview(at: indexPath)
    }

    @available(iOS 16.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        delegate?.ribbonList(self, previewForDismissingContextMenuWithConfiguration: configuration, at: indexPath) ?? contextMenuDefaultTargetedPreview(at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        self.presentingContextMenuIndexPath = indexPath
        return delegate?.ribbonList(
            self,
            contextMenuConfigurationForItemAt: indexPath,
            point: point
        )
    }
    
    // Called when the interaction begins. Return a UITargetedPreview describing the desired highlight preview.
    public func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let presentingContextMenuIndexPath else { return nil }
        return delegate?.ribbonList(self, previewForHighlightingContextMenuWithConfiguration: configuration, at: presentingContextMenuIndexPath) ?? contextMenuDefaultTargetedPreview(at: presentingContextMenuIndexPath)
    }

    /**
     Called when the interaction is about to dismiss. Return a UITargetedPreview describing the desired dismissal target.
        The interaction will animate the presented menu to the target. Use this to customize the dismissal animation.
    */
    public func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        defer { self.presentingContextMenuIndexPath = nil }
        guard let presentingContextMenuIndexPath else { return nil }
        return delegate?.ribbonList(self, previewForDismissingContextMenuWithConfiguration: configuration, at: presentingContextMenuIndexPath) ?? contextMenuDefaultTargetedPreview(at: presentingContextMenuIndexPath)
    }
    #endif
}

// NOTE: This backgorund view solves the iOS 14 issue where the decoration view
// UICollectionViewListLayoutSectionBackgroundColorDecorationView
// has user interaction set to on.

class SectionBackgroundView: UICollectionReusableView, ReusableView { }

extension UIView {
    func containsSubview(_ view: UIView) -> Bool {
        // Se la subview è una delle subview dirette, ritorna true
        if subviews.contains(view) {
            return true
        }
        
        // Altrimenti, ricorsivamente verifica tra le subview
        for subview in subviews {
            if subview.containsSubview(view) {
                return true
            }
        }
        
        // Se nessuna delle subview contiene la view cercata, ritorna false
        return false
    }
}
