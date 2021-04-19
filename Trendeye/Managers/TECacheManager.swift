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
    let descriptionCache = NSCache<NSString, NSString>()
    let decoder = JSONDecoder()
    
    func fetchAndCacheImage(from url: String) {
        let imageKey = url as NSString
        
        // Check if image is already cached before attempting to cache it
        guard imageCache.object(forKey: imageKey) == nil else { return }
        
        if let data = try? Data.init(contentsOf: URL(string: url)!) {
            // Cache new image
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: imageKey)
            }
        }
    }
    
    func fetchAndCacheDescription(from url: String) {
        let descriptionKey = url as NSString
        var descriptionString: String?
        
        // Check if description is already cached before attempting to cache it
        guard descriptionCache.object(forKey: descriptionKey) == nil else { return }
        
        if let data = try? Data.init(contentsOf: URL(string: url)!) {
            do {
                let parsedData = try decoder.decode(GenericAPIResponse.self, from: data)
                descriptionString = parsedData.data.description
            } catch let error {
                print("Error decoding description text to cache:", error)
            }
            
            // Descriptions are optional, as in the API itself might return nil, so check it before caching it
            guard let stringToCache = descriptionString else { return }
            descriptionCache.setObject(NSString(string: stringToCache), forKey: descriptionKey)
        }
    }
    
}
