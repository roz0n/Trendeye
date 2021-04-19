//
//  TEAPIModels.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import Foundation

class GenericAPIResponse: Codable {
    var success: Bool
    var limit: Int?
    var data: CategoryDescription
}

// TODO: GenericAPIResponse needs to be a class
struct GenericAPIResponse2: Codable {
    var success: Bool
    var data: [ProjectImage]
}

// MARK: - Categories

//class CategoryDescriptionResponse: GenericAPIResponse {
//    var data: CategoryDescription?
//}

struct CategoryDescription: Codable {
    var name: String
    var description: String?
}

// MARK: - Images

struct ProjectImage: Codable {
    var title: String
    var url: String
    var images: ProjectImageSizes
}

struct ProjectImageSizes: Codable {
    var small: String
    var large: String
}
