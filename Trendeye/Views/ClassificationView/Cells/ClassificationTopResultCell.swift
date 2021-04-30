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
  
  let subtitle: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.textContainer.maximumNumberOfLines = 0
    textView.textContainer.lineBreakMode = .byWordWrapping
    textView.isScrollEnabled = false
    textView.isUserInteractionEnabled = false
    textView.isEditable = false
    textView.text = "Based on over 2,000 images uploaded to TrendList.org and powered by CoreML image classification."
    return textView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    applyLayouts()
    contentView.backgroundColor = .systemPink
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Layout

fileprivate extension ClassificationTopResultCell {
  
  func applyLayouts() {
    layoutSubtitle()
  }
  
  func layoutSubtitle() {
    let yPadding: CGFloat = 32
    let xPadding: CGFloat = 20
    wrapper.addSubview(subtitle)
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: yPadding),
      subtitle.topAnchor.constraint(equalTo: identifierLabel.bottomAnchor),
      subtitle.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: xPadding),
      subtitle.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
      subtitle.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
    ])
  }
  
}
