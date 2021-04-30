//
//  ClassificationConfidenceLabel.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/30/21.
//

import UIKit

class ClassificationConfidenceLabel: UIView {
  
  var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = .systemPink
    label.textAlignment = .center
    label.layer.masksToBounds = true
    label.textColor = K.Colors.NavigationBar
    label.font = AppFonts.Satoshi.font(face: .heavy, size: 11)
    return label
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
    label.layer.cornerRadius = label.frame.height / 2
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
      NSAttributedString.Key.font: AppFonts.Satoshi.font(face: .black, size: fontSize) as Any
    ])
    labelString.append(imageString)
    labelString.append(textString)
    
    label.attributedText = labelString
  }
  
}


// MARK: - Layout

fileprivate extension ClassificationConfidenceLabel {
  
  func applyLayouts() {
    layoutLabel()
  }
  
  func layoutLabel() {
    addSubview(label)
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
      label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }
  
}
