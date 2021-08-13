//
//  TENetworkManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import Foundation
import UIKit

enum TENetworkError: String, Error {
  case urlSessionError = "URLSession request failed"
  case networkError = "Server returned a non-status 200 response"
  case dataError = "Malformed or nil data recieved from network response"
  case decoderError = "Failed to decode response data"
  case none = "Category network request handler unexpectedly returned nil"
}

enum TEFeedback {
  case positive
  case negative
}

final class TENetworkManager {
  
  // MARK: - Properties
  
  lazy var encoder = JSONEncoder()
  lazy var decoder = JSONDecoder()
  
  let trendListUrl = "https://www.trendlist.org/"

  var baseUrl: String {
    return Bundle.infoPlistValue(inFile: "Endpoints", forKey: "API_URL")!
  }
  
  // MARK: - Helpers
  
  func getEndpoint(_ resource: String, endpoint: String?, type: String? = "api") -> String {
    return "\(type == "api" ? baseUrl : trendListUrl)\(resource)/\(endpoint ?? "")"
  }
  
  // MARK: - GET Methods
  
  func fetchCategoryDescription(_ category: String, completion: @escaping (_ responseData: Result<CategoryDescriptionResponse, TENetworkError>?, _ cachedData: String?) -> Void) {
    guard let url = URL(string: getEndpoint("categories/desc", endpoint: category)) else { return }
    
    // MARK: - Category Description Cache Check
    
    let isCached = TECacheManager.shared.checkCache(in: TECacheManager.shared.descriptionCache as! NSCache<AnyObject, AnyObject>, for: url.absoluteString)
    
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
  
  func fetchCategoryImages(_ category: String, _ limit: Int, completion: @escaping (_ responseData: Result<CategoryImagesResponse, TENetworkError>) -> Void) {
    var urlComponents = URLComponents(string: getEndpoint("categories", endpoint: category))
    urlComponents?.queryItems = [URLQueryItem(name: "limit", value: String(limit))]
    
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
  
  // MARK: - POST Methods
  
  func postClassificationFeedback(data feedbackData: ClassificationFeedback, completion: @escaping (_ responseData: Result<ClassificationFeedbackResponse, TENetworkError>) -> Void) {
    // Configure URL
    guard let url = URL(string: "https://www.trendeye.app/feedback"), let payload = try? encoder.encode(feedbackData) else {
      return
    }
    
    // Configure Request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "content-type")
    request.httpBody = payload
    
    
    URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
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
        let decodedData = try self?.decoder.decode(ClassificationFeedbackResponse.self, from: data)
        completion(.success(decodedData!))
      } catch {
        completion(.failure(.decoderError))
      }
      
    }.resume()
  }
  
}
