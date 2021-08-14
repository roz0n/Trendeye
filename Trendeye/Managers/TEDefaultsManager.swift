//
//  TEDefaultsManager.swift
//  TEDefaultsManager
//
//  Created by Arnaldo Rozon on 8/14/21.
//

import Foundation

class TEDefaultsManager {
  
  // MARK: - Properties
  
  static let shared = TEDefaultsManager()
  lazy var store = UserDefaults.standard
  
  // MARK: - Helpers
  
  func set(key: String, value: Any?) -> Void {
    store.set(value, forKey: key)
  }
  
  func get<T>(key: String, as type: T) -> T? {
    switch type {
      case is String:
        return store.string(forKey: key) as? T
      default:
        return store.object(forKey: key) as? T
    }
  }
  
}
