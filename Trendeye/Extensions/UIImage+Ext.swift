//
//  UIImage+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/24/21.
//

import UIKit

extension UIImage {
  
  func scaleByAspect(to size: CGSize) -> UIImage {
    let widthRatio = (size.width / size.width)
    let heightRatio = (size.height / size.height)
    let scaleFactor = min(widthRatio, heightRatio)
    
    let scaledImageSize = CGSize(
      width: (size.width * scaleFactor),
      height: (size.height * scaleFactor))
    
    let renderer = UIGraphicsImageRenderer(
      size: scaledImageSize)
    
    let scaledImage = renderer.image { _ in
      self.draw(in: CGRect(
                  origin: .zero,
                  size: scaledImageSize))
    }
    
    return scaledImage
  }
  
}
