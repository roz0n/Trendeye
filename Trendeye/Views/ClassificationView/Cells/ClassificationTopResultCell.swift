//
//  ClassificationTopResultCell.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/29/21.
//

import UIKit

class ClassificationTopResultCell: ClassificationResultCell {
  
  override class var reuseIdentifier: String {
    return "ClassificationTopResultCell"
  }
  
  let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Best Match".uppercased()
    label.font = AppFonts.Satoshi.font(face: .black, size: 12)
    label.textColor = K.Colors.DarkGray
    return label
  }()
  
  let subtitle: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.textContainer.maximumNumberOfLines = 0
    textView.textContainer.lineBreakMode = .byWordWrapping
    textView.isScrollEnabled = false
    textView.isUserInteractionEnabled = false
    textView.isEditable = false
    textView.backgroundColor = .clear
    textView.removeAllInsets()
    textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.05
    
    textView.attributedText = NSMutableAttributedString(
      string: "Based on over 2,000 images uploaded to TrendList.org interpreted by a CoreML image classification model.",
      attributes: [
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.foregroundColor: K.Colors.DarkGray,
        NSAttributedString.Key.font: AppFonts.Satoshi.font(face: .medium, size: 12) as Any
      ])
    
    return textView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Layout

fileprivate extension ClassificationTopResultCell {
  
  func applyLayouts() {
    layoutSubtitle()
    layoutLabel()
  }
  
  func layoutLabel() {
    let xPadding: CGFloat = 20
    let yPadding: CGFloat = 20
    wrapper.insertSubview(label, at: 0)
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: yPadding - 5),
      label.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -(yPadding) / 2),
      label.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: xPadding),
      label.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -(xPadding))
    ])
  }
  
  func layoutSubtitle() {
    let xPadding: CGFloat = 20
    wrapper.addSubview(subtitle)
    NSLayoutConstraint.activate([
      subtitle.topAnchor.constraint(equalTo: identifierLabel.bottomAnchor),
      subtitle.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: xPadding),
      subtitle.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -(xPadding)),
      subtitle.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
    ])
  }
  
}
