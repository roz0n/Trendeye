//
//  FeedbackViewController.swift
//  FeedbackViewController
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit
import Vision

enum FeedbackTable: String {
  case validIdentifiers
  case invalidIdentifiers
}

class FeedbackViewController: UINavigationController {
  
  // MARK: - Properties
  
  let networkManager = TENetworkManager()
  var feedbackType: ClassificationFeedbackType
  var classificationImage: UIImage
  var classificationResults: [VNClassificationObservation]
  var classificationIdentifiers: [String]?
  var invalidIdentifiers = [String: Bool]()
  var validIdentifiers =  [String: Bool]()
  
  var allIdentifiers: [String] {
    return Array(TEClassificationManager.shared.indentifiers.values)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureController()
  }
  
  // MARK: - Initializers
  
  convenience init(type feedbackType: ClassificationFeedbackType, for classificationResults: [VNClassificationObservation], classificationIdentifiers: [String]?, classificationImage: UIImage) {
    switch feedbackType {
      case .positive:
        let positiveFeedbackController = PositiveFeedbackSubmissionController(identifiers: classificationIdentifiers)
        positiveFeedbackController.navigationItem.title = "Feedback Report"
        positiveFeedbackController.navigationItem.backButtonTitle = ""
        
        self.init(rootViewController: positiveFeedbackController, type: feedbackType, classificationResults: classificationResults, classificationIdentifiers: classificationIdentifiers, classificationImage: classificationImage)
      case .negative:
        let negativeFeedbackController = NegativeFeedbackSelectionController(type: .invalidIdentifiers, identifiers: nil)
        negativeFeedbackController.classificationIdentifiers = classificationIdentifiers
        negativeFeedbackController.navigationItem.title = "Feedback Report"
        negativeFeedbackController.navigationItem.backButtonTitle = ""
        
        self.init(rootViewController: negativeFeedbackController, type: feedbackType, classificationResults: classificationResults, classificationIdentifiers: classificationIdentifiers, classificationImage: classificationImage)
    }
  }
  
  init(rootViewController: UIViewController, type feedbackType: ClassificationFeedbackType, classificationResults: [VNClassificationObservation], classificationIdentifiers: [String]?, classificationImage: UIImage) {
    self.feedbackType = feedbackType
    self.classificationResults = classificationResults
    self.classificationIdentifiers = classificationIdentifiers
    self.classificationImage = classificationImage
    
    super.init(rootViewController: rootViewController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  fileprivate func configureController() {
    view.backgroundColor = .clear
    navigationBar.backgroundColor = K.Colors.ViewBackground
  }
  
  // MARK: - Helpers
  
  fileprivate func getFilteredIdentifiers(classified classifiedIdentifiers: [String], all allIdentifiers: [String]) -> [String] {
    return allIdentifiers.filter { !classifiedIdentifiers.contains($0) }
  }
  
  func presentValidClassificationTableView() {
    guard let classificationIdentifiers = classificationIdentifiers else {
      return
    }
    
    // The full list of identifiers needs to be filtered in order to remove the values that were present in the classification being reported
    let filteredIdentifiers = getFilteredIdentifiers(classified: classificationIdentifiers, all: allIdentifiers)
    let validIdentifiersTable = NegativeFeedbackSelectionController(type: .validIdentifiers, identifiers: filteredIdentifiers)
    
    validIdentifiersTable.selectedIdentifiers = validIdentifiers
    validIdentifiersTable.navigationItem.title = "Select Valid Trends"
    validIdentifiersTable.navigationItem.backButtonTitle = ""
    
    pushViewController(validIdentifiersTable, animated: true)
  }
  
  func presentFeedbackSubmissionTable(type feedbackType: ClassificationFeedbackType) {
    let invalidIdentifiers = Array(invalidIdentifiers.keys)
    let validIdentifiers = Array(validIdentifiers.keys)
    
    let feedbackSubmissionTable = NegativeFeedbackSubmissionController(
      type: feedbackType,
      invalidIdentifiers: invalidIdentifiers,
      validIdentifiers: validIdentifiers,
      style: .insetGrouped)
    
    feedbackSubmissionTable.title = "Confirm Feedback"
    pushViewController(feedbackSubmissionTable, animated: true)
  }
  
  // MARK: - Networking
  
  func submitFeedbackData(type: ClassificationFeedbackType, validIdentifiers: [String]?, invalidIdentifiers: [String]?, onSuccess: @escaping () -> Void?, onError: @escaping () -> Void?) {
    let encodedImage = classificationImage.scaleAndEncode()
    let encodedClassificationResult = classificationResults.encodeToString()
    let encodedDate = String(Date().timeIntervalSince1970)
    let deviceInfo = UIDevice().getDeviceInfo()
    
    // Ensure the classification result is properly encoded before proceeding
    guard let encodedClassificationResult = encodedClassificationResult else {
      onError()
      return
    }
    
    var invalidClassificationIdentifiers: [String]?
    var validClassificationIdentifiers: [String]?
    
    switch type {
      case .positive:
        invalidClassificationIdentifiers = nil
        validClassificationIdentifiers = validIdentifiers
      case .negative:
        invalidClassificationIdentifiers = invalidIdentifiers
        validClassificationIdentifiers = validIdentifiers
    }
    
    let classificationData = ClassificationFeedback(
      type: type.rawValue,
      image: encodedImage,
      classificationResults: encodedClassificationResult,
      invalidIdentifiers: invalidClassificationIdentifiers,
      validIdentifiers: validClassificationIdentifiers,
      date: encodedDate,
      deviceInfo: deviceInfo)
    
    networkManager.postClassificationFeedback(data: classificationData) { result in
      switch result {
        case .success(_):
          print("Successfully posted feedback data")
          
          DispatchQueue.main.async {
            onSuccess()
          }
        case .failure(let error):
          print("Error posting feedback data: \(error.rawValue)")
          
          DispatchQueue.main.async {
            onError()
          }
          return
      }
    }
  }
  
}
