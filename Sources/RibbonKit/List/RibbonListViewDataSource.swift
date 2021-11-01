//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

/// The methods adopted by the object you use to manage data and provide cells for a ribbon list.
public protocol RibbonListViewDataSource: AnyObject {

    /// Asks the data source to return the number of sections in the ribbon list.
    ///
    /// If you do not implement this method, the ribbon list configures the list with one section.
    ///
    /// - Parameters:
    ///     - ribbonList: An object representing the ribbon list requesting this information.
    /// - Returns: The number of sections in ribbonList.
    func numberOfSections(in ribbonList: RibbonListView) -> Int

    /// Asks the data source for a cell to insert in a particular location of the ribbon list.
    ///
    /// In your implementation, create and configure an appropriate cell for the given index path. Create your cell using the ribbon list's `dequeueReusableCell(withIdentifier:for:)` method, which recycles or creates the cell for you. After creating the cell, update the properties of the cell with appropriate data values.
    ///
    /// Never call this method yourself. If you want to retrieve cells from your list, call the ribbon list's `cellForRow(at:)` method instead.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbonList object requesting the cell.
    ///     - indexPath: An index path locating a item in ribbonList.
    /// - Returns: An object inheriting from UICollectionViewCell that the ribbon list can use for the specified item. UIKit raises an assertion if you return nil.
    func ribbonList(_ ribbonList: RibbonListView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell

    /// Asks the delegate for a view object to display in the header of the specified section of the ribbon list.
    ///
    /// Use this method to return a UILabel, UIImageView, or custom view for your header. If you implement this method, you must also implement the `tableView(_:heightForHeaderInSection:)` method to specify the height of your custom view.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbonList asking for the view.
    ///     - section: The index number of the section containing the header view.
    /// - Returns: The view object to display at the top of the specified section.
    func ribbonList(_ ribbonList: RibbonListView, viewForHeaderInSection section: Int) -> UICollectionReusableView

    /// Asks the delegate for a view object to display in the footer of the specified section of the ribbon list.
    ///
    /// Use this method to return a UILabel, UIImageView, or custom view for your footer. If you implement this method, you must also implement the `tableView(_:heightForFooterInSection:)` method to specify the height of your custom view.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbonList asking for the view.
    ///     - section: The index number of the section containing the footer view.
    /// - Returns: The view object to display at the bottom of the specified section.
    func ribbonList(_ ribbonList: RibbonListView, viewForFooterInSection section: Int) -> UICollectionReusableView

    /// Tells the data source to return the number of items in a given section of a ribbon list.
    ///
    /// - Parameters:
    ///     - ribbonList: An object representing the ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: The number of rows in section.
    func ribbonList(_ ribbonList: RibbonListView, numberOfItemsInSection section: Int) -> Int

}

extension RibbonListViewDataSource {
    public func numberOfSections(in ribbonList: RibbonListView) -> Int { 1 }
    public func ribbonList(_ ribbonList: RibbonListView, viewForHeaderInSection section: Int) -> UICollectionReusableView { UICollectionReusableView() }
    public func ribbonList(_ ribbonList: RibbonListView, viewForFooterInSection section: Int) -> UICollectionReusableView { UICollectionReusableView() }
}
