//
//  StretchyTableHeaderView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/23/21.
//

import UIKit

class StretchyTableHeaderView: UIView {
  
  // MARK: - Properties
  
  var scrollView: UIScrollView?
  private var cachedMinimumSize: CGSize?
  
  // NOTE: This label is helpful when debugging issues with sizing and constraints (it displays the size of the view as it changes)
  var debugLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  fileprivate var minimumHeight: CGFloat {
    get {
      guard let scrollView = scrollView else { return 0 }
      
      if let cachedSize = cachedMinimumSize {
        if cachedSize.width == scrollView.frame.width {
          return cachedSize.height
        }
      }
      
      let minimumSize = systemLayoutSizeFitting(
        CGSize(width: scrollView.frame.width, height: 0),
        withHorizontalFittingPriority: .required,
        verticalFittingPriority: .defaultLow)
      
      cachedMinimumSize = minimumSize
      return minimumSize.height
    }
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // For debugging purposes
    // label.text = "\(frame.width)x\(frame.height)"
  }
  
  // MARK: - Helpers
  
  fileprivate func configureDebugLabel() {
    self.addSubview(debugLabel)
    self.debugLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.debugLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      self.debugLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
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
