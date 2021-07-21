//
//  UIView+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit

enum BorderSide {
  case top, bottom, left, right
}

extension UIView {
  
  func makeCircular() {
    self.layer.cornerRadius = (self.frame.width / 2);
    self.layer.masksToBounds = true
  }
  
  func fillOther(view: UIView) {
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  // Credit: https://stackoverflow.com/a/52814708
  func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
    let border = UIView()
    border.translatesAutoresizingMaskIntoConstraints = false
    border.backgroundColor = color
    self.addSubview(border)
    
    let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
    let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
    let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
    let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
    let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
    let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)
    
    
    switch side {
      case .top:
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
      case .right:
        NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
      case .bottom:
        NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
      case .left:
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
    }
  }
  
}
