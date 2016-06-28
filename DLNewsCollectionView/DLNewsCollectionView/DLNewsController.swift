//
//  DLNewsController.swift
//  DLNewsCollectionView
//
//  Created by Dinh Luu on 28/06/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

import UIKit

class DLNewsController: UIViewController {

  var collectionView: UICollectionView! = nil
  var collectionViewLayout: DLNewsCollectionViewLayout! = nil
  var dataSource = [UIColor]()
  var isInteracting = false
  var currentIndex = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionViewLayout = DLNewsCollectionViewLayout()
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    
    collectionView.delegate = self
    collectionView.dataSource = self
    //collectionView.userInteractionEnabled = true
    
    collectionView.registerClass(DLNewsCollectionViewCell.self, forCellWithReuseIdentifier: "NewsCell")
    view.addSubview(collectionView)
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.interactive(_:)))
    collectionView.addGestureRecognizer(panGesture)
    
    initDatasoruce()
  }
  
  private func initDatasoruce() {
    for _ in 0..<10 {
      let color = self.randomColor()
      dataSource.append(UIColor(red: color.cor1, green: color.cor2, blue: color.cor3, alpha: 1.0))
    }
  }
  private func randomColor() -> (cor1: CGFloat, cor2: CGFloat, cor3: CGFloat) {
    let cor1: CGFloat = CGFloat(arc4random_uniform(255) + 1) / 255
    let cor2: CGFloat = CGFloat(arc4random_uniform(255) + 1) / 255
    let cor3: CGFloat = CGFloat(arc4random_uniform(255) + 1) / 255
    return (cor1: cor1, cor2: cor2, cor3: cor3)
  }
  
  @objc func interactive(gesture: UIPanGestureRecognizer) {
    let position = gesture.locationInView(view)
    switch gesture.state {
    case .Began:
      if isInteracting { return }
      
      isInteracting = true
      
      guard let indexPath = collectionView.indexPathForItemAtPoint(position) else {return}
      currentIndex = indexPath.row
      collectionView.beginInteractiveMovementForItemAtIndexPath(indexPath)
    case .Changed:
      collectionView.updateInteractiveMovementTargetPosition(position)
    case .Cancelled:
      isInteracting = false
      collectionView.cancelInteractiveMovement()
    default:
      print(view.frame.width - position.x)
      if view.frame.width - position.x < 30 {
        removeAt(currentIndex)
      }
      isInteracting = false
      collectionView.endInteractiveMovement()
    }
  }
  
  private func removeAt(index: Int) {
    self.dataSource.removeAtIndex(index)
    collectionView.performBatchUpdates({
      self.collectionViewLayout.removeAllAttribute()
      self.collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
      }, completion: nil)
  }
}

extension DLNewsController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCell", forIndexPath: indexPath)
    cell.backgroundColor = dataSource[indexPath.row]
    return cell
  }
}

extension DLNewsController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, targetIndexPathForMoveFromItemAtIndexPath originalIndexPath: NSIndexPath, toProposedIndexPath proposedIndexPath: NSIndexPath) -> NSIndexPath {
    return originalIndexPath
  }
  
  func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    //collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
    collectionViewLayout.invalidateLayout()
  }
}
