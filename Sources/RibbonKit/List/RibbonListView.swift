//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

/// A view that presents data using paginated items arranged in rows.
public class RibbonListView: UIView {

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

    public var adjustedContentInset: UIEdgeInsets {
        collectionView.adjustedContentInset
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
    public var headerView: UIView? {
        didSet { reloadHeaderView() }
    }

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

    private lazy var layout = buildLayout()
    public private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(RibbonListReusableHostView.self, forSupplementaryViewOfKind: "header")
        return collectionView
    }()

    private var currentlyFocusedIndexPath: IndexPath?

    private var screenSize: CGSize = UIScreen.main.bounds.size
    
    /// Initializes and returns a ribbon list having the given frame.
    ///
    /// - Parameters:
    ///     - frame: A rectangle specifying the initial location and size of the ribbon list in its superview’s coordinates. The frame of the table view changes as list cells are added and deleted. The default value is `.zero` for usage with UIKit's auto layout.
    /// - Returns: Returns an initialized RibbonList object.
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
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
        reloadHeaderView()
    }
    #endif

    /// RibbonKit does not support initialization by storyboard or xib.
    ///
    /// Do not call this initializer. It will crash.
    required public init?(coder: NSCoder) { nil }

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

    /// Reloads the header view and layouts it.
    public func reloadHeaderView() {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        if headerView != nil, let headerSize = delegate?.ribbonListHeaderHeight(self) {
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: headerSize.uiDimension
                ),
                elementKind: "header",
                alignment: .top
            )
            config.boundarySupplementaryItems = [header]
        }
        layout.configuration = config
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

    private func buildLayout() -> UICollectionViewCompositionalLayout {
        let layout = RibbonListViewCompositionalLayout {
            [weak self] sectionIndex, layoutEnvironment in

            var configuration = RibbonListSectionConfiguration.default
            if let self = self {
                configuration = self.delegate?.ribbonList(self, configurationForSectionAt: sectionIndex) ?? .default
            }

            var group: NSCollectionLayoutGroup?
            let section: NSCollectionLayoutSection
            if configuration.layout.orientation == .vertical {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1 / CGFloat(configuration.layout.numberOfRows))
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: configuration.layout.itemWidthDimensions.first?.uiDimension ?? .estimated(80),
                    heightDimension: configuration.layout.heightDimension.uiDimension
                )
                group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitem: item,
                    count: configuration.layout.numberOfRows
                )
            }
            else if configuration.layout.orientation == .horizontal {
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
                group = NSCollectionLayoutGroup.horizontal(layoutSize: itemGroupSize, subitems: items)
            }
            else if case .single(let config) = configuration.layout.orientation {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                var numberOfItems = 0
                let currentDevice = UIDevice.current
                
                if config.aspectRatio == 0 {
                    #if os(iOS)
                    if currentDevice.userInterfaceIdiom == .phone {
                        numberOfItems = currentDevice.isPortrait ? config.phoneConfiguration.portraitItems : config.phoneConfiguration.landscapeItems
                    } else if currentDevice.userInterfaceIdiom == .pad {
                        numberOfItems = currentDevice.isPortrait ? config.padConfiguration.portraitItems : config.padConfiguration.landscapeItems
                    }
                    #elseif os(tvOS)
                    numberOfItems = config.tvConfiguration.items
                    #endif
                    
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: configuration.layout.heightDimension.uiDimension)
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfItems)
                }
                else {
                    if let self = self {
                        var decimalPart: CGFloat
                        var widthDimension: RibbonListDimension = .estimated(configuration.layout.itemWidthDimensions.first?.value ?? 80)
                        var heightDimension: RibbonListDimension = .estimated(widthDimension.value * config.aspectRatio)
                        var subItemsCount = (self.getScreenWidth() / widthDimension.value)
                        decimalPart = subItemsCount.truncatingRemainder(dividingBy: 1)

                        while decimalPart > 0.1 {
                            widthDimension = .estimated(widthDimension.value + 5)
                            heightDimension = .estimated(widthDimension.value * config.aspectRatio)
                            subItemsCount = (self.getScreenWidth() / (widthDimension.value + configuration.interItemSpacing))
                            decimalPart = subItemsCount.truncatingRemainder(dividingBy: 1)
                        }

                        let groupSize = NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: heightDimension.uiDimension
                        )

                        group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: Int(subItemsCount.rounded(.down)))
                    }
                }
            }

            if let group = group {
                group.interItemSpacing = .fixed(configuration.interItemSpacing)
                section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = self?.horizontalScrollingBehavior ?? .continuousGroupLeadingBoundary
                if case .single = configuration.layout.orientation {
                    section.orthogonalScrollingBehavior = .none
                }
            }
            else {
                var listConfig: UICollectionLayoutListConfiguration = .init(appearance: .plain)

                if case .list(let config) = configuration.layout.orientation {
                    listConfig = config.asCollectionLayoutListConfiguration()
                }

                section = NSCollectionLayoutSection.list(
                    using: listConfig,
                    layoutEnvironment: layoutEnvironment
                )
            }

            section.interGroupSpacing = configuration.interGroupSpacing
            section.contentInsets = .init(
                top: configuration.sectionInsets.top,
                leading: configuration.sectionInsets.left,
                bottom: configuration.sectionInsets.bottom,
                trailing: configuration.sectionInsets.right
            )

            var header: NSCollectionLayoutBoundarySupplementaryItem?
            if let self = self, let headerHeight = self.delegate?.ribbonList(self, heightForHeaderInSection: sectionIndex), headerHeight.value > 0.0 {
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
            if let self = self, let footerHeight = self.delegate?.ribbonList(self, heightForFooterInSection: sectionIndex), footerHeight.value > 0.0 {
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
            return section
        }
        layout.delegate = self
        return layout
    }
    
    private func getScreenWidth() -> CGFloat {
        #if os(iOS)
        if UIDevice.current.isPortrait {
            return screenSize.width < screenSize.height ? screenSize.width : screenSize.height
        } else {
            return screenSize.width > screenSize.height ? screenSize.width : screenSize.height
        }
        #elseif os(tvOS)
        return screenSize.width
        #endif
    }
}

extension RibbonListView: RibbonListViewCompositionalLayoutDelegate {
    func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        switch verticalScrollingBehaviour {
        case .none:
            return proposedContentOffset
        case .sectionPaging:
            guard
                let indexPath = currentlyFocusedIndexPath,
                let frame = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.section))?.frame
            else { return proposedContentOffset }
            return .init(x: proposedContentOffset.x, y: frame.origin.y)
        }
    }
}

extension RibbonListView: UICollectionViewDelegate {
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
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
    
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return delegate?.ribbonList(self, canFocusItemAt: indexPath) ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        let newContext = RibbonListViewFocusUpdateContext(previouslyFocusedIndexPath: context.previouslyFocusedIndexPath, nextFocusedIndexPath: context.nextFocusedIndexPath)
        return delegate?.ribbonList(self, shouldUpdateFocusIn: newContext) ?? true
    }
    
    public func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return delegate?.indexPathForPreferredFocusedView(in: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        currentlyFocusedIndexPath = context.nextFocusedIndexPath
        let newContext = RibbonListViewFocusUpdateContext(previouslyFocusedIndexPath: context.previouslyFocusedIndexPath, nextFocusedIndexPath: context.nextFocusedIndexPath)
        delegate?.ribbonList(self, didUpdateFocusIn: newContext, with: coordinator)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.ribbonListDidScroll(self)
    }

    public func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return delegate?.ribbonList(self, targetContentOffsetForProposedContentOffset: proposedContentOffset) ?? proposedContentOffset
    }

    #if os(iOS)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return delegate?.ribbonList(
            self,
            contextMenuConfigurationForItemAt: indexPath,
            point: point,
            proposedIdentifier: ContextMenuIdentifier(row: indexPath.row, section: indexPath.section)
        )
    }
    
    // Called when the interaction begins. Return a UITargetedPreview describing the desired highlight preview.
    public func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        delegate?.ribbonList(self, previewForHighlightingContextMenuWithConfiguration: configuration) ?? makeTargetedPreview(for: configuration)
    }

    /** Called when the interaction is about to dismiss. Return a UITargetedPreview describing the desired dismissal target.
        The interaction will animate the presented menu to the target. Use this to customize the dismissal animation.
    */
    public func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        return delegate?.ribbonList(self, previewForDismissingContextMenuWithConfiguration: configuration) ?? makeTargetedPreview(for: configuration)
    }

    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        // Ensure we can get the expected identifier.
        guard let configIdentifier = configuration.identifier as? ContextMenuIdentifier else { return nil }
        
        let indexPath = IndexPath(row: configIdentifier.row, section: configIdentifier.section)
        // Get the cell for the index of the model.
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        return UITargetedPreview(view: cell.contentView, parameters: UIPreviewParameters())
    }
    #endif
}

public final class ContextMenuIdentifier: NSCopying {
    public var row: Int
    public var section: Int
    
    public init(row: Int, section: Int) {
        self.row = row
        self.section = section
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        ContextMenuIdentifier(row: self.row, section: self.section)
    }
}
