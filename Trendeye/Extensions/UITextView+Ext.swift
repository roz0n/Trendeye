//
//  UITextView+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/30/21.
//

import UIKit

extension UITextView {
  
  func removeAllInsets() {
    self.textContainer.lineFragmentPadding = CGFloat(0.0)
    self.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    self.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
  }
  
}
