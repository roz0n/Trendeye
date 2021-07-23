//
//  ClassificationImageHeader.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit

class ClassificationImageHeader: UIView {
  
  var classificationImage: UIImage? {
    didSet {
      backgroundView.image = classificationImage
      imageView.image = classificationImage
    }
  }
  
  let backgroundView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleToFill
    view.clipsToBounds = true
    return view
  }()
  
  let blurView: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.clipsToBounds = true
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Layout

fileprivate extension ClassificationImageHeader {
  
  func applyLayouts() {
    layoutBackgroundView()
    layoutBlurView()
    layoutImageView()
  }
  
  func layoutBackgroundView() {
    addSubview(backgroundView)
    backgroundView.fillOther(view: self)
  }
  
  func layoutBlurView() {
    addSubview(blurView)
    blurView.fillOther(view: self)
  }
  
  func layoutImageView() {
    let xPadding: CGFloat = 10
    let yPadding: CGFloat = 20

    addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: yPadding),
      imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xPadding),
      imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(xPadding)),
      imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(yPadding))
    ])
  }
  
}

