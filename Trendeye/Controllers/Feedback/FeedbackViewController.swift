//
//  FeedbackViewController.swift
//  FeedbackViewController
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit
import Vision

enum FeedbackTable: String {
  case correctIdentifiers
  case incorrectIdentifiers
}

class FeedbackViewController: UINavigationController {
  
  // MARK: - Properties
  var feedbackType: ClassificationFeedbackType
  var classificationImage: UIImage
  var classificationResults: [VNClassificationObservation]
  var classificationIdentifiers: [String]?
  var incorrectIdentifiers = [String: Bool]()
  var correctIdentifiers =  [String: Bool]()
  
  var allIdentifiers: [String] {
    return Array(TEClassificationManager.shared.indentifiers.values)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if (feedbackType == .positive) {
      setNavigationBarHidden(true, animated: animated)
    }
  }
  
  // MARK: - Initializers
  
  convenience init(type feedbackType: ClassificationFeedbackType, for classificationResults: [VNClassificationObservation], classificationIdentifiers: [String]?, classificationImage: UIImage) {
    switch feedbackType {
      case .positive:
        let rootViewController = PositiveFeedbackSubmissionController()
        rootViewController.navigationItem.title = "Report Correct Analysis"
        rootViewController.navigationItem.backButtonTitle = ""
        
        self.init(rootViewController: rootViewController, type: feedbackType, classificationResults: classificationResults, classificationIdentifiers: classificationIdentifiers, classificationImage: classificationImage)
      case .negative:
        let rootViewController = NegativeFeedbackSelectionController(type: .incorrectIdentifiers, identifiers: nil)
        rootViewController.classificationIdentifiers = classificationIdentifiers
        rootViewController.navigationItem.title = "Report Incorrect Analysis"
        rootViewController.navigationItem.backButtonTitle = ""
        
        self.init(rootViewController: rootViewController, type: feedbackType, classificationResults: classificationResults, classificationIdentifiers: classificationIdentifiers, classificationImage: classificationImage)
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
  
  func presentCorrectClassificationTableView() {
    guard let classificationIdentifiers = classificationIdentifiers else {
      return
    }
    
    // The full list of identifiers needs to be filtered in order to remove the values that were present in the classification being reported
    let filteredIdentifiers = getFilteredIdentifiers(classified: classificationIdentifiers, all: allIdentifiers)
    let correctIdentifiersTable = NegativeFeedbackSelectionController(type: .correctIdentifiers, identifiers: filteredIdentifiers)
    
    correctIdentifiersTable.selectedIdentifiers = correctIdentifiers
    correctIdentifiersTable.navigationItem.title = "Select Correct Trends"
    correctIdentifiersTable.navigationItem.backButtonTitle = ""
    
    pushViewController(correctIdentifiersTable, animated: true)
  }
  
  func presentFeedbackSubmissionTable(type feedbackType: ClassificationFeedbackType) {
    let incorrectIdentifiers = Array(incorrectIdentifiers.keys)
    let correctIdentifiers = Array(correctIdentifiers.keys)
    
    let feedbackSubmissionTable = NegativeFeedbackSubmissionController(
      type: feedbackType,
      incorrectIdentifiers: incorrectIdentifiers,
      correctIdentifiers: correctIdentifiers,
      style: .insetGrouped)
    
    feedbackSubmissionTable.title = "Confirm Feedback"
    pushViewController(feedbackSubmissionTable, animated: true)
  }
  
  // TODO: Move and rename me
  
  func handleSubmitButtonGestures() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPositiveFeedback))
    let vc = getRootViewController() as? InfoModalViewController

    if let vc = vc {
      vc.actionButton.addGestureRecognizer(tapGesture)
    }
  }

  @objc func tappedPositiveFeedback() {
    presentFeedbackSubmissionTable(type: .positive)
  }
  
}
