//
//  Feedback.swift
//  Feedback
//
//  Created by Arnaldo Rozon on 8/6/21.
//

import Foundation

struct ClassificationFeedback: Codable {
  var type: ClassificationFeedbackTypes
  var image: String
  var classificationResult: String
  var incorrectIdentifiers: [String]
  var correctIdentifiers: [String]?
  var date: String
  var deviceId: String
}

struct ClassificationFeedbackResponse: Codable {
  var success: Bool
}

enum ClassificationFeedbackTypes: String, Codable {
  case positive = "positive"
  case negative = "negative"
}
