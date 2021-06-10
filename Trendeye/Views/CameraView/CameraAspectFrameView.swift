//
//  CameraAspectFrameView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 6/9/21.
//

import UIKit

enum ContentAreaAspects {
  case square
  case rectangle
}

class CameraAspectFrameView: UIView {
  
  // MARK: Content Area Properties
  
  // MARK: -
  
  static let contentAreaPadding: CGFloat = 20
  
  var selectedContentAreaAspect: ContentAreaAspects? {
    didSet {
      print("Changed aspect frame!")
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
  
  init(as type: ContentAreaAspects) {
    super.init(frame: .zero)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.applyLayouts()
    
    switch type {
      case .square:
        selectedContentAreaAspect = .square
        contentAreaView.frame = squareAspectFrame
      case .rectangle:
        selectedContentAreaAspect = .rectangle
        contentAreaView.frame = rectangleAspectFrame
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func centerRectToSuperview(_ superview: UIView) {
    contentAreaView.center = CGPoint(x: superview.frame.midX, y: superview.frame.midY - 50)
  }
  
}

// MARK: - Layout

extension CameraAspectFrameView {
  
  func applyLayouts() {
    layoutFrame()
  }
  
  func layoutFrame() {
    addSubview(contentAreaView)
  }
  
}
