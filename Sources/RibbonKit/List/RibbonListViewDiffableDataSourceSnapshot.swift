//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

open class RibbonListViewDiffableDataSourceSnapshot<Section: Hashable, Item: Hashable>: NSObject {

    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

    public func appendSections(_ sections: [Section]) {
        snapshot.appendSections(sections)
    }

    public func appendItems(_ items: [Item], toSection section: Section?) {
        snapshot.appendItems(items, toSection: section)
    }

    public func insertItems(_ items: [Item], afterItem item: Item) {
        snapshot.insertItems(items, afterItem: item)
    }

    public func insertItems(_ items: [Item], beforeItem item: Item) {
        snapshot.insertItems(items, beforeItem: item)
    }
}
