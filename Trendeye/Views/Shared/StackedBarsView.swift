//
//  StackedBarsController.swift
//  StackedBarsController
//
//  Created by Arnaldo Rozon on 7/31/21.
//

import UIKit

struct BarDimensions {
  var height: CGFloat
  var width: CGFloat
}

class BarView: UIView {
  
  // MARK: - Properties
  
  var height: CGFloat
  var width: CGFloat
  var color: UIColor
  
  // MARK: - Initializers
  
  init(height: CGFloat, width: CGFloat, color: UIColor) {
    self.height = height
    self.width = width
    self.color = color
    
    super.init(frame: CGRect(x: 0, y: -height, width: width, height: height))
    
    autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
    layer.borderColor = color.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 2
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    layer.masksToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// TODO: This does not need to be a UIViewController, a regular UIView would suffice

class StackedBarsView: UIViewController {
  
  // MARK: - Properties
  
  static let contentWidth: CGFloat = 60
  
  var percentage: Int
  var color: UIColor
  
  // MARK: - Views
  
  var barContainer: UIStackView = {
    let view = UIStackView.init(frame: CGRect(x: 0, y: 0, width: StackedBarsView.contentWidth, height: 20))
    view.distribution = .fillEqually
    view.axis = .horizontal
    view.spacing = 5
    return view
  }()
  
  // MARK: - Initializers
  
  init(percentage: Int, color: UIColor) {
    self.percentage = percentage
    self.color = color
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    view.addSubview(barContainer)
    configureBars()
  }
  
  // MARK: - Configurations
  
  func configureBars() {
    for bar in createBars(color: color) {
      let containerShape = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
      
      containerShape.addSubview(bar)
      containerShape.layer.masksToBounds = true
      barContainer.addArrangedSubview(containerShape)
    }
  }
  
  // MARK: - Helpers
  
  func createBars(color: UIColor) -> [UIView] {
    var barViews: [UIView] = []
    
    // Currently, only five bars are supported. This component could easily be extended to support more.
    let barSizes: [BarDimensions] = [
      BarDimensions(height: 4, width: 10),
      BarDimensions(height: 8, width: 10),
      BarDimensions(height: 12, width: 10),
      BarDimensions(height: 16, width: 10),
      BarDimensions(height: 20, width: 10)
    ]
    
    for (index, bar) in barSizes.enumerated() {
      let bar = createBar(height: bar.height, width: bar.width, color: color)
      let shouldFill = shouldBarFill(at: index, to: percentage, within: barSizes.count)
      
      if shouldFill {
        bar.backgroundColor = color
      } else {
        // TODO: For some reason, alpha transparency in table view cells is inconsistent
        // bar.layer.borderColor = K.Colors.Icon.withAlphaComponent(0.25).cgColor
        bar.layer.borderColor = K.Colors.Gray.cgColor
        bar.backgroundColor = UIColor.clear
      }
      
      barViews.append(bar)
    }
    
    return barViews
  }
  
  func createBar(height: CGFloat, width: CGFloat, color: UIColor) -> UIView {
    return BarView(height: height, width: width, color: color)
  }
  
  func shouldBarFill(at index: Int, to percentage: Int, within total: Int) -> Bool {
    let incrementValue = (100 / total)
    let minRangeValue = (index) * incrementValue
    let maxRangeValue = (index + 1) * incrementValue
    let fullRange = minRangeValue..<maxRangeValue
    
    if percentage == 0 {
      return false
    }
    
    return maxRangeValue <= percentage || fullRange ~= percentage
  }
  
}
