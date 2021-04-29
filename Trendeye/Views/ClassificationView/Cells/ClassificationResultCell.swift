//
//  ClassificationResultCell.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

class ClassificationResultCell: UITableViewCell {
  
  static let reuseIdentifier = "ClassificationResultCell"
  
  var resultData: VNClassificationObservation! {
    didSet {
      identifierLabel.text = TEClassificationManager.shared.indentifiers[resultData.identifier]
      confidenceLabel.text = "\(TEClassificationManager.shared.convertConfidenceToPercent(resultData.confidence))%"
    }
  }
  
  var identifierLabel: UILabel = {
    let label = UILabel()
    let fontSize: CGFloat = 18
    label.translatesAutoresizingMaskIntoConstraints = false
    label.lineBreakMode = .byTruncatingTail
    label.font = AppFonts.Satoshi.font(face: .bold, size: fontSize)
    return label
  }()
  
  var confidenceLabel: UILabel = {
    let label = UILabel()
    let fontSize: CGFloat = 18
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .medium)
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    applyStyles()
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  fileprivate func applyStyles() {
    backgroundColor = K.Colors.ViewBackground
  }
  
}

// MARK: - Layout

fileprivate extension ClassificationResultCell {
  
  func applyLayouts() {
    layoutLabels()
  }
  
  func layoutLabels() {
    let identifierLabelPadding: CGFloat = 20
    let confidenceLabelWidth: CGFloat = 82
    let confidenceLabelPadding: CGFloat = 100
    contentView.addSubview(identifierLabel)
    contentView.addSubview(confidenceLabel)
    
    NSLayoutConstraint.activate([
      identifierLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      identifierLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: identifierLabelPadding),
      identifierLabel.trailingAnchor.constraint(equalTo: confidenceLabel.leadingAnchor),
      identifierLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      confidenceLabel.topAnchor.constraint(equalTo: identifierLabel.topAnchor),
      confidenceLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(confidenceLabelPadding)),
      confidenceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      confidenceLabel.widthAnchor.constraint(equalToConstant: confidenceLabelWidth)
    ])
  }
  
}
