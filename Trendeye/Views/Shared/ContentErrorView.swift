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
    stack.axis = .vertical
    stack.spacing = 12
    return stack
  }()
  
  let imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .center
    view.tintColor = K.Colors.Foreground
    return view
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    let fontSize: CGFloat = 20
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    label.tintColor = K.Colors.Foreground
    return label
  }()
  
  let messageView: UILabel = {
    let label = UILabel()
    let fontSize: CGFloat = 16
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    label.numberOfLines = 0
    label.isUserInteractionEnabled = false
    label.backgroundColor = .clear
    label.tintColor = K.Colors.Foreground
    return label
  }()
  
  // MARK: - Initializers
  
  init(image: UIImage, title: String, message: String) {
    super.init(frame: .zero)
    
    self.translatesAutoresizingMaskIntoConstraints = false
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

