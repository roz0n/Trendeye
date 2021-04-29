//
//  StretchyTableHeaderView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/23/21.
//

import UIKit

class StretchyTableHeaderView: UIView {
  
  var scrollView: UIScrollView?
  private var cachedMinimumSize: CGSize?
  
  // For debugging purposes
  var label: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // For debugging purposes
    // label.text = "\(frame.width)x\(frame.height)"
  }
  
  fileprivate func configureDebugLabel() {
    self.addSubview(label)
    self.label.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.label.centerYAnchor.constraint(equalTo: centerYAnchor),
      self.label.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
  
  fileprivate var minimumHeight: CGFloat {
    get {
      guard let scrollView = scrollView else { return 0 }
      
      if let cachedSize = cachedMinimumSize {
        if cachedSize.width == scrollView.frame.width {
          return cachedSize.height
        }
      }
      
      let minimumSize = systemLayoutSizeFitting(
        CGSize(width: scrollView.frame.width,
               height: 0),
        withHorizontalFittingPriority: .required,
        verticalFittingPriority: .defaultLow)
      cachedMinimumSize = minimumSize
      return minimumSize.height
    }
  }
  
  public func updatePosition() {
    guard let scrollView = scrollView else { return }
    
    let minimumSize = minimumHeight
    let refOffset = scrollView.safeAreaInsets.top
    let refHeight = scrollView.contentInset.top - refOffset
    
    let offset = refHeight + scrollView.contentOffset.y
    let targetHeight = refHeight - offset - refOffset
    var targetOffset = refOffset
    
    if targetHeight < minimumSize {
      targetOffset += targetHeight - minimumSize
    }
    
    var headerFame = frame
    headerFame.size.height = max(minimumSize, targetHeight)
    headerFame.origin.y = targetOffset
    frame = headerFame
  }
  
}
