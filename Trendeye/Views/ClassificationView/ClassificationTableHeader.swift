//
//  ClassificationTableHeader.swift
//  ClassificationTableHeader
//
//  Created by Arnaldo Rozon on 7/22/21.
//

import UIKit

class ClassificationTableHeader: UITableViewHeaderFooterView {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "ClassificationTableHeader"
  
  // MARK: - Views
  
  var primaryContainer: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fillProportionally
    view.spacing = 20
    return view
  }()
  
  var secondaryContainer: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fillProportionally
    view.spacing = 10
    return view
  }()
  
  var primaryButton: UIButton = {
    let button = UIButton(type: .system)
    let buttonIcon = NSTextAttachment()
    let buttonTitle = NSMutableAttributedString()
    buttonIcon.image = UIImage(systemName: K.Icons.Info)?.withTintColor(K.Colors.White, renderingMode: .alwaysTemplate)
    buttonTitle.append(NSAttributedString(attachment: buttonIcon))
    buttonTitle.append(NSAttributedString(string: "  About analysis", attributes: [
      NSMutableAttributedString.Key.foregroundColor: K.Colors.White,
      NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
    ]))
    button.setAttributedTitle(buttonTitle, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    button.layer.cornerRadius = 8
    button.backgroundColor = K.Colors.Blue
    return button
  }()
  
  var positiveFeedbackButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(systemName: "hand.thumbsup.fill")?.withTintColor(K.Colors.Icon, renderingMode: .alwaysOriginal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 55).isActive = true
    button.heightAnchor.constraint(equalToConstant: 55).isActive = true
    button.layer.cornerRadius = 8
    button.layer.borderWidth = 1
    button.layer.borderColor = K.Colors.Borders.cgColor
    button.setImage(image, for: .normal)
    return button
  }()
  
  var negativeFeedbackButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(systemName: "hand.thumbsdown.fill")?.withTintColor(K.Colors.Icon, renderingMode: .alwaysOriginal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 55).isActive = true
    button.heightAnchor.constraint(equalToConstant: 55).isActive = true
    button.layer.cornerRadius = 8
    button.layer.borderWidth = 1
    button.layer.borderColor = K.Colors.Borders.cgColor
    button.setImage(image, for: .normal)
    return button
  }()
  
  // MARK: - Initializers
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    applyLayouts()
    configureGestures()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Gestures
  
  func configureGestures() {
    let positiveFeedbackGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPositiveFeedback))
    let negativeFeedbackGesture = UITapGestureRecognizer(target: self, action: #selector(tappedNegativeFeedback))
    
    positiveFeedbackButton.addGestureRecognizer(positiveFeedbackGesture)
    negativeFeedbackButton.addGestureRecognizer(negativeFeedbackGesture)
  }
  
  @objc func tappedPositiveFeedback() {
    print("Tapped positive")
  }
  
  @objc func tappedNegativeFeedback() {
    print("Tapped negative")
  }
  
}

// MARK: - Layout

fileprivate extension ClassificationTableHeader {
  
  func applyLayouts() {
    layoutContainers()
    layoutContent()
  }
  
  func layoutContainers() {
    addSubview(primaryContainer)
    
    NSLayoutConstraint.activate([
      primaryContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      primaryContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      primaryContainer.heightAnchor.constraint(equalToConstant: 55),
      primaryContainer.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func layoutContent() {
    primaryContainer.addArrangedSubview(primaryButton)
    primaryContainer.addArrangedSubview(secondaryContainer)
    secondaryContainer.addArrangedSubview(positiveFeedbackButton)
    secondaryContainer.addArrangedSubview(negativeFeedbackButton)
  }
  
}
