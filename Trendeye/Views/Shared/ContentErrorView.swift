//
//  ContentErrorView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/26/21.
//

import UIKit

class ContentErrorView: UIView {
  
  // MARK: - Properties
  
  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  
  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  var message: String? {
    didSet {
      messageView.text = message
    }
  }
  
  // MARK: - Views
  
  let container: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .fillProportionally
    stack.axis = .vertical
    return stack
  }()
  
  let imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .center
    view.tintColor = K.Colors.Icon
    return view
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    let fontSize: CGFloat = 20
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    label.tintColor = K.Colors.DarkGray
    return label
  }()
  
  let messageView: UITextView = {
    let view = UITextView()
    let fontSize: CGFloat = 16
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textAlignment = .center
    view.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    view.textContainer.maximumNumberOfLines = 0
    view.textContainer.lineBreakMode = .byWordWrapping
    view.isScrollEnabled = false
    view.isEditable = false
    view.isUserInteractionEnabled = false
    view.backgroundColor = .clear
    view.tintColor = K.Colors.DarkGray
    view.textContainerInset = UIEdgeInsets(top: (fontSize / 2), left: fontSize, bottom: 0, right: fontSize)
    return view
  }()
  
  // MARK: - Initializers
  
  init(image: UIImage, title: String, message: String) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    
    self.image = image
    self.title = title
    self.message = message
    
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Layout

fileprivate extension ContentErrorView {
  
  func applyLayouts() {
    layoutContainer()
    layoutIcon()
    layoutTitle()
    layoutMessage()
  }
  
  func layoutContainer() {
    addSubview(container)
    container.fillOther(view: self)
  }
  
  func layoutIcon() {
    let padding: CGFloat = 16
    
    imageView.image = image?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -(padding), right: 0))
    container.addArrangedSubview(imageView)
  }
  
  func layoutTitle() {
    titleLabel.text = title
    container.addArrangedSubview(titleLabel)
  }
  
  func layoutMessage() {
    messageView.text = message
    container.addArrangedSubview(messageView)
  }
  
}

