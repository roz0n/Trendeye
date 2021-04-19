//
//  TECacheManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/18/21.
//

import UIKit

final class TECacheManager {
    
    static let shared = TECacheManager()
    
    let imageCache = NSCache<NSString, UIImage>()
    let textCache = NSCache<NSString, NSString>()
    
    func fetchAndCacheImage(from url: String) {
        let imageKey = url as NSString
        
        guard let _ = imageCache.object(forKey: imageKey) else {
            if let data = try? Data.init(contentsOf: URL(string: url)!) {
                if let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: imageKey)
                }
            }
            return
        }
    }
    
    func fetchAndCacheText(from url: String) {
        let textKey = url as NSString
        
        guard let _ = textCache.object(forKey: textKey) else {
            if let data = try? Data.init(contentsOf: URL(string: url)!) {
                // TODO: Use JSON decoder on this text
                if let text = NSString(data: data, encoding: 4) {
                    self.textCache.setObject(text, forKey: textKey)
                }
            }
            return
        }
    }
    
}
