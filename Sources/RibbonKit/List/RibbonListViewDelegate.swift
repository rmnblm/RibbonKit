//  Copyright © 2020 Roman Blum. All rights reserved.

import UIKit

/// Methods for managing selections, configuring section headers and footers, deleting and reordering cells, and performing other actions in a ribbon list.
public protocol RibbonListViewDelegate: class {

    /// Asks the delegate for the height to use for the specified section.
    ///
    /// Before it appears onscreen, the ribbon list calls this method for the rows in the visible portion of the list. As the user scrolls vertically, the ribbon list calls the method for items only when they move onscreen. It calls the method each time the row appears onscreen, regardless of whether it appeared onscreen previously.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list requesting this information.
    ///     - indexPath: An index path that locates a row in ribbonList.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) that row should be.
    func ribbonList(_ ribbonList: RibbonListView, heightForSectionAt section: Int) -> CGFloat
    
    /// Asks the delegate for the height to use for the header of a particular section.
    ///
    /// Use this method to specify the height of custom header views returned by your `ribbonList(_:viewForHeaderInSection:)` method.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) of the header for section.
    func ribbonList(_ ribbonList: RibbonListView, heightForHeaderInSection section: Int) -> CGFloat

    /// Asks the delegate for the height to use for the footer of a particular section.
    ///
    /// Use this method to specify the height of custom footer views returned by your `ribbonList(_:viewForFooterInSection:)` method.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) of the footer for section.
    func ribbonList(_ ribbonList: RibbonListView, heightForFooterInSection section: Int) -> CGFloat

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
    
    /// Asks the delegate whether the item at the specified index path can be focused.
    ///
    /// You can use this method, or a cell’s canBecomeFocused method, to control which items in the collection view can receive focus. The focus engine calls the cell’s `canBecomeFocused` method first, the default implementation of which defers to the ribbon list and this delegate method.
    /// If you do not implement this method, the ability to focus on items depends on whether the ribbon list's items are selectable. When the items are selectable, they can also be focused as if this method had returned true; otherwise, they do not receive focus.
    /// - Parameters:
    ///     - ribbonList: The ribbon list object requesting this information.
    ///     - indexPath: The index path of an item in the ribbon list.
    func ribbonList(_ ribbonList: RibbonListView, canFocusItemAt indexPath: IndexPath) -> Bool

    /// Tells the delegate when a scrolling animation in the scroll view concludes.
    ///
    /// The scroll view calls this method at the end of its implementations of the setContentOffset(_:animated:) methods, but only if animations are requested.
    ///
    /// - Parameters:
    ///     - scrollView: The ribbon list object that is performing the scrolling animation.
    func ribbonListDidEndScrollingAnimation(_ ribbonList: RibbonListView)

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
    @available(iOS 13.0, *)
    func ribbonList(_ ribbonList: RibbonListView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    #endif
}

extension RibbonListViewDelegate {
    public func ribbonList(_ ribbonList: RibbonListView, heightForSectionAt section: Int) -> CGFloat {
        return ribbonList.dataSource?.ribbonList(ribbonList, configurationForSectionAt: section)?.calculatedSectionHeight() ?? UITableView.automaticDimension
    }
    
    public func ribbonListDidScroll(_ ribbonList: RibbonListView) { }
    public func ribbonList(_ ribbonList: RibbonListView, didSelectItemAt indexPath: IndexPath) { }
    public func ribbonList(_ ribbonList: RibbonListView, didDeselectItemAt indexPath: IndexPath) { }
    
    public func ribbonList(_ ribbonList: RibbonListView, heightForHeaderInSection section: Int) -> CGFloat { 0.0 }
    public func ribbonList(_ ribbonList: RibbonListView, heightForFooterInSection section: Int) -> CGFloat { 0.0 }
    
    public func ribbonList(_ ribbonList: RibbonListView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    public func ribbonList(_ ribbonList: RibbonListView, shouldUpdateFocusIn context: RibbonListViewFocusUpdateContext) -> Bool { true }
    public func ribbonList(_ ribbonList: RibbonListView, didUpdateFocusIn context: RibbonListViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) { }
    public func ribbonList(_ ribbonList: RibbonListView, canFocusItemAt indexPath: IndexPath) -> Bool { true }

    public func ribbonListDidEndScrollingAnimation(_ ribbonList: RibbonListView) { }

    #if os(iOS)
    @available(iOS 13.0, *)
    public func ribbonList(_ ribbonList: RibbonListView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { nil }
    #endif
}
