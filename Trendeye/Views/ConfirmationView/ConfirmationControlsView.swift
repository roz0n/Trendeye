//
//  ConfirmationControlsView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

class ConfirmationControlsView: UIView {
  
  // MARK: - Properties
  
  var acceptButton: ConfirmationButton!
  var denyButton: ConfirmationButton!
  
  // MARK: - Views
  
  var buttonsContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .equalCentering
    return stack
  }()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    configureViewController()
    configureButtons()
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  fileprivate func configureViewController() {
    backgroundColor = K.Colors.Background
    addBorder(side: .top, color: K.Colors.Borders, width: 1)
  }
  
  fileprivate func configureButtons() {
    let acceptIcon = UIImage(systemName: K.Icons.Accept, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .heavy))
    let denyIcon = UIImage(systemName: K.Icons.Deny, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .heavy))!
    
    acceptButton = createButton(title: "Accept", bg: K.Colors.Blue, icon: acceptIcon, tint: K.Colors.White)
    denyButton = createButton(title: "Deny", bg: K.Colors.Red, icon: denyIcon, tint: K.Colors.White)
  }
  
}

// MARK: - Helpers

fileprivate func createButton(title: String, bg: UIColor?, icon: UIImage?, tint: UIColor?) -> ConfirmationButton {
  let button = ConfirmationButton(type: .system)
  
  button.setTitle(title, for: .application)
  button.backgroundColor = bg
  button.setImage(icon, for: .normal)
  button.tintColor = tint
  
  return button
}

// MARK: - Layout

fileprivate extension ConfirmationControlsView {
  
  func applyLayouts() {
    layoutButtons()
  }
  
  func layoutButtons() {
    let buttonPadding: CGFloat = 60
    
    buttonsContainer.addArrangedSubview(denyButton)
    buttonsContainer.addArrangedSubview(acceptButton)
    addSubview(buttonsContainer)
    
    NSLayoutConstraint.activate([
      buttonsContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: buttonPadding),
      buttonsContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -(buttonPadding)),
      buttonsContainer.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
    ])
  }
  
}

