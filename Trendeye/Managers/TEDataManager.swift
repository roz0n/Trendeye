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
    
    func fetchCategoryDescription(_ category: String, completion: @escaping (_ data: GenericAPIResponse) -> Void) {
        guard let url = URL(string: getEndpoint("categories/desc", endpoint: category)) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                do {
                    let response = try self?.decoder.decode(GenericAPIResponse.self, from: data)
                    completion(response!)
                }
                catch {
                    print("Error decoding category description", error)
                }
            } else {
                print("Error fetching category description")
            }
        }.resume()
    }
    
    func fetchCategoryImages(_ category: String, completion: @escaping (_ data: GenericAPIResponse2) -> ()) {
        var urlComponents = URLComponents(string: getEndpoint("categories", endpoint: category))
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: "9")
        ]
        
        if let url = URL(string: (urlComponents?.url!.absoluteString)!) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let data = data {
                    do {
                        let response = try self?.decoder.decode(GenericAPIResponse2.self, from: data)
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
