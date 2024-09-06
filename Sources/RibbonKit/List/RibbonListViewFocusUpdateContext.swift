//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public struct RibbonListViewFocusUpdateContext {
    public let previouslyFocusedIndexPath: IndexPath?
    public let nextFocusedIndexPath: IndexPath?
    public let previouslyFocusedItem: UIFocusItem?
    public let nextFocusedItem: UIFocusItem?
    public let focusHeading: UIFocusHeading?

    init(context: UICollectionViewFocusUpdateContext) {
        nextFocusedIndexPath = context.nextFocusedIndexPath
        previouslyFocusedIndexPath = context.previouslyFocusedIndexPath
        nextFocusedItem = context.nextFocusedItem
        previouslyFocusedItem = context.previouslyFocusedItem
        focusHeading = context.focusHeading
    }
}
