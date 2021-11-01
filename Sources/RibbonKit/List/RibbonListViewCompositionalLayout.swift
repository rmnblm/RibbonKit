//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

protocol RibbonListViewCompositionalLayoutDelegate: AnyObject {
    func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint
}

class RibbonListViewCompositionalLayout: UICollectionViewCompositionalLayout {

    weak var delegate: RibbonListViewCompositionalLayoutDelegate?

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return delegate?.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        ?? super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
}
