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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionViewLayout = DLNewsCollectionViewLayout()
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    
    //collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "NewsCell")
    view.addSubview(collectionView)
    
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
