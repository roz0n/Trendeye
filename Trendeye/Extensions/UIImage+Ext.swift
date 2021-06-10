//
//  UIImage+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/24/21.
//

import UIKit

extension UIImage {
  
  func scaleByPercentage(_ percent: CGFloat) -> UIImage {
    let newWidth: CGFloat = self.size.width * (percent / 100)
    let newHeight: CGFloat = self.size.height * (percent / 100)
    
    let newSize = CGSize(width: newWidth, height: newHeight)
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    let scaledImage = renderer.image { [weak self] _ in
      self?.draw(in: CGRect(origin: .zero, size: newSize))
    }
    
    return scaledImage
  }
  
  func scaleToScreenSize() -> UIImage {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let newSize = CGSize(width: screenWidth, height: screenHeight)
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    let scaledImage = renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
    
    return scaledImage
  }
  
  func cropInRect(_ rect: CGRect, scale: CGFloat = 1.0) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: (rect.size.height/scale), height: (rect.size.width/scale)), true, scale)
    
    self.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
    let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    return croppedImage ?? nil
  }
  
}
