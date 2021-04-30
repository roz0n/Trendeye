//
//  ClassificationConfidenceButton.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/30/21.
//

import UIKit

class ClassificationConfidenceButton: UIView {
  
  var buttonWidth: CGFloat? {
    didSet {
      if let width = buttonWidth {
        button.widthAnchor.constraint(equalToConstant: width + (buttonXPadding * 2)).isActive = true
      }
    }
  }
  
  let buttonXPadding: CGFloat = 14
  
  var button: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.masksToBounds = true
    button.backgroundColor = K.Colors.Red
    return button
  }()
  
  override var intrinsicContentSize: CGSize {
    return UIView.layoutFittingExpandedSize
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    applyConfigurations()
  }
  
  fileprivate func applyConfigurations() {
    configureLabelRadius()
    configureLabelText()
  }
  
  fileprivate func configureLabelRadius() {
    button.layer.cornerRadius = button.frame.height / 2
  }
  
  fileprivate func configureLabelText() {
    let fontSize: CGFloat = 14
    let labelString = NSMutableAttributedString()
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = UIImage(
      systemName: "eye.fill",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold))
    let imageString = NSAttributedString(attachment: imageAttachment)
    let textString = NSMutableAttributedString(string: "   LOW CONFIDENCE", attributes: [
      NSAttributedString.Key.kern: -0.24,
      NSAttributedString.Key.font: AppFonts.Satoshi.font(face: .black, size: fontSize) as Any,
      NSAttributedString.Key.foregroundColor: K.Colors.NavigationBar,
    ])
    
    labelString.append(imageString)
    labelString.append(textString)
        
    button.titleLabel?.attributedText = labelString
    button.setAttributedTitle(button.titleLabel?.attributedText, for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonXPadding, bottom: 0, right: buttonXPadding)
    buttonWidth = button.intrinsicContentSize.width
  }
  
}


// MARK: - Layout

fileprivate extension ClassificationConfidenceButton {
  
  func applyLayouts() {
    layoutButton()
  }
  
  func layoutButton() {
    addSubview(button)
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
      button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
    ])
  }
  
}
