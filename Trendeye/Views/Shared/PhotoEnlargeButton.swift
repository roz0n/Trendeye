//
//  PhotoEnlargeButton.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

// TODO: This should be a global class called RoundButton that ConfirmationButton and PhotoEnlargeButton inherit from
// TODO: Make this a `system` button
class PhotoEnlargeButton: UIButton {
  
  // MARK: - Properties
  
  var height: CGFloat?
  var width: CGFloat?
  
  // MARK: - Initializers
  
  init(height: CGFloat, width: CGFloat) {
    super.init(frame: .zero)
    self.height = height
    self.width = width
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.heightAnchor.constraint(equalToConstant: height),
      self.widthAnchor.constraint(equalToConstant: width)
    ])
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.heightAnchor.constraint(equalToConstant: 90),
      self.widthAnchor.constraint(equalToConstant: 90)
    ])
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
