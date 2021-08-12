//
//  UINavigationController+Ext.swift
//  UINavigationController+Ext
//
//  Created by Arnaldo Rozon on 8/11/21.
//

import UIKit

extension UINavigationController {
 
  func getRootViewController() -> UIViewController? {
    return self.viewControllers.first
  }
  
}
