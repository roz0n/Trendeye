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
  
  func presentSimpleAlert(title: String, message: String, actionTitle: String) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    let action = UIAlertAction(title: actionTitle, style: .default) { _ in
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
}
