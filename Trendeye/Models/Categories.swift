//
//  Categories.swift
//  Categories
//
//  Created by Arnaldo Rozon on 8/6/21.
//

import Foundation

struct CategoryDescriptionResponse: Codable {
  var success: Bool
  var data: CategoryDescription
}

struct CategoryDescription: Codable {
  var name: String
  var description: String?
}

struct CategoryImagesResponse: Codable {
  var success: Bool
  var data: [ProjectImage]
}
