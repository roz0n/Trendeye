//
//  CameraDetectionView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 6/14/21.
//

import UIKit

class CameraDetectionView: UIView {
  var boundingBox = CGRect.zero
  
  func clear() {
    boundingBox = .zero
    
    DispatchQueue.main.async {
      self.setNeedsDisplay()
    }
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    
    context.saveGState()
    
    defer {
      context.restoreGState()
    }
    
    context.addRect(boundingBox)
    
    UIColor.red.setStroke()
    
    context.strokePath()
  }
  
}
