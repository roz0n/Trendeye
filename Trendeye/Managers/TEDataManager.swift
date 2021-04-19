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
    
    func getEndpoint(_ resource: String, endpoint: String?) -> String {
        return "\(baseUrl)\(resource)/\(endpoint ?? "")"
    }
    
    func fetchCategoryDescription(_ category: String, completion: @escaping (_ data: CategoryDescriptionResponse) -> Void) {
        // Fetch the category description
        guard let url = URL(string: getEndpoint("categories/desc", endpoint: category)) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            // TODO: Gracefully handle errors using Result type
            if let data = data {
                do {
                    let response = try self?.decoder.decode(CategoryDescriptionResponse.self, from: data)
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
    
    func fetchCategoryImages(_ category: String, completion: @escaping (_ data: Any) -> ()) {
        // Fetch category images with a limit of 9
    }
    
}
