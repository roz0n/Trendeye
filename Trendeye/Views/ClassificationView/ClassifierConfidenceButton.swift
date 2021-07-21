//
//  ClassifierConfidenceButton.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/30/21.
//

import UIKit
import Vision

class ClassifierConfidenceButton: UIView {
  
  enum ConfidenceMetrics: String {
    case low = "low"
    case mild = "mild"
    case high = "high"
  }
  
  var classificationMetric: ConfidenceMetrics?
  
  var classificationTopResult: VNClassificationObservation? {
    didSet {
      setClassificationMetric()
      setBackgroundColor()
    }
  }
  
  var buttonWidth: CGFloat? {
    didSet {
      if let width = buttonWidth {
        button.widthAnchor.constraint(equalToConstant: width + (buttonXPadding * 2)).isActive = true
      }
    }
  }
  
  var button: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.masksToBounds = true
    return button
  }()
  
  let buttonXPadding: CGFloat = 14
  
  override var intrinsicContentSize: CGSize {
    return UIView.layoutFittingExpandedSize
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: -
  
  override func layoutSubviews() {
    super.layoutSubviews()
    applyConfigurations()
  }
  
  // MARK: - Helpers
  
  fileprivate func setClassificationMetric() {
    // TODO: This might be too "smart" for this view
    guard let topResult = classificationTopResult else { return }
    let resultValue = (topResult.confidence) * 100
        
    if 0...33 ~= resultValue {
      classificationMetric = .low
    } else if 34...66 ~= resultValue {
      classificationMetric = .mild
    } else if 67...100 ~= resultValue {
      classificationMetric = .high
    } else {
      // TODO: Is this needed?
      classificationMetric = .none
    }
  }
  
  fileprivate func setBackgroundColor() {
    switch classificationMetric {
      case .low:
        button.backgroundColor = K.Colors.Red
      case .mild:
        button.backgroundColor = .systemOrange
      case .high:
        button.backgroundColor = K.Colors.Green
      case .none:
        // TODO: Is this needed?
        button.isHidden = true
    }
  }
  
  // MARK: - Configurations
  
  fileprivate func applyConfigurations() {
    configureLabelRadius()
    configureLabelText()
  }
  
  fileprivate func configureLabelRadius() {
    button.layer.cornerRadius = button.frame.height / 2
  }
  
  fileprivate func configureLabelText() {
    guard let metric = classificationMetric else { return }
    
    let fontSize: CGFloat = 14
    let confidenceString = "confidence".uppercased()
    let metricString = metric.rawValue.uppercased()
    let spacerAttrString = NSMutableAttributedString(string: " ")
    
    // Eye icon string
    let eyeIcon = NSTextAttachment()
    eyeIcon.image = UIImage(systemName: K.Icons.Classifier,
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold))
    let eyeString = NSAttributedString(attachment: eyeIcon)
    
    // Label text string
    let labelTextString: NSMutableAttributedString = {
      let metricAttrString = NSMutableAttributedString(string: metricString)
      let confidenceAttrString = NSMutableAttributedString(string: confidenceString)
      
      metricAttrString.append(spacerAttrString)
      metricAttrString.append(confidenceAttrString)
      
      return metricAttrString
    }()
    
    // Add attributes
    labelTextString.addAttributes([
      NSAttributedString.Key.kern: -0.24,
      NSAttributedString.Key.font: AppFonts.Satoshi.font(face: .black, size: fontSize) as Any,
//      NSAttributedString.Key.foregroundColor: K.Colors.NavigationBar,
    ], range: NSMakeRange(0, labelTextString.length))
    
    // Compose complete string
    let completeLabelAttrString = NSMutableAttributedString()
    completeLabelAttrString.append(eyeString)
    completeLabelAttrString.append(spacerAttrString)
    completeLabelAttrString.append(spacerAttrString)
    completeLabelAttrString.append(labelTextString)
    
    button.titleLabel?.attributedText = completeLabelAttrString
    button.setAttributedTitle(button.titleLabel?.attributedText, for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonXPadding, bottom: 0, right: buttonXPadding)
    buttonWidth = button.intrinsicContentSize.width
  }
  
}


// MARK: - Layout

fileprivate extension ClassifierConfidenceButton {
  
  func applyLayouts() {
    layoutButton()
  }
  
  func layoutButton() {
    let padding: CGFloat = 8
    addSubview(button)
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
      button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(padding)),
      button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
    ])
  }
  
}
