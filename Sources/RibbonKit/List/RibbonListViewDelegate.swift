//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

/// Methods for managing selections, configuring section headers and footers, deleting and reordering cells, and performing other actions in a ribbon list.
public protocol RibbonListViewDelegate: AnyObject {

    /// Asks the delegate for the height to use for the global header of the list.
    ///
    /// Important: The final size of the dimension is determined when the content is rendered.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list requesting this information.
    /// - Returns: A layout dimension that specifies the height (in points) of the global header.
    func ribbonListHeaderHeight(_ ribbonList: RibbonListView) -> RibbonListDimension
    
    /// Asks the delegate for the height to use for the header of a particular section.
    ///
    /// Use this method to specify the height of custom header views returned by your `ribbonList(_:viewForHeaderInSection:)` method.
    ///
    /// Important: The final size of the dimension is determined when the content is rendered.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A layout dimension that specifies the height (in points) of the header for section.
    func ribbonList(_ ribbonList: RibbonListView, heightForHeaderInSection section: Int) -> RibbonListDimension

    /// Asks the delegate for the height to use for the footer of a particular section.
    ///
    /// Use this method to specify the height of custom footer views returned by your `ribbonList(_:viewForFooterInSection:)` method.
    ///
    /// Important: The final size of the dimension is determined when the content is rendered.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A layout dimension that specifies the height (in points) of the footer for section.
    func ribbonList(_ ribbonList: RibbonListView, heightForFooterInSection section: Int) -> RibbonListDimension

    /// Tells the delegate that the item at the specified index path was selected.
    ///
    /// The ribbon list calls this method when the user successfully selects an item in the ribbon list. It does not call this method when you programmatically set the selection.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is notifying you of the selection change.
    ///     - indexPath: The index path of the cell that was selected.
    func ribbonList(_ ribbonList: RibbonListView, didSelectItemAt indexPath: IndexPath)

    /// Tells the delegate that the item at the specified index path was deselected.
    ///
    /// The ribbon list calls this method when the user successfully deselects an item in the ribbon list. It does not call this method when you programmatically deselect items.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is notifying you of the selection change.
    ///     - indexPath: The index path of the cell that was deselected.
    func ribbonList(_ ribbonList: RibbonListView, didDeselectItemAt indexPath: IndexPath)
    
    /// Tells the delegate when the user scrolls the content view within the receiver.
    ///
    /// The delegate typically implements this method to obtain the change in content offset from ribbonList and draw the affected portion of the content view.
    /// - Parameters:
    ///     - ribbonList: The ribbonList object in which the scrolling occurred.
    func ribbonListDidScroll(_ ribbonList: RibbonListView)

    /// Tells the delegate that the specified cell is about to be displayed in the ribbon list.
    ///
    /// The ribbon list calls this method before adding a cell to its content. Use this method to detect cell additions, as opposed to monitoring the cell itself to see when it appears.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is adding the cell.
    ///     - cell: The cell object being added.
    ///     - indexPath: The index path of the data item that the cell represents.
    func ribbonList(_ ribbonList: RibbonListView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)

    /// Tells the delegate that the specified cell was removed from the ribbon list.
    ///
    /// Use this method to detect when a cell is removed from a ribbon list, as opposed to monitoring the view itself to see when it disappears.
    ///
    /// - Parameters:
    ///     - collectionView: The ribbon list object that removed the cell.
    ///     - cell: The cell object that was removed.
    ///     - indexPath: The index path of the data item that the cell represented.
    func ribbonList(_ ribbonList: RibbonListView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)

    /// Tells the delegate that the specified supplementary view was removed from the ribbon list.
    ///
    /// Use this method to detect when a cell is removed from a ribbon list, as opposed to monitoring the view itself to see when it disappears.
    ///
    /// - Parameters:
    ///     - collectionView: The ribbon list object that removed the cell.
    ///     - view: The supplementary view object that was removed.
    ///     - indexPath: The index path of the data item that the cell represented.
    func ribbonList(_ ribbonList: RibbonListView, didEndDisplayingSupplementaryView supplementaryView: UICollectionReusableView, forItemAt indexPath: IndexPath)

    /// Asks the delegate whether a change in focus should occur.
    ///
    /// Before a focus change can occur, the focus engine asks all affected views if such a change should occur. In response, the ribbon list calls this method to give you the opportunity to allow or prevent the change. Return this method to prevent changes that should not occur. For example, you might use it to ensure that the navigation between cells occurs in a specific order.
    ///
    /// If you do not implement this method, the ribbon list assumes a return value of `true`.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object notifying you of the focus change.
    ///     - context: The context object containing metadata associated with the focus change. This object contains the index path of the previously focused item and the currently focused item.     
    func ribbonList(_ ribbonList: RibbonListView, shouldUpdateFocusIn context: RibbonListViewFocusUpdateContext) -> Bool
    
    /// Tells the delegate that a focus update occurred.
    ///
    /// The ribbon list calls this method when a focus-related change occurs. You can use this method to update your app's state information or to animate changes to your app's visual appearance.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object notifying you of the focus change.
    ///     - context: The context object containing metadata associated with the focus change. This object contains the index path of the previously focused item and the currently focused item.
    ///     - coordinator: The animation coordinator to use when creating any additional animations.
    func ribbonList(_ ribbonList: RibbonListView, didUpdateFocusIn context: RibbonListViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    
    /// Asks the delegate for the index path of the cell that should be focused.
    /// - Parameters:
    ///     - ribbonList: The ribbon list object requesting this information.
    /// - Returns: The index path of the preferred cell. The index path you specify must correspond to a valid cell in the ribbon list.
    func indexPathForPreferredFocusedView(in ribbonList: RibbonListView) -> IndexPath?
    
    /// Asks the delegate whether the item at the specified index path can be focused.
    ///
    /// You can use this method, or a cell’s canBecomeFocused method, to control which items in the collection view can receive focus. The focus engine calls the cell’s `canBecomeFocused` method first, the default implementation of which defers to the ribbon list and this delegate method.
    /// If you do not implement this method, the ability to focus on items depends on whether the ribbon list's items are selectable. When the items are selectable, they can also be focused as if this method had returned true; otherwise, they do not receive focus.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object requesting this information.
    ///     - indexPath: The index path of an item in the ribbon list.
    func ribbonList(_ ribbonList: RibbonListView, canFocusItemAt indexPath: IndexPath) -> Bool

    /// Tells the delegate when a scrolling animation in the scroll view concludes.
    ///
    /// The scroll view calls this method at the end of its implementations of the setContentOffset(_:animated:) methods, but only if animations are requested.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is performing the scrolling animation.
    func ribbonListDidEndScrollingAnimation(_ ribbonList: RibbonListView)

    /// Tells the delegate that the ribbon list has ended decelerating the scrolling movement.
    ///
    /// The ribbon list calls this method when the scrolling movement comes to a halt.
    /// 
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is performing the scrolling animation.
    func ribbonListDidEndDecelerating(_ ribbonList: RibbonListView)

    /// Tells the delegate that the scroll view is starting to decelerate the scrolling movement.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is performing the scrolling animation. 
    func ribbonListWillBeginDecelerating(_ ribbonList: RibbonListView)

    /// Asks the data source to return a configuration of the specified section of the ribbon list.
    ///
    /// If you do not implement this method, the ribbon list configures the list with `.default` configuration.
    ///
    /// - Parameters:
    ///     - ribbonList: An object representing the ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A ribbon configuration to use for the section.
    func ribbonList(_ ribbonList: RibbonListView, configurationForSectionAt section: Int) -> RibbonListSectionConfiguration

    /// Asks the delegate to return the itemIdentifier of the first cell inside the specified section of the ribbon list, to identify.
    ///
    /// If you do not implement this method, the ribbon list applies no custom width to the first cell in section.
    ///
    /// - Parameters:
    ///     - ribbonList: An object representing the ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: An hashable value used to identify the first cell in section that should be handled by ribbonList itself as a RibbonListSectionLeadingCell instance.
    func ribbonList(_ ribbonList: RibbonListView, viewForLeadingCellInSection section: Int) -> UIView?

    /// Gives the delegate an opportunity to customize the content offset for layout changes and animated updates.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list making the request.
    ///     - section: The proposed point (in the coordinate space of the ribbon list's content view) for the upper-left corner of the visible content. This represents the point that the ribbon list has calculated as the most likely value to use for the animations or layout update.
    ///  - Returns: The content offset that you want to use instead. If you do not implement this method, the collection view uses the value in the proposedContentOffset parameter.
    func ribbonList(_ ribbonList: RibbonListView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint

    #if os(tvOS)
    /// Returns a context menu configuration for the item at a point.
    ///
    /// Use this method to provide a UIContextMenuConfiguration describing the menu to present.
    /// Return nil to prevent the interaction from beginning.
    /// Return an empty configuration to begin the interaction and then fail with a cancellation effect.
    /// Use the empty configuration to indicate to users that it’s possible for this element to present a menu, but that there are no actions to present at this time.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list containing the item.
    ///     - indexPath: The index path of the item.
    ///     - point: The location of the interaction in the ribbon list's coordinate space.
    /// - Returns: A context menu configuration for the indexPath.
    @available(tvOS 17.0, *)
    func ribbonList(_ ribbonList: RibbonListView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?

    /// Returns a UITargetedPreview that will be used as a preview when presenting a context menu, overriding the default preview the collection view created
    ///
    /// Use this method to tell the delegate that the user has requested a preview of view for the item that requested a context menu presentation.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list containing the item.
    ///     - configuration: The context menu configuration.
    /// - Returns: A view to override the default preview the collection view created
    /// Example:
    /// ```swift
    ///   func ribbonList(_ ribbonList: RibbonListView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview? {
    ///        // Ensure we can get the expected identifier.
    ///        // Use the identifier to get the UICollectionViewCell that requested context menu presentation
    ///        guard let configIdentifier = configuration.identifier as? ContextMenuIdentifier else { return nil }
    ///
    ///        let indexPath = IndexPath(row: configIdentifier.row, section: configIdentifier.section)
    ///        // Get the cell for the index of the model.
    ///        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
    ///
    ///        let parameters = UIPreviewParameters()
    ///        let visibleRect = cell.contentView.bounds.insetBy(dx: -10, dy: -10)
    ///        let visiblePath = UIBezierPath(roundedRect: visibleRect, cornerRadius: 20.0)
    ///        parameters.visiblePath = visiblePath
    ///        parameters.backgroundColor = UIColor.systemTeal
    ///        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    ///    }
    /// ```
    @available(tvOS 17.0, *)
    func ribbonList(_ ribbonList: RibbonListView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview?

    /// Returns a UITargetedPreview that will be used as a preview when dismissing a context menu, overriding the default preview the collection view created
    ///
    /// Use this method to tell the delegate that the user has requested a preview of view for the item that requested a context menu presentation.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list containing the item.
    ///     - configuration: The context menu configuration.
    /// - Returns: A view to override the default preview the collection view created
    ///
    ///  Example:
    /// ```swift
    ///   func ribbonList(_ ribbonList: RibbonListView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview? {
    ///        // Ensure we can get the expected identifier.
    ///        // Use the identifier to get the UICollectionViewCell that requested context menu presentation
    ///        guard let configIdentifier = configuration.identifier as? ContextMenuIdentifier else { return nil }
    ///
    ///        let indexPath = IndexPath(row: configIdentifier.row, section: configIdentifier.section)
    ///        // Get the cell for the index of the model.
    ///        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
    ///
    ///        let parameters = UIPreviewParameters()
    ///        let visibleRect = cell.contentView.bounds.insetBy(dx: -10, dy: -10)
    ///        let visiblePath = UIBezierPath(roundedRect: visibleRect, cornerRadius: 20.0)
    ///        parameters.visiblePath = visiblePath
    ///        parameters.backgroundColor = UIColor.systemTeal
    ///        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    ///    }
    /// ```
    @available (tvOS 17.0, *)
    func ribbonList(_ ribbonList: RibbonListView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview?

    @available(tvOS 17.0, *)
    func ribbonList(_ ribbonList: RibbonListView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, at indexPath: IndexPath, animator: UIContextMenuInteractionAnimating?)

    @available(tvOS 17.0, *)
    func ribbonListContextMenuPreviewBackgroundColor(_ ribbonList: RibbonListView, forItemAt indexPath: IndexPath) -> UIColor?
    #endif
    #if os(iOS)
    /// Returns a context menu configuration for the item at a point.
    ///
    /// Use this method to provide a UIContextMenuConfiguration describing the menu to present.
    /// Return nil to prevent the interaction from beginning.
    /// Return an empty configuration to begin the interaction and then fail with a cancellation effect.
    /// Use the empty configuration to indicate to users that it’s possible for this element to present a menu, but that there are no actions to present at this time.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list containing the item.
    ///     - indexPath: The index path of the item.
    ///     - point: The location of the interaction in the ribbon list's coordinate space.
    /// - Returns: A context menu configuration for the indexPath.
    func ribbonList(_ ribbonList: RibbonListView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    
    /// Returns a UITargetedPreview that will be used as a preview when presenting a context menu, overriding the default preview the collection view created
    ///
    /// Use this method to tell the delegate that the user has requested a preview of view for the item that requested a context menu presentation.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list containing the item.
    ///     - configuration: The context menu configuration.
    /// - Returns: A view to override the default preview the collection view created
    /// Example:
    /// ```swift
    ///   func ribbonList(_ ribbonList: RibbonListView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview? {
    ///        // Ensure we can get the expected identifier.
    ///        // Use the identifier to get the UICollectionViewCell that requested context menu presentation
    ///        guard let configIdentifier = configuration.identifier as? ContextMenuIdentifier else { return nil }
    ///
    ///        let indexPath = IndexPath(row: configIdentifier.row, section: configIdentifier.section)
    ///        // Get the cell for the index of the model.
    ///        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
    ///
    ///        let parameters = UIPreviewParameters()
    ///        let visibleRect = cell.contentView.bounds.insetBy(dx: -10, dy: -10)
    ///        let visiblePath = UIBezierPath(roundedRect: visibleRect, cornerRadius: 20.0)
    ///        parameters.visiblePath = visiblePath
    ///        parameters.backgroundColor = UIColor.systemTeal
    ///        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    ///    }
    /// ```
    func ribbonList(_ ribbonList: RibbonListView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview?

    /// Returns a UITargetedPreview that will be used as a preview when dismissing a context menu, overriding the default preview the collection view created
    ///
    /// Use this method to tell the delegate that the user has requested a preview of view for the item that requested a context menu presentation.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list containing the item.
    ///     - configuration: The context menu configuration.
    /// - Returns: A view to override the default preview the collection view created
    ///
    ///  Example:
    /// ```swift
    ///   func ribbonList(_ ribbonList: RibbonListView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview? {
    ///        // Ensure we can get the expected identifier.
    ///        // Use the identifier to get the UICollectionViewCell that requested context menu presentation
    ///        guard let configIdentifier = configuration.identifier as? ContextMenuIdentifier else { return nil }
    ///
    ///        let indexPath = IndexPath(row: configIdentifier.row, section: configIdentifier.section)
    ///        // Get the cell for the index of the model.
    ///        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
    ///
    ///        let parameters = UIPreviewParameters()
    ///        let visibleRect = cell.contentView.bounds.insetBy(dx: -10, dy: -10)
    ///        let visiblePath = UIBezierPath(roundedRect: visibleRect, cornerRadius: 20.0)
    ///        parameters.visiblePath = visiblePath
    ///        parameters.backgroundColor = UIColor.systemTeal
    ///        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    ///    }
    /// ```
    func ribbonList(_ ribbonList: RibbonListView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview?
    func ribbonList(_ ribbonList: RibbonListView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, at indexPath: IndexPath, animator: UIContextMenuInteractionCommitAnimating)
    func ribbonListContextMenuPreviewBackgroundColor(_ ribbonList: RibbonListView, forItemAt indexPath: IndexPath) -> UIColor?
    #endif

    /// Tells the delegate that the ribbon list has ended decelerating the scrolling to top movement.
    ///
    /// The ribbon list calls this method when the scrolling movement comes to a halt at the top.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is performing the scrolling animation.
    func ribbonListDidScrollToTop(_ ribbonList: RibbonListView)
}

extension RibbonListViewDelegate {
    public func ribbonListHeaderHeight(_ ribbonList: RibbonListView) -> RibbonListDimension { .estimated(44) }
    
    public func ribbonListDidScroll(_ ribbonList: RibbonListView) { }
    public func ribbonList(_ ribbonList: RibbonListView, didSelectItemAt indexPath: IndexPath) { }
    public func ribbonList(_ ribbonList: RibbonListView, didDeselectItemAt indexPath: IndexPath) { }

    public func ribbonList(_ ribbonList: RibbonListView, heightForHeaderInSection section: Int) -> RibbonListDimension { .zero }
    public func ribbonList(_ ribbonList: RibbonListView, heightForFooterInSection section: Int) -> RibbonListDimension { .zero }
    
    public func ribbonList(_ ribbonList: RibbonListView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    public func ribbonList(_ ribbonList: RibbonListView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    public func ribbonList(_ ribbonList: RibbonListView, didEndDisplayingSupplementaryView supplementaryView: UICollectionReusableView, forItemAt indexPath: IndexPath) { }
    public func ribbonList(_ ribbonList: RibbonListView, shouldUpdateFocusIn context: RibbonListViewFocusUpdateContext) -> Bool { true }
    public func ribbonList(_ ribbonList: RibbonListView, didUpdateFocusIn context: RibbonListViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) { }
    public func indexPathForPreferredFocusedView(in ribbonList: RibbonListView) -> IndexPath? { nil }
    public func ribbonList(_ ribbonList: RibbonListView, canFocusItemAt indexPath: IndexPath) -> Bool { true }
    public func ribbonList(_ ribbonList: RibbonListView, viewForLeadingCellInSection section: Int) -> UIView? { nil }
    public func ribbonList(_ ribbonList: RibbonListView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint { proposedContentOffset }

    public func ribbonListDidEndScrollingAnimation(_ ribbonList: RibbonListView) { }
    public func ribbonListWillBeginDecelerating(_ ribbonList: RibbonListView) { }
    public func ribbonListDidEndDecelerating(_ ribbonList: RibbonListView) { }

    public func ribbonListDidScrollToTop(_ ribbonList: RibbonListView) { }
    #if os(tvOS)
    @available(tvOS 17.0, *)
    public func ribbonList(_ ribbonList: RibbonListView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { nil }
    @available(tvOS 17.0, *)
    public func ribbonList(_ ribbonList: RibbonListView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview? { nil }
    @available(tvOS 17.0, *)
    public func ribbonList(_ ribbonList: RibbonListView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview? { nil }
    @available(tvOS 17.0, *)
    public func ribbonList(_ ribbonList: RibbonListView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, at indexPath: IndexPath, animator: UIContextMenuInteractionAnimating?) { }
    @available(tvOS 17.0, *)
    public func ribbonListContextMenuPreviewBackgroundColor(_ ribbonList: RibbonListView, forItemAt indexPath: IndexPath) -> UIColor? { nil }
    #endif

    #if os(iOS)
    public func ribbonList(_ ribbonList: RibbonListView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { nil }
    public func ribbonList(_ ribbonList: RibbonListView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview? { nil }
    public func ribbonList(_ ribbonList: RibbonListView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration, at: IndexPath) -> UITargetedPreview? { nil }
    public func ribbonList(_ ribbonList: RibbonListView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, at indexPath: IndexPath, animator: UIContextMenuInteractionCommitAnimating) {}
    public func ribbonListContextMenuPreviewBackgroundColor(_ ribbonList: RibbonListView, forItemAt indexPath: IndexPath) -> UIColor? { nil }
    #endif
}
