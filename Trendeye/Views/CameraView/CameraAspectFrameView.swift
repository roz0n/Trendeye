//
//  CameraAspectFrameView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 6/9/21.
//

import UIKit

enum CameraAspectFrames {
  case square
  case rectangle
}

class CameraAspectFrameView: UIView {
  
  // MARK: - Content Area View Properties
  
  static let contentAreaPadding: CGFloat = 20
  
  var selectedContentAreaFrame: CameraAspectFrames? {
    didSet {
      guard let frame = selectedContentAreaFrame else { return }
      setContentAreaAspectFrame(to: frame)
    }
  }
  
  let squareAspectFrame: CGRect = CGRect(
    x: 0, y: 0,
    width: UIScreen.main.bounds.width - (contentAreaPadding * 2),
    height: UIScreen.main.bounds.width - (contentAreaPadding * 2))
  
  let rectangleAspectFrame: CGRect = CGRect(
    x: 0, y: 0,
    width: UIScreen.main.bounds.width - (contentAreaPadding * 2),
    height: UIScreen.main.bounds.height / 1.65 - (contentAreaPadding * 2))
  
  var contentAreaViewPosition: CGPoint? {
    get {
      guard let superview = contentAreaView.superview else { return nil }
      return superview.convert(contentAreaView.frame.origin, to: superview)
    }
  }
  
  var contentAreaView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    view.layer.borderWidth = 4
    view.layer.cornerRadius = 8
    view.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
    return view
  }()
  
  // MARK: - Initializers
  
  init(as frame: CameraAspectFrames) {
    super.init(frame: .zero)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.applyLayouts()
    self.setContentAreaAspectFrame(to: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func setContentAreaAspectFrame(to frame: CameraAspectFrames) {
    contentAreaView.frame = frame == .square ? squareAspectFrame : rectangleAspectFrame
    
    // TODO: Implement this
//    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
//      self.contentAreaView.frame = frame == .square ? self.rectangleAspectFrame : self.squareAspectFrame
//    }
  }
  
  func centerContentAreaAspectFrameToSuperview(_ superview: UIView) {
    contentAreaView.center = CGPoint(x: superview.frame.midX, y: superview.frame.midY - 50)
  }
  
}

// MARK: - Layout

fileprivate extension CameraAspectFrameView {
  
  func applyLayouts() {
    layoutFrame()
  }
  
  func layoutFrame() {
    addSubview(contentAreaView)
  }
  
}
