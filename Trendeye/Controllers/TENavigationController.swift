//
//  TENavigationController.swift
//  TENavigationController
//
//  Created by Arnaldo Rozon on 7/24/21.
//

import UIKit

class TENavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    if let topViewController = viewControllers.last {
      return topViewController.preferredStatusBarStyle
    }
    
    return .default
  }
  
}
