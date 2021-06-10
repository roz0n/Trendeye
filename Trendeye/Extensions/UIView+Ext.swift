//
//  UIView+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit

enum ViewBorder: String {
  case left = "left"
  case right = "right"
  case top = "top"
  case bottom = "bottom"
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
  
  func addBorder(borders: [ViewBorder], color: UIColor, width: CGFloat) {
    DispatchQueue.main.async {
      borders.forEach { [weak self] (border) in
        if let view = self {
          let borderView = CALayer()
          
          borderView.backgroundColor = color.cgColor
          borderView.name = border.rawValue
          
          switch border {
            case .left:
              borderView.frame = CGRect(x: 0, y: 0, width: width, height: view.frame.size.height)
            case .right:
              borderView.frame = CGRect(x: view.frame.size.width - width, y: 0, width: width, height: view.frame.size.height)
            case .top:
              borderView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: width)
            case .bottom:
              borderView.frame = CGRect(x: 0, y: view.frame.size.height - width , width: view.frame.size.width, height: width)
          }
          
          view.layer.addSublayer(borderView)
        }
      }
    }
  }
  
}
