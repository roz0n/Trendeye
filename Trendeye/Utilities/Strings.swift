//
//  Strings.swift
//  Strings
//
//  Created by Arnaldo Rozon on 8/14/21.
//

import Foundation

struct CameraViewStrings {
  static let welcomeModalTitle = "Hello there!"
  static let welcomeModalBody = "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. Nullam non ante nisi. Quisque ante quam, ornare nec est sed, facilisis fermentum sapien. Aliquam non dui at mi tincidunt dignissim."
  static let welcomeButton = "Get Started"
  static let conformationViewTitle = "Confirm Photo"
  static let classificationViewTitle = "Trend Analysis"
}

struct ConfirmationViewStrings {
  static let navigationTitle = "Confirm Photo"
}

struct ClassificationViewStrings {
  static let aboutModalTitle = "About Analysis"
  static let aboutModalBody = "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. Nullam non ante nisi. Quisque ante quam, ornare nec est sed, facilisis fermentum sapien. Aliquam non dui at mi tincidunt dignissim."
  static let aboutModalButton = "Close"
  static let confidenceModalTitle = "Confidence"
  static let confidenceBodyTitle = "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. Nullam non ante nisi."
  static let confidenceModalButton = "Close"
  static let highConfidenceHeader = "High Confidence"
  static let highConfidenceBody = "Etiam sit amet urna a dolor iaculis hendrerit at id sapien."
  static let mildConfidenceHeader = "Mild Confidence"
  static let mildConfidenceBody = "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. "
  static let lowConfidenceHeader = "Low Confidence"
  static let lowConfidenceBody = "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. "
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
  static let tableHeader = "Please select the invalidly classified trends from your image analysis. Your selections will be used to better inform future analysis."
  static let nextButton = "Next"
  static let searchBarPlaceholder = "Search"
}

struct NegativeFeedbackSubmissionStrings {
  static let invalidSectionTitle = "Invalid Trends"
  static let validSectionTitle = "Valid Trends"
  static let submitButton = "Submit"
  static let successAlertTitle = "Feedback Submitted"
  static let successAlertBody = "Thank you for helping improve image analysis."
  static let errorAlertTitle = "Oops"
  static let errorAlertBody = "Something went wrong, please try again later."
  static let submissionAlertButton = "Close"
}

struct PositiveFeedbackSubmissionStrings {
  static let submitButton = "Submit"
  static let tableHeader = "Duis efficitur metus feugiat, ultrices nibh ac, imperdiet mauris. Aliquam eu justo vehicula, tristique enim ut, dignissim diam."
  static let successAlertTitle = "Feedback Submitted"
  static let successAlertBody = "Thank you for helping improve image analysis."
  static let errorAlertTitle = "Oops"
  static let errorAlertBody = "Something went wrong, please try again later."
  static let alertButton = "Close"
}

struct FullscreenImageStrings {
  static let errorAlertTitle = "Error"
  static let errorAlertBody = "You must allow gallery access in Settings to save images."
  static let errorAlertButton = "Close"
  static let saveAlertTitle = "Saved Image"
  static let saveAlertBody = "The image has been saved to your camera roll."
  static let saveAlertButton = "Close"
}

struct ClassificationTableHeaderStrings {
  static let primaryButton = "About analysis"
}
