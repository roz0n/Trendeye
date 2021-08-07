//
//  Feedback.swift
//  Feedback
//
//  Created by Arnaldo Rozon on 8/6/21.
//

import Foundation

struct ClassificationFeedback: Codable {
  var type: String
  var image: String
  var classificationResult: String
  var classificationIdentifiers: [String]
  var correctIdentifiers: [String]?
  var date: String
  var deviceId: String
}

struct ClassificationFeedbackResponse: Codable {
  var success: Bool
}
