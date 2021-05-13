//
//  TrendlistAPIModels.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import Foundation

// MARK: - Categories

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

// MARK: - Project Images

struct ProjectImage: Codable {
  var title: String
  var url: String
  var images: ProjectImageSizes
}

struct ProjectImageSizes: Codable {
  var small: String
  var large: String
}
