//
//  ClassifierConfidenceButton.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/30/21.
//

import UIKit

class ClassifierConfidenceButton: UIButton {
  
  var classificationMetric: TrendClassificationMetric? {
    didSet {
      configureLabelText()
    }
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  fileprivate func configureLabelText() {
    guard let metric = classificationMetric else { return }
    
    let fontSize: CGFloat = 16
    let confidenceString = "confidence".uppercased()
    let metricString = metric.rawValue.uppercased()
    let spacerAttrString = NSMutableAttributedString(string: " ")
    
    // Eye icon string
    let eyeIcon = NSTextAttachment()
    eyeIcon.image = UIImage(systemName: K.Icons.Classifier, withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold))
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
      NSAttributedString.Key.kern: -0.25,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .black) as Any,
      NSAttributedString.Key.foregroundColor: K.Colors.Black,
    ], range: NSMakeRange(0, labelTextString.length))
    
    // Compose complete string
    let completeLabelAttrString = NSMutableAttributedString()
    completeLabelAttrString.append(eyeString)
    completeLabelAttrString.append(spacerAttrString)
    completeLabelAttrString.append(spacerAttrString)
    completeLabelAttrString.append(labelTextString)
    
    setAttributedTitle(completeLabelAttrString, for: .normal)
  }
  
}
