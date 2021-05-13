//
//  CameraErrorView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/28/21.
//

import UIKit

class CameraErrorView: ContentErrorView {
  
  convenience init() {
    let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .medium)
    let icon = UIImage(systemName: K.Icons.CameraError, withConfiguration: config)
    self.init(image: icon!,
              title: "Unable to Access Camera",
              message: "Camera access is required to capture still images. Please enable access in your device settings to continue.")
  }
  
  override init(image: UIImage, title: String, message: String) {
    super.init(image: image, title: title, message: message)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
