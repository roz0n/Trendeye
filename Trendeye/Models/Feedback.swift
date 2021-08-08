//
//  Feedback.swift
//  Feedback
//
//  Created by Arnaldo Rozon on 8/6/21.
//

import Foundation

struct ClassificationFeedback: Codable {
  var type: ClassificationFeedbackType.RawValue
  var image: String?
  var classificationResults: String
  var incorrectIdentifiers: [String]?
  var correctIdentifiers: [String]?
  var date: String
  var deviceInfo: String
}

struct ClassificationFeedbackResponse: Codable {
  var success: Bool
}

enum ClassificationFeedbackType: String, Codable {
  case positive = "positive"
  case negative = "negative"
}
