//
//  CGFloat+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/22/21.
//

import CoreGraphics

extension CGFloat {
  
  func customRound(_ rule: FloatingPointRoundingRule = .down, toDecimals decimals: Int = 2) -> CGFloat {
    let multiplier = CGFloat(pow(10.0, CGFloat(decimals)))
    return (self * multiplier).rounded(.down) / multiplier
  }
  
}
