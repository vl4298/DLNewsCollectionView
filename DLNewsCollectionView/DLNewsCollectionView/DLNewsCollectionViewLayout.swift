//
//  DLNewsCollectionViewLayout.swift
//  DLNewsCollectionView
//
//  Created by Dinh Luu on 28/06/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

class DLNewsCollectionViewLayout: UICollectionViewLayout {

  let itemGap: CGFloat = 10.0
  let itemSize: CGFloat = 250.0
  let numVisibleItems = 4
  var yOrigin: CGFloat = 200.0
  let xOrigin: CGFloat = 20.0
  var scale: CGFloat = 0.9
  let visibleItem = 3
  var attributes = [UICollectionViewLayoutAttributes]()
  
  override func prepareLayout() {
    super.prepareLayout()
    if attributes.count > 0 {
      return
    }
    
    let numItems = collectionView!.numberOfItemsInSection(0)
    var transform = CATransform3DIdentity
    transform.m34 = -1/5000
    for index in 0..<numItems {
      let indexPath = NSIndexPath(forItem: index, inSection: 0)
      let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
      attribute.frame = CGRect(x: collectionView!.center.x - itemSize/2, y: yOrigin, width: itemSize, height: itemSize)
      transform = CATransform3DScale(CATransform3DIdentity, scale, scale , 1)
      attribute.transform3D = transform
      attribute.zIndex = 0 - index
      yOrigin -= 20.0
      scale -= 0.1
      
      if index > visibleItem {
        attribute.hidden = true
      }
      
      attributes.append(attribute)
    }
  }
  
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: collectionView!.bounds.width, height: collectionView!.bounds.height)
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    for attr in attributes {
      attr.zIndex = 0 - attr.indexPath.item
    }
    return attributes
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    let attri = attributes[indexPath.item]
    attri.transform3D = CATransform3DTranslate(attri.transform3D, 0, 0, -CGFloat(attri.indexPath.item))
    return attributes[indexPath.item]
  }
  
  override func layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath: NSIndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
    let attribute = super.layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath, withTargetPosition: position)
    attribute.center = position
    attribute.alpha = 0.7
    return attribute
  }
  
  func removeAllAttribute() {
    attributes.removeAll()
    scale = 0.9
    yOrigin = 200.0
  }

}
