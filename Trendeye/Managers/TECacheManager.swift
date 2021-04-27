//
//  TECacheManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/18/21.
//

import UIKit

final class TECacheManager {
    
    static let shared = TECacheManager(withSize: 75000000)
    
    lazy var imageCache = NSCache<NSString, UIImage>()
    lazy var descriptionCache = NSCache<NSString, NSString>()
    lazy var decoder = JSONDecoder()
    
    init(withSize size: Int) {
        imageCache.totalCostLimit = size
        descriptionCache.totalCostLimit = size
    }
    
    func checkCache(in cache: NSCache<AnyObject, AnyObject>, for key: String) -> Bool {
        return cache.object(forKey: key as NSString) == nil ? false : true
    }
    
    func fetchAndCacheImage(from url: String) {
        let imageKey = url as NSString
        
        guard !checkCache(in: imageCache as! NSCache<AnyObject, AnyObject>, for: imageKey as String) else { return }
        
        if let data = try? Data.init(contentsOf: URL(string: url)!) {
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: imageKey)
            }
        }
    }
    
    func fetchAndCacheDescription(from url: String) {
        let descriptionKey = url as NSString
        var descriptionString: String?
        
        guard !checkCache(in: descriptionCache as! NSCache<AnyObject, AnyObject>, for: descriptionKey as String) else { return }
        
        if let data = try? Data.init(contentsOf: URL(string: url)!) {
            do {
                let parsedData = try decoder.decode(CategoryDescriptionResponse.self, from: data)
                descriptionString = parsedData.data.description
            } catch let error {
                print("Error decoding description text to cache:", error)
            }
            
            // Descriptions are optional, because the API itself might return nil, so check it before caching it
            guard let stringToCache = descriptionString else { return }
            descriptionCache.setObject(NSString(string: stringToCache), forKey: descriptionKey)
        }
    }
    
}
