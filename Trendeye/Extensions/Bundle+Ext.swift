//
//  Bundle+Ext.swift
//  Bundle+Ext
//
//  Created by Arnaldo Rozon on 8/13/21.
//

import Foundation

extension Bundle {
  
  static func infoPlistValue(file: String, key: String) -> String? {
    // TODO: It would be nice if this was generic
    guard let path = Bundle.main.path(forResource: file, ofType: ".plist") else { return nil }
    guard let keys = NSDictionary.init(contentsOfFile: path) else { return nil }
    
    return keys[key] as? String
  }
  
}
