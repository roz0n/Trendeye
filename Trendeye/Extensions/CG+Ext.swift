//
//  CG+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 6/14/21.
//

// Credit: https://www.raywenderlich.com/1163620-face-detection-tutorial-using-the-vision-framework-for-ios

import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
  return CGPoint(x: left.x * right, y: left.y * right)
}

extension CGSize {
  var cgPoint: CGPoint {
    return CGPoint(x: width, y: height)
  }
}

extension CGPoint {
  var cgSize: CGSize {
    return CGSize(width: x, height: y)
  }
  
  func absolutePoint(in rect: CGRect) -> CGPoint {
    return CGPoint(x: x * rect.size.width, y: y * rect.size.height) + rect.origin
  }
}
