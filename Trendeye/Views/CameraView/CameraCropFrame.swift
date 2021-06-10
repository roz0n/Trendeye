//
//  CameraCropFrame.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 6/9/21.
//

import UIKit

class CameraCropFrame: UIView {
  
  // MARK: Frame Properties
  
  var squareFrame: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    view.layer.borderWidth = 4
    view.layer.cornerRadius = 8
    view.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
    return view
  }()
  
  var getActiveFramePosition: CGPoint? {
    get {
      guard let superview = squareFrame.superview else {
        return nil
      }
      
      return superview.convert(squareFrame.frame.origin, to: superview)
    }
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func centerRectToSuperview(_ superview: UIView) {
    squareFrame.center = CGPoint(x: superview.frame.midX, y: superview.frame.midY - (125 / 2))
  }
  
}

// MARK: - Layout

extension CameraCropFrame {
  
  func applyLayouts() {
    layoutFrame()
  }
  
  func layoutFrame() {
    addSubview(squareFrame)
  }
  
}
