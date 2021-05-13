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
  
}
