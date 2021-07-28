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
  
  var textView: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textContainer.maximumNumberOfLines = 0
    view.textContainer.lineBreakMode = .byWordWrapping
    view.isScrollEnabled = false
    view.isUserInteractionEnabled = false
    view.backgroundColor = .clear
    view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    view.sizeToFit()
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .brown
    addSubview(textView)
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
