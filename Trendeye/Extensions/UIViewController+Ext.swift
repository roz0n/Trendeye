//
//  UIViewController+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/23/21.
//

import UIKit

extension UIViewController {
  
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
