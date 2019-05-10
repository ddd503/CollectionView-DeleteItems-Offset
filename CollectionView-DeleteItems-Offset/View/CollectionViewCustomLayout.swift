//
//  CollectionViewCustomLayout.swift
//  CollectionView-DeleteItems-Offset
//
//  Created by kawaharadai on 2019/05/07.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class CollectionViewCustomLayout: UICollectionViewLayout {

    // MARK: - Propatis
    private let numberOfColumns = 3
    private let cellPadding = CGFloat(integerLiteral: 0)
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    private var contentHeight = CGFloat.zero
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    // 直近のy軸のoffsetを保持
    private var lastContentOffsetY = CGFloat.zero
    // offset保持を行うかどうか
    var isKeepCurrentOffset = false

    // MARK: - Life Cycle
    override func prepare() {
        if let collectionView = collectionView {
            lastContentOffsetY = collectionView.contentOffset.y
        }
        resetAttributes()
        setupAttributes()
    }

    override var collectionViewContentSize: CGSize {
        let contentSize = CGSize(width: contentWidth, height: contentHeight)
        // セルの増減があった時にcurrentのoffsetを保つ場合は改めてoffsetをセットし直す（このタイミングでは新しいレイアウトが決まっている）
        if let collectionView = collectionView {
            setContentOffsetIfNeeded(shouldSetContentOffset: isKeepCurrentOffset &&
                (contentSize.height > collectionView.frame.size.height),
                                     collectionView: collectionView)
        }
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter({ (layoutAttributes) -> Bool in
            rect.intersects(layoutAttributes.frame)
        })
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    // MARK: - Private
    private func setupAttributes() {
        guard cachedAttributes.isEmpty, let collectionView = collectionView else { return }
        let cellLength = contentWidth / CGFloat(numberOfColumns)
        let cellXOffsets = (0 ..< numberOfColumns).map {
            CGFloat($0) * cellLength
        }
        gridAttributes(collectionView: collectionView,
                       cellLength: cellLength,
                       cellXOffsets: cellXOffsets)
    }

    private func resetAttributes() {
        cachedAttributes = []
        contentHeight = 0
        collectionView?.contentOffset.y = 0
    }

    private func addAttributes(cellFrame: CGRect, indexPath: IndexPath) {
        let itemFrame = cellFrame.insetBy(dx: cellPadding, dy: cellPadding)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = itemFrame
        cachedAttributes.append(attributes)
        contentHeight = max(contentHeight, cellFrame.maxY)
    }

    private func gridAttributes(collectionView: UICollectionView, cellLength: CGFloat, cellXOffsets: [CGFloat]) {
        var cellYOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
        var currentColumnNumber = 0
        (0 ..< collectionView.numberOfItems(inSection: 0)).forEach {
            let indexPath = IndexPath(item: $0, section: 0)
            let cellFrame = CGRect(x: cellXOffsets[currentColumnNumber],
                                   y: cellYOffsets[currentColumnNumber],
                                   width: cellLength,
                                   height: cellLength)
            cellYOffsets[currentColumnNumber] = cellYOffsets[currentColumnNumber] + cellLength
            currentColumnNumber = currentColumnNumber < (numberOfColumns - 1) ? currentColumnNumber + 1 : 0
            addAttributes(cellFrame: cellFrame, indexPath: indexPath)
        }
    }

    private func setContentOffsetIfNeeded(shouldSetContentOffset: Bool, collectionView: UICollectionView) {
        if shouldSetContentOffset {
            let newOffset = CGPoint(x: collectionView.frame.origin.x, y: lastContentOffsetY)
            collectionView.setContentOffset(newOffset, animated: false)
            isKeepCurrentOffset = false
        }
    }

}
