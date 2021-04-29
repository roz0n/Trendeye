//
//  CGSize+Ext.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/22/21.
//

import CoreGraphics

extension CGSize {
  
  func customRound(rule: FloatingPointRoundingRule = .down, toDecimals: Int = 2) -> CGSize {
    return CGSize(
      width: width.customRound(rule, toDecimals: toDecimals),
      height: height.customRound(rule, toDecimals: toDecimals)
    )
  }
  
}
