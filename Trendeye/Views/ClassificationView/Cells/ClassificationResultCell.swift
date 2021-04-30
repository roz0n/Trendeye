//
//  ClassificationResultCell.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

class ClassificationResultCell: UITableViewCell {
  
  class var reuseIdentifier: String {
    return "ClassificationResultCell"
  }
  
  static var estimatedHeight: CGFloat = 64
  
  var resultData: VNClassificationObservation! {
    didSet {
      identifierLabel.text = TEClassificationManager.shared.indentifiers[resultData.identifier]
      confidenceLabel.text = "\(TEClassificationManager.shared.convertConfidenceToPercent(resultData.confidence))%"
    }
  }
  
  var wrapper: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemOrange
    return view
  }()
  
  var container: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemGreen
    return view
  }()
  
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
    applyConfigurations()
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func applyConfigurations() {
    configureView()
  }
  
  fileprivate func configureView() {
    backgroundColor = K.Colors.ViewBackground
  }
  
}

// MARK: - Layout

fileprivate extension ClassificationResultCell {
  
  func applyLayouts() {
    layoutWrapper()
    layoutContainer()
    layoutLabels()
  }
  
  func layoutWrapper() {
    /**
     This view contains container with both labels and any secondary content that is to sit beneath them should be added as a subview
     */
    contentView.addSubview(wrapper)
    NSLayoutConstraint.activate([
      wrapper.topAnchor.constraint(equalTo: contentView.topAnchor),
      wrapper.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      wrapper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      wrapper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
  
  func layoutContainer() {
    /**
     This view contains only the identifier and confidence labels
     */
    wrapper.addSubview(container)
    container.addSubview(identifierLabel)
    container.addSubview(confidenceLabel)
    
    NSLayoutConstraint.activate([
      container.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
      container.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
    ])
    
    // Ensures these contraints are not applied to subclasses
    if reuseIdentifier == ClassificationResultCell.reuseIdentifier {
      container.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor).isActive = true
      let test = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: ClassificationResultCell.estimatedHeight)
      test.priority = UILayoutPriority(999)
      test.isActive = true
    }
  }
  
  func layoutLabels() {
    let identifierLabelPadding: CGFloat = 20
    let confidenceLabelWidth: CGFloat = 82
    let confidenceLabelPadding: CGFloat = 100
    
    NSLayoutConstraint.activate([
      identifierLabel.topAnchor.constraint(equalTo: container.topAnchor),
      identifierLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: identifierLabelPadding),
      identifierLabel.trailingAnchor.constraint(equalTo: confidenceLabel.leadingAnchor),
      identifierLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      
      confidenceLabel.topAnchor.constraint(equalTo: identifierLabel.topAnchor),
      confidenceLabel.leadingAnchor.constraint(equalTo: container.trailingAnchor, constant: -(confidenceLabelPadding)),
      confidenceLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      confidenceLabel.widthAnchor.constraint(equalToConstant: confidenceLabelWidth)
    ])
  }
  
}
