//
//  UIDevice+Ext.swift
//  UIDevice+Ext
//
//  Created by Arnaldo Rozon on 8/7/21.
//

import UIKit

extension UIDevice {
  
  func getDeviceInfo() -> String {
    return "\(self.model)$\(self.systemName)$\(self.systemVersion)"
  }
  
}
