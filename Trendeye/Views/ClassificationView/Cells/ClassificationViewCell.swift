//
//  ClassificationViewCell.swift
//  ClassificationViewCell
//
//  Created by Arnaldo Rozon on 7/22/21.
//

import UIKit
import Vision

class ClassificationViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "ClassificationViewCell"
  
  var resultData: VNClassificationObservation! {
    didSet {
      identifierLabel.text = TEClassificationManager.shared.indentifiers[resultData.identifier]
      resultBars = StackedBarsView(percentage: TEClassificationManager.shared.convertConfidenceToPercent(resultData.confidence), color: K.Colors.Foreground)
    }
  }
  
  // MARK: - Views
  
  var resultBars: StackedBarsView? {
    didSet {
      configureResultBars()
    }
  }
  
  var container: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fillProportionally
    view.spacing = 30
    view.layer.cornerRadius = 8
    view.layer.borderWidth = 1
    view.layer.borderColor = K.Colors.Borders.cgColor
    view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    view.isLayoutMarginsRelativeArrangement = true
    return view
  }()
  
  var identifierLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    label.adjustsFontSizeToFitWidth = false
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
  
  var resultBarsContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: StackedBarsView.contentWidth).isActive = true
    return view
  }()
    
  var disclosureIndicatorContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: 14).isActive = true
    return view
  }()
  
  var disclosureIndicator: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.image = UIImage.init(systemName: K.Icons.ArrowRight)?.withTintColor(K.Colors.Foreground, renderingMode: .alwaysOriginal )
    return view
  }()
  
  // MARK: - Initializers
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = K.Colors.Background
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  func configureResultBars() {
    // Something about this feels awkward, but it works for now
    if let resultBars = resultBars {
      resultBarsContainer.addSubview(resultBars.view)
    }
  }
  
}

// MARK: - Layout

fileprivate extension ClassificationViewCell {
  
  func applyLayouts() {
    layoutContainer()
    layoutContent()
    layoutDisclosureIndicator()
  }
  
  func layoutContainer() {
    contentView.addSubview(container)
    
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  func layoutContent() {
    container.addArrangedSubview(identifierLabel)
    container.addArrangedSubview(resultBarsContainer)
    container.addArrangedSubview(disclosureIndicatorContainer)
  }
  
  func layoutDisclosureIndicator() {
    disclosureIndicatorContainer.addSubview(disclosureIndicator)
    
    NSLayoutConstraint.activate([
      disclosureIndicator.centerYAnchor.constraint(equalTo: disclosureIndicatorContainer.centerYAnchor),
      disclosureIndicator.trailingAnchor.constraint(equalTo: disclosureIndicatorContainer.trailingAnchor)
    ])
  }
  
}
