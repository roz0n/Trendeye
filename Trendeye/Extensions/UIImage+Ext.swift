//
//  UIImage+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/24/21.
//

import UIKit

extension UIImage {
  
  func scaleToPercent(_ percent: CGFloat) -> UIImage {
    let newWidth: CGFloat = self.size.width * (percent / 100)
    let newHeight: CGFloat = self.size.height * (percent / 100)
    
    let newSize = CGSize(width: newWidth, height: newHeight)
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    let scaledImage = renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
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
  
  func scaleMaintainingAspectRatio(_ targetSize: CGSize) -> UIImage {
    // Compute the scaling ratio for the width and height separately
    let widthScaleRatio = targetSize.width / self.size.width
    let heightScaleRatio = targetSize.height / self.size.height
    
    // To keep the aspect ratio, scale by the smaller scaling ratio
    let scaleFactor = min(widthScaleRatio, heightScaleRatio)
    
    /*
     Multiply the original image’s dimensions by the scale factor
     to determine the scaled image size that preserves aspect ratio
     */
    let scaledImageSize = CGSize(
      width: self.size.width * scaleFactor,
      height: self.size.height * scaleFactor
    )
    
    let scaledImage = UIGraphicsImageRenderer(size: scaledImageSize).image { _ in
      self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
    }
    
    return scaledImage
  }
  
  func cropToFrame(_ rect: CGRect, scale: CGFloat = 1.0) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: (rect.size.height/scale), height: (rect.size.width/scale)), true, scale)
    
    self.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
    let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    return croppedImage ?? nil
  }
  
  func scaleAndEncode() -> String? {
    let image = self.scaleMaintainingAspectRatio(CGSize(width: 150, height: 150))
    let data = image.jpegData(compressionQuality: 0.5)
    
    return data?.base64EncodedString()
  }
  
}
