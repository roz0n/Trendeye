//
//  ClassificationMetricChip.swift
//  ClassificationMetricChip
//
//  Created by Arnaldo Rozon on 7/25/21.
//

import UIKit

class ClassificationMetricChip: UIButton {
  
  // MARK: - Properties
  
  var metric: TrendClassificationMetric? {
    didSet {
      guard let metric = metric else { return }
      setAppearance(to: metric)
    }
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureSize()
    configureAppearance()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  fileprivate func configureSize() {
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: 60).isActive = true
    
    setTitle("?".uppercased(), for: .normal)
    setTitleColor(K.Colors.White, for: .normal)
    
    titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
    backgroundColor = K.Colors.White.withAlphaComponent(0.10)
  }
  
  fileprivate func configureAppearance() {
    layer.cornerRadius = 4
  }
  
  // MARK: - Helpers
  
  func setAppearance(to metric: TrendClassificationMetric) {
    switch metric {
      case .low:
        setTitle("Low".uppercased(), for: .normal)
        setTitleColor(K.Colors.Red, for: .normal)
        backgroundColor = K.Colors.Red.withAlphaComponent(0.10)
      case .mild:
        setTitle("Mild".uppercased(), for: .normal)
        setTitleColor(K.Colors.Yellow, for: .normal)
        backgroundColor = K.Colors.Yellow.withAlphaComponent(0.10)
      case .high:
        setTitle("High".uppercased(), for: .normal)
        setTitleColor(K.Colors.Green, for: .normal)
        backgroundColor = K.Colors.Green.withAlphaComponent(0.10)
    }
  }
  
}
