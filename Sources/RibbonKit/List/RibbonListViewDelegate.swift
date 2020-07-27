//  Copyright © 2020 Swisscom. All rights reserved.

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
    func ribbonList(_ ribbonList: RibbonList, heightForSectionAt section: Int) -> CGFloat

    /// Tells the delegate that the item at the specified index path was selected.
    ///
    /// The ribbon list calls this method when the user successfully selects an item in the ribbon list. It does not call this method when you programmatically set the selection.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is notifying you of the selection change.
    ///     - indexPath: The index path of the cell that was selected.
    func ribbonList(_ ribbonList: RibbonList, didSelectItemAt indexPath: IndexPath)

    /// Tells the delegate that the item at the specified index path was deselected.
    ///
    /// The ribbon list calls this method when the user successfully deselects an item in the ribbon list. It does not call this method when you programmatically deselect items.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is notifying you of the selection change.
    ///     - indexPath: The index path of the cell that was deselected.
    func ribbonList(_ ribbonList: RibbonList, didDeselectItemAt indexPath: IndexPath)

    /// Asks the delegate for the height to use for the header of a particular section.
    ///
    /// Use this method to specify the height of custom header views returned by your `ribbonList(_:viewForHeaderInSection:)` method.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) of the header for section.
    func ribbonList(_ ribbonList: RibbonList, heightForHeaderInSection section: Int) -> CGFloat

    /// Asks the delegate for a view object to display in the header of the specified section of the ribbon list.
    ///
    /// Use this method to return a UILabel, UIImageView, or custom view for your header. If you implement this method, you must also implement the `tableView(_:heightForHeaderInSection:)` method to specify the height of your custom view.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbonList asking for the view.
    ///     - section: The index number of the section containing the header view.
    /// - Returns: The view object to display at the top of the specified section.
    func ribbonList(_ ribbonList: RibbonList, viewForHeaderInSection section: Int) -> UIView?

    /// Asks the delegate for the height to use for the footer of a particular section.
    ///
    /// Use this method to specify the height of custom footer views returned by your `ribbonList(_:viewForFooterInSection:)` method.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) of the footer for section.
    func ribbonList(_ ribbonList: RibbonList, heightForFooterInSection section: Int) -> CGFloat

    /// Asks the delegate for a view object to display in the footer of the specified section of the ribbon list.
    ///
    /// Use this method to return a UILabel, UIImageView, or custom view for your footer. If you implement this method, you must also implement the `tableView(_:heightForFooterInSection:)` method to specify the height of your custom view.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbonList asking for the view.
    ///     - section: The index number of the section containing the footer view.
    /// - Returns: The view object to display at the bottom of the specified section.
    func ribbonList(_ ribbonList: RibbonList, viewForFooterInSection section: Int) -> UIView?

    /// Tells the delegate when the user scrolls the content view within the receiver.
    ///
    /// The delegate typically implements this method to obtain the change in content offset from ribbonList and draw the affected portion of the content view.
    /// - Parameters:
    ///     - ribbonList: The ribbonList object in which the scrolling occurred.
    func ribbonListDidScroll(_ ribbonList: RibbonList)

    /// Tells the delegate that the specified cell is about to be displayed in the ribbon list.
    ///
    /// The ribbon list calls this method before adding a cell to its content. Use this method to detect cell additions, as opposed to monitoring the cell itself to see when it appears.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbon list object that is adding the cell.
    ///     - cell: The cell object being added.
    ///     - indexPath: The index path of the data item that the cell represents.
    func ribbonList(_ ribbonList: RibbonList, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
}

extension RibbonListViewDelegate {
    public func ribbonList(_ ribbonList: RibbonList, heightForSectionAt section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func ribbonList(_ ribbonList: RibbonList, didSelectItemAt indexPath: IndexPath) {

    }

    public func ribbonList(_ ribbonList: RibbonList, didDeselectItemAt indexPath: IndexPath) {

    }

    public func ribbonList(_ ribbonList: RibbonList, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func ribbonList(_ ribbonList: RibbonList, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func ribbonList(_ ribbonList: RibbonList, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func ribbonList(_ ribbonList: RibbonList, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    public func ribbonListDidScroll(_ ribbonList: RibbonList) {
        
    }

    public func ribbonList(_ ribbonList: RibbonList, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
