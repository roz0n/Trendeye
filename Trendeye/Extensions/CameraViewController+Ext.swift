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
    let vc = CategoryViewController()
    
    vc.identifier = "letterspace"
    vc.name = "Letterspace"
    vc.title = "Letterspace"
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func SHORTCUT_PRESENT_CLASSIFICATION() {
    let vc = ClassificationViewController(with: UIImage(named: "TestImage.png")!)
    
    vc.navigationItem.title = "Trend Analysis"
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func SHORTCUT_PRESENT_CONFIRMATION() {
    let vc = ConfirmationViewController()
    let image = UIImage(named: "TestImage.png")!
    
    vc.selectedImage = image
    vc.navigationItem.title = "Confirm Photo"
    vc.modalPresentationStyle = .overFullScreen
    
    currentImage = image
    videoPreviewLayer.isHidden = true
    captureSession.stopRunning()
    
    present(vc, animated: true, completion: nil)
  }
  
}
