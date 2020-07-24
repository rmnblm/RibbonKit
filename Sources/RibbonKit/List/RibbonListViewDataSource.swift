//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit

/// The methods adopted by the object you use to manage data and provide cells for a ribbon list.
public protocol RibbonListViewDataSource: class {

    /// Asks the data source to return the number of sections in the ribbon list.
    ///
    /// If you do not implement this method, the ribbon list configures the list with one section.
    ///
    /// - Parameters:
    ///     - ribbonList: An object representing the ribbon list requesting this information.
    /// - Returns: The number of sections in ribbonList.
    func numberOfSections(in ribbonList: RibbonList) -> Int

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
    func ribbonList(_ ribbonList: RibbonList, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell

    /// Tells the data source to return the number of items in a given section of a ribbon list.
    ///
    /// - Parameters:
    ///     - ribbonList: An object representing the ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: The number of rows in section.
    func ribbonList(_ ribbonList: RibbonList, numberOfItemsInSection section: Int) -> Int

    /// Asks the data source to return a configuration of the specified section of the ribbon list.
    ///
    /// If you do not implement this method, the ribbon list configures the list with `.default` configuration.
    ///
    /// - Parameters:
    ///     - ribbonList: An object representing the ribbon list requesting this information.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A ribbon configuration to use for the section.
    func ribbonList(_ ribbonList: RibbonList, configurationForSectionAt section: Int) -> RibbonConfiguration?

    /// Asks the data source for the title of the header of the specified section of the ribbon list.
    ///
    /// The ribbon list uses a fixed font style for section header titles. If you want a different font style, return a custom view (for example, a UILabel object) in the delegate method `ribbonList(_:viewForHeaderInSection:)` instead.
    ///
    /// If you do not implement this method or the `ribbonList(_:viewForHeaderInSection:)` method, the list does not display headers for sections. If you implement both methods, the `ribbonList(_:viewForHeaderInSection:)` method takes priority.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbonList object asking for the title.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A string to use as the title of the section header. If you return nil, the section will have no title.
    func ribbonList(_ ribbonList: RibbonList, titleForHeaderInSection section: Int) -> String?

    /// Asks the data source for the title of the footer of the specified section of the ribbon list.
    ///
    /// The ribbon list uses a fixed font style for section footer titles. If you want a different font style, return a custom view (for example, a UILabel object) in the delegate method `ribbonList(_:viewForFooterInSection:)` instead.
    ///
    /// If you do not implement this method or the `ribbonList(_:viewForFooterInSection:)` method, the list does not display footers for sections. If you implement both methods, the `ribbonList(_:viewForFooterInSection:)` method takes priority.
    ///
    /// - Parameters:
    ///     - ribbonList: The ribbonList object asking for the title.
    ///     - section: An index number identifying a section of ribbonList.
    /// - Returns: A string to use as the title of the section footer. If you return nil, the section will have no title.
    func ribbonList(_ ribbonList: RibbonList, titleForFooterInSection section: Int) -> String?
}

extension RibbonListViewDataSource {
    public func ribbonList(_ ribbonList: RibbonList, configurationForSectionAt section: Int) -> RibbonConfiguration? {
        return nil
    }

    public func numberOfSections(in ribbonList: RibbonList) -> Int {
        return 1
    }

    public func ribbonList(_ ribbonList: RibbonList, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    public func ribbonList(_ ribbonList: RibbonList, titleForFooterInSection section: Int) -> String? {
        return nil
    }
}
