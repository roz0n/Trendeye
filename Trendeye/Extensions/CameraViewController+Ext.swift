//
//  CameraViewController+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/28/21.
//

import UIKit

/**
 These methods exist to provide  "shortcuts" to view controllers in the app by populating view controllers with their unique properties and presenting them on the screen.
 Mainly they are used for development and debugging.
 */

extension CameraViewController {
  
  func SHORTCUT_PRESENT_CATEGORY() {
    let cvc = CategoryViewController()
    cvc.identifier = "letterspace"
    cvc.name = "Letterspace"
    cvc.title = "Letterspace"
    navigationController?.pushViewController(cvc, animated: true)
  }
  
  func SHORTCUT_PRESENT_CLASSIFICATION() {
    let cvc = ClassificationViewController(with: UIImage(named: "TestImage.png")!)
    cvc.navigationItem.title = "Trend Analysis"
    navigationController?.pushViewController(cvc, animated: true)
  }
  
}
