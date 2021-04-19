//
//  CategoryImage.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import Foundation

//struct CategoryImages {
//
//}
//
//struct ProjectImage {
//    var title: String
//    var url: String
//    var images: ProjectImageSizes
//}
//
//struct ProjectImageSizes {
//    var small: String
//    var large: String
//}

struct CategoryDescriptionResponse: Codable {
    var success: Bool
    var data: CategoryDescription
}

struct CategoryDescription: Codable {
    var name: String
    var description: String?
}
