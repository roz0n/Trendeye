//
//  UIView+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit

enum ViewBorder: String {
    case Left = "left"
    case Right = "right"
    case Top = "top"
    case Bottom = "bottom"
}

extension UIView {
    
    func makeCircular() {
        self.layer.cornerRadius = self.frame.width / 2;
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
                        case .Left:
                            borderView.frame = CGRect(x: 0, y: 0, width: width, height: view.frame.size.height)
                        case .Right:
                            borderView.frame = CGRect(x: view.frame.size.width - width, y: 0, width: width, height: view.frame.size.height)
                        case .Top:
                            borderView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: width)
                        case .Bottom:
                            borderView.frame = CGRect(x: 0, y: view.frame.size.height - width , width: view.frame.size.width, height: width)
                    }
                    
                    view.layer.addSublayer(borderView)
                }
            }
        }
    }
    
}
