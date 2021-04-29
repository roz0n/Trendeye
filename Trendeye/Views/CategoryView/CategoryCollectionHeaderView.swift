//
//  CategoryCollectionHeaderView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/21/21.
//

import UIKit

class CategoryCollectionHeaderView: UICollectionReusableView {
  
  static let reuseIdentifier = "CategoryCollectionHeader"
  let padding: CGFloat = 16
  
  var label: UITextView = {
    let label = UITextView()
    let fontSize: CGFloat = 18
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textContainer.maximumNumberOfLines = 0
    label.textContainer.lineBreakMode = .byWordWrapping
    label.isScrollEnabled = false
    label.isUserInteractionEnabled = false
    label.backgroundColor = .clear
    label.font = AppFonts.Satoshi.font(face: .bold, size: fontSize)
    label.text = "More like this"
    label.sizeToFit()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = K.Colors.ViewBackground
    addBorder(borders: [.Bottom], color: K.Colors.BorderColor, width: 1)
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      label.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      label.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -(padding))
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
