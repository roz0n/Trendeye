//
//  ConfirmationButton.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

// TODO: Make this a `system` button
class ConfirmationButton: UIButton {
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 90).isActive = true
    widthAnchor.constraint(equalToConstant: 90).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    makeCircular()
  }
  
}
