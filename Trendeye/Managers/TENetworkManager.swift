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
    
//    func fetchCategoryDescription(_ category: String, completion: @escaping (Result<CategoryDescriptionResponse, TENetworkError>) -> Void) {
//        guard let url = URL(string: getEndpoint("categories/desc", endpoint: category)) else { return }
//
//        // MARK: - Category Description Cache Check
//
//        let isCached = TECacheManager.shared.cacheCheck(in: TECacheManager.shared.descriptionCache as! NSCache<AnyObject, AnyObject>, for: url.absoluteString)
//
//        guard !isCached else {
//            let cachedData = TECacheManager.shared.descriptionCache.object(forKey: url.absoluteString as NSString)
//            completion(nil, cachedData! as String)
//            return
//        }
//
//        // MARK: - Category Description Network Request
//
//        // TODO: Use Result type
//        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
//            if let data = data {
//                do {
//                    defer {
//                        if error == nil {
//                            TECacheManager.shared.fetchAndCacheDescription(from: url.absoluteString)
//                        }
//                    }
//
//                    let response = try self?.decoder.decode(CategoryDescriptionResponse.self, from: data)
//                    completion(response!, nil)
//                }
//                catch {
//                    print("Error decoding category description", error)
//                }
//            } else {
//                print("Error fetching category description")
//            }
//        }.resume()
//    }
    
    
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
