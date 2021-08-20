//
//  Strings.swift
//  Strings
//
//  Created by Arnaldo Rozon on 8/14/21.
//

import Foundation

struct CameraViewStrings {
  static let welcomeModalTitle = "Hello there!"
  static let welcomeModalBody = "Trendeye is an image analysis tool that uses machine learning to identify experiemental graphic design trends that might be present in a given image. It's currently in beta so it may provide unexpected results at times. \n \n For any feedback, questions, or concerns, please email arnold@rozon.org!"
  static let welcomeButton = "Get Started"
  static let conformationViewTitle = "Confirm Photo"
  static let classificationViewTitle = "Trend Analysis"
}

struct ConfirmationViewStrings {
  static let navigationTitle = "Confirm Photo"
}

struct ClassificationViewStrings {
  static let aboutModalTitle = "About Analysis"
  static let aboutModalBody = "An image classifier is a machine learning model that analyses images. The Trendeye image classifier is trained by over 15,000 images published to TrendList.org. \n \nUpon analysis, it recognizes (to a degree of confidence) trends that may be present in the given image. To learn more about a trend, tap its cell to view more examples of it. To learn more about the model's confidence metric, tap the confidence label above the image. \n \nTo provide feedback on the results of the classification, tap the thumb up/down icons and follow the on-screen instructions to help improve the model's accuracy."
  static let aboutModalButton = "Close"
  static let confidenceModalTitle = "Confidence"
  static let confidenceBodyTitle = "The model's confidence metric is determined by calculating the combined average of the \"confidence\" scores ouput during the classification proccess."
  static let confidenceModalButton = "Close"
  static let highConfidenceHeader = "High Confidence"
  static let highConfidenceBody = "The model is very confident in its analysis that most, if not all, of the trends listed are present in the image."
  static let mildConfidenceHeader = "Mild Confidence"
  static let mildConfidenceBody = "The model is only somewhat confident of its analysis. Some of the trends listed may not actually be present in the image."
  static let lowConfidenceHeader = "Low Confidence"
  static let lowConfidenceBody = "The model had difficulty analysing the image and is not confident in its analysis. There is no guarantee the trends listed are relevant to the image."
  static let classificationErrorTitle = "Classification Error"
  static let classificationErrorMessage = "Failed to classify image. Please try another or try again later."
  static let classificationErrorButton = "Close"
}

struct CategoryViewStrings {
  static let trendlistButton = "View on Trend List"
  static let errorViewTitle = "Unable to Load Trend Images"
  static let errorViewBody = "Looks like we’re having some trouble connecting to our servers. Try again later."
}

struct FeedbackViewStrings {
  static let positiveFeedbackTitle = "Valid Analysis"
  static let negativeFeedbackTitle = "Invalid Analysis"
  static let validIdentifiersTitle = "Select Valid Trends"
  static let feedbackSubmissionTitle = "Confirm Feedback"
}

struct NegativeFeedbackStrings {
  static let tableHeader = "Please select the invalid trends present in the image analysis. Your selections will be used to train the model's accuracy."
  static let nextButton = "Next"
  static let searchBarPlaceholder = "Search"
}

struct NegativeFeedbackSubmissionStrings {
  static let invalidSectionTitle = "Invalid Trends"
  static let validSectionTitle = "Valid Trends"
  static let submitButton = "Submit"
  static let successAlertTitle = "Feedback Submitted"
  static let successAlertBody = "Thank you for helping train Trendeye!"
  static let errorAlertTitle = "Oops"
  static let errorAlertBody = "Something went wrong, please try again later."
  static let submissionAlertButton = "Close"
}

struct PositiveFeedbackSubmissionStrings {
  static let submitButton = "Submit"
  static let tableHeader = "Please confirm that the trends below are valid representations of the image. Your selections will be used to train the model's accuracy."
  static let successAlertTitle = "Feedback Submitted"
  static let successAlertBody = "Thank you for helping train Trendeye!"
  static let errorAlertTitle = "Oops!"
  static let errorAlertBody = "Something went wrong, please try again later."
  static let alertButton = "Close"
}

struct FullscreenImageStrings {
  static let errorAlertTitle = "Error"
  static let errorAlertBody = "You must allow gallery access in Settings to save images to your camera roll."
  static let errorAlertButton = "Close"
  static let saveAlertTitle = "Saved!"
  static let saveAlertBody = "The image has been saved to your camera roll."
  static let saveAlertButton = "Close"
}

struct ClassificationTableHeaderStrings {
  static let primaryButton = "About analysis"
}

struct ClassificationConfidenceButtonStrings {
  static let confidenceLabel = "confidence"
}

struct ClassificationTableFooterStrings {
  static let attribution = "Trained with images from TrendList.org"
}
