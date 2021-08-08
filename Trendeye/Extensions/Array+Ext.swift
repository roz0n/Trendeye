//
//  Array+Ext.swift
//  Array+Ext
//
//  Created by Arnaldo Rozon on 8/7/21.
//

import Vision

extension Array where Element == VNClassificationObservation  {
  
  func encodeToString() -> String? {
    let encodedResults = try? JSONEncoder().encode(self)
    
    guard let encodedResults = encodedResults else {
      return nil
    }
    
    return String(data: encodedResults, encoding: .utf8)
  }
  
}
