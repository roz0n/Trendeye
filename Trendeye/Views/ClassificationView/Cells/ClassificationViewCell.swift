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
      identifierLabel.text = TrendClassifierManager.shared.indentifiers[resultData.identifier]
      // TODO: Set result chip text
    }
  }
  
  // MARK: - Views
  
  var container: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fillProportionally
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
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    return label
  }()
  
  var resultChip: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("High".uppercased(), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
    button.titleLabel?.textColor = .green
    button.backgroundColor = .green.withAlphaComponent(0.10)
    button.widthAnchor.constraint(equalToConstant: 60).isActive = true
    button.layer.cornerRadius = 4
    return button
  }()
  
  var disclosureIndicatorContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: 40).isActive = true
    return view
  }()
  
  var disclosureIndicator: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.image = UIImage.init(systemName: K.Icons.ArrowRight)?.withTintColor(K.Colors.Icon, renderingMode: .alwaysOriginal )
    return view
  }()
  
  // MARK: - Initializers
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .clear
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
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
    container.addArrangedSubview(resultChip)
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
