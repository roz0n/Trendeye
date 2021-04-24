//
//  UIViewController+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/23/21.
//

import UIKit

extension UIViewController {
    
    func enableLargeTitles() {
        guard let navigationController = navigationController else { return }
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func disableLargeTitles() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
}
