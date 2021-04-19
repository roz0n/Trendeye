//
//  TEDataManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import Foundation

final class TEDataManager {
    
    static let shared = TEDataManager()
    
    let decoder = JSONDecoder()
    let baseUrl = "https://unofficial-trendlist.herokuapp.com/"
    let trendListUrl = "https://www.trendlist.org/"
    
    func getEndpoint(_ resource: String, endpoint: String?, type: String? = "api") -> String {
        return "\(type == "api" ? baseUrl : trendListUrl)\(resource)/\(endpoint ?? "")"
    }
    
    func fetchCategoryDescription(_ category: String, completion: @escaping (_ data: CategoryDescriptionResponse?, _ cachedData: String?) -> Void) {
        guard let url = URL(string: getEndpoint("categories/desc", endpoint: category)) else { return }
        
        // Check cache for stored description data
        let isCached = TECacheManager.shared.checkIfCached(in: TECacheManager.shared.descriptionCache as! NSCache<AnyObject, AnyObject>, for: url.absoluteString)

        guard !isCached else {
            // Call completion with the cached data
            let cachedData = TECacheManager.shared.descriptionCache.object(forKey: url.absoluteString as NSString)
            print("The category description is already cached:", cachedData)
            completion(nil, cachedData! as String)
            return
        }
        
        // Perform network request if data is not cached
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                do {
                    defer {
                        // Once the network request completes successfully, cache the response data after we call the completion handler
                        TECacheManager.shared.fetchAndCacheDescription(from: url.absoluteString)
                    }
                    let response = try self?.decoder.decode(CategoryDescriptionResponse.self, from: data)
                    completion(response!, nil)
                }
                catch {
                    print("Error decoding category description", error)
                }
            } else {
                print("Error fetching category description")
            }
        }.resume()
    }
    
    func fetchCategoryImages(_ category: String, completion: @escaping (_ data: CategoryImagesResponse) -> ()) {
        var urlComponents = URLComponents(string: getEndpoint("categories", endpoint: category))
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: "9")
        ]
        
        if let url = URL(string: (urlComponents?.url!.absoluteString)!) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let data = data {
                    do {
                        let response = try self?.decoder.decode(CategoryImagesResponse.self, from: data)
                        completion(response!)
                    } catch {
                        print("Error decoding category images", error)
                    }
                } else {
                    print("Error fetching category images")
                }
            }.resume()
        }
    }
    
}
