//
//  CategoryImageCellCollectionViewCell.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import UIKit

class CategoryImageCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "CategoryImageCell"
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  fileprivate func configureView() {
    contentView.clipsToBounds = true
    layer.cornerRadius = 8
  }
  
  // MARK: - Helpers
  
  func addBorder() {
    // This method is called externally when the cell is dequeued if needed
    layer.borderWidth = 1
    layer.borderColor = K.Colors.Borders.cgColor
  }
  
}
