//
//  CategoryCollectionView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import UIKit

class CategoryCollectionView: UICollectionView {
  
  // MARK: - Initializers
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    translatesAutoresizingMaskIntoConstraints = false
    
    register(CategoryImageCell.self, forCellWithReuseIdentifier: CategoryImageCell.reuseIdentifier)
    register(CategoryCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryCollectionHeaderView.reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
