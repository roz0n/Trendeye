//
//  Projects.swift
//  Projects
//
//  Created by Arnaldo Rozon on 8/6/21.
//

import Foundation

struct ProjectImage: Codable {
  var title: String
  var url: String
  var images: ProjectImageSizes
}

struct ProjectImageSizes: Codable {
  var small: String
  var large: String
}
