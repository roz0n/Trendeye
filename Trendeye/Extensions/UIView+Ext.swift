//
//  UIView+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit

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
    
}
