//
//  InfoListItemView.swift
//  InfoListItemView
//
//  Created by Arnaldo Rozon on 8/10/21.
//

import UIKit

class InfoListItemView: UIView {
  
  // MARK: - Views
  
  var contentContainerView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.distribution = .fillProportionally
    view.axis = .horizontal
    view.spacing = 20
    return view
  }()
  
  var textContainerView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.spacing = 8
    return view
  }()
  
  var iconView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .top
    view.widthAnchor.constraint(equalToConstant: 50).isActive = true
    return view
  }()
    
  var headerLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = K.Colors.White
    return label
  }()
  
  var bodyLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.numberOfLines = 0
    view.lineBreakMode = .byWordWrapping
    view.isUserInteractionEnabled = false
    view.textColor = K.Colors.White
    return view
  }()
  
  // MARK: - Initializers
  
  init(iconSymbol: String, iconColor: UIColor, headerText: String, bodyText: String) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    
    configureText(headerText: headerText, bodyText: bodyText)
    configureIcon(symbol: iconSymbol, color: iconColor)
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  fileprivate func configureIcon(symbol: String, color: UIColor) {
    iconView.image = UIImage(systemName: symbol, withConfiguration: UIImage.SymbolConfiguration(pointSize: 42, weight: .bold))?.withTintColor(color, renderingMode: .alwaysOriginal)
  }
  
  fileprivate func configureText(headerText: String, bodyText: String) {
    headerLabel.text = headerText
    bodyLabel.text = bodyText
  }
  
}

// MARK: - Layout

fileprivate extension InfoListItemView {
  
  func applyLayouts() {
    layoutContentContainer()
    layoutContent()
  }
  
  func layoutContentContainer() {
    addSubview(contentContainerView)
    contentContainerView.fillOther(view: self)
  }
  
  func layoutContent() {
    // Icon
    contentContainerView.addArrangedSubview(iconView)
    
    // Text container
    textContainerView.addArrangedSubview(headerLabel)
    textContainerView.addArrangedSubview(bodyLabel)
    
    // Full contained
    contentContainerView.addArrangedSubview(textContainerView)
  }
  
}
