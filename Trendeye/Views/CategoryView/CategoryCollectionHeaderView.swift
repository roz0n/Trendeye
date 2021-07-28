//
//  CategoryCollectionHeaderView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/21/21.
//

import UIKit

class CategoryCollectionHeaderView: UICollectionReusableView {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "CategoryCollectionHeader"
  
  // MARK: - Views
  
  var textView: UITextView = {
    let view = UITextView()
    let padding: CGFloat = 12
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textContainer.maximumNumberOfLines = 0
    view.textContainer.lineBreakMode = .byWordWrapping
    view.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    view.isScrollEnabled = false
    view.isUserInteractionEnabled = false
    view.backgroundColor = .clear
    
    return view
  }()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
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
  
  // MARK: - Helpers
  
  func setText(_ text: String) {
    let paragraphStyle = NSMutableParagraphStyle()
    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: K.Colors.White]
    
    paragraphStyle.lineSpacing = 8
    textView.attributedText = NSAttributedString(string: text, attributes: attributes)
  }
  
}
