//
//  TEImageCacheManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/18/21.
//

import UIKit

final class TEImageCacheManager {
    
    static let shared = TEImageCacheManager()
    let cache = NSCache<NSString, UIImage>()
    
    func fetchAndCacheImage(from url: String) {
        let imageKey = url as NSString
        
        guard let _ = cache.object(forKey: imageKey) else {
            if let data = try? Data.init(contentsOf: URL(string: url)!) {
                if let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: imageKey)
                }
            }
            
            return
        }
    }
    
}
