//
//  TENetworkManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import Foundation

final class TENetworkManager {
    
    static let shared = TENetworkManager()
    
    let decoder = JSONDecoder()
    let baseUrl = "https://unofficial-trendlist.herokuapp.com/"
    let trendListUrl = "https://www.trendlist.org/"
    
    func getEndpoint(_ resource: String, endpoint: String?, type: String? = "api") -> String {
        return "\(type == "api" ? baseUrl : trendListUrl)\(resource)/\(endpoint ?? "")"
    }
    
    func fetchCategoryDescription(_ category: String, completion: @escaping (_ responseData: Result<CategoryDescriptionResponse, TENetworkError>?, _ cachedData: String?) -> Void) {
        guard let url = URL(string: getEndpoint("categories/desc", endpoint: category)) else { return }
        
        // MARK: - Category Description Cache Check
        
        let isCached = TECacheManager.shared.cacheCheck(in: TECacheManager.shared.descriptionCache as! NSCache<AnyObject, AnyObject>, for: url.absoluteString)
        
        guard !isCached else {
            let cachedData = TECacheManager.shared.descriptionCache.object(forKey: url.absoluteString as NSString)
            completion(nil, cachedData! as String)
            return
        }
        
        // MARK: - Category Description Network Request
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let _ = error {
                completion(.failure(.urlSessionError), nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.networkError), nil)
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError), nil)
                return
            }
            
            do {
                defer {
                    TECacheManager.shared.fetchAndCacheDescription(from: url.absoluteString)
                }
                
                let decodedData = try self?.decoder.decode(CategoryDescriptionResponse.self, from: data)
                completion(.success(decodedData!), nil)
            }
            catch {
                completion(.failure(.decoderError), nil)
            }
        }.resume()
    }
    
    func fetchCategoryImages(_ category: String, completion: @escaping (_ responseData: Result<CategoryImagesResponse, TENetworkError>) -> Void) {
        var urlComponents = URLComponents(string: getEndpoint("categories", endpoint: category))
        urlComponents?.queryItems = [URLQueryItem(name: "limit", value: "9")]
        
        guard let url = URL(string: (urlComponents?.url!.absoluteString)!) else { return }
        
        // MARK: - Category Image Network Request
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let _ = error {
                completion(.failure(.urlSessionError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let decodedData = try self?.decoder.decode(CategoryImagesResponse.self, from: data)
                completion(.success(decodedData!))
            }
            catch {
                completion(.failure(.decoderError))
            }
        }.resume()
    }
    
}
