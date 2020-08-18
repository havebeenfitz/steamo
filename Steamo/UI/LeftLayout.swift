//
//  LeftLayout.swift
//  Steamo
//
//  Created by Alexander on 8/18/20.
//  Copyright © 2020 Max Kraev. All rights reserved.
//

import UIKit

class LeftLayout: UICollectionViewFlowLayout {
    let customOffset: CGFloat = 16
    var recentOffset: CGPoint = .zero

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        let cvBouns = CGRect(
            x: proposedContentOffset.x,
            y: proposedContentOffset.y,
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )

        guard let visibleAttributes = self.layoutAttributesForElements(in: cvBouns) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        var candidate: UICollectionViewLayoutAttributes?
        for attributes in visibleAttributes {
            if attributes.center.x < proposedContentOffset.x {
                continue
            }

            candidate = attributes
            break
        }

        if proposedContentOffset.x + collectionView.frame.width - collectionView.contentInset.left - self.customOffset > collectionView.contentSize.width {
            candidate = visibleAttributes.last
        }

        if let candidate = candidate {
            self.recentOffset = CGPoint(x: candidate.frame.origin.x - self.customOffset, y: proposedContentOffset.y)
            return recentOffset
        } else {
            return recentOffset
        }
    }
}
