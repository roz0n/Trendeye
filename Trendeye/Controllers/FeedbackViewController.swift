//
//  FeedbackViewController.swift
//  FeedbackViewController
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit
import Vision

enum FeedbackTable: String {
  case correct
  case incorrect
}

class FeedbackViewController: UINavigationController {
  
  // MARK: - Properties
  // TODO: This makes `classificationIdentifiers` redundant, it could just be a computed variable
  var classificationResults: [VNClassificationObservation]
  var classificationImage: UIImage
  var classificationIdentifiers: [String]
  var incorrectIdentifiers = [String: Bool]()
  var correctIdentifiers =  [String: Bool]()
  
  var allIdentifiers: [String] {
    return Array(TEClassificationManager.shared.indentifiers.values)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Initializers
  
  convenience init(for image: UIImage, with identifers: [String], results: [VNClassificationObservation]) {
    let incorrectIdentifiersTable = FeedbackSelectionTableController(type: .incorrect, identifiers: nil)
    
    incorrectIdentifiersTable.classifiedIdentifiers = identifers
    incorrectIdentifiersTable.navigationItem.title = "Report Incorrect Analysis"
    incorrectIdentifiersTable.navigationItem.backButtonTitle = ""
    
    self.init(rootViewController: incorrectIdentifiersTable, classifiedIdentifiers: identifers, classifiedImage: image, results: results)
  }
  
  init(rootViewController: UIViewController, classifiedIdentifiers: [String], classifiedImage: UIImage, results: [VNClassificationObservation]) {
    self.classificationIdentifiers = classifiedIdentifiers
    self.classificationImage = classifiedImage
    self.classificationResults = results
    
    super.init(rootViewController: rootViewController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  fileprivate func getFilteredIdentifiers(classified classifiedIdentifiers: [String], all allIdentifiers: [String]) -> [String] {
    return allIdentifiers.filter { !classifiedIdentifiers.contains($0) }
  }
  
  func presentCorrectClassificationTable() {
    // The full list of identifiers needs to be filtered in order to remove the values that were present in the classification being reported
    let filteredIdentifiers = getFilteredIdentifiers(classified: classificationIdentifiers, all: allIdentifiers)
    let correctIdentifiersTable = FeedbackSelectionTableController(type: .correct, identifiers: filteredIdentifiers)
    
    correctIdentifiersTable.selectedIdentifiers = correctIdentifiers
    correctIdentifiersTable.navigationItem.title = "Select Correct Trends"
    correctIdentifiersTable.navigationItem.backButtonTitle = ""
    
    pushViewController(correctIdentifiersTable, animated: true)
  }
  
  func presentSubmitScreen() {
    // TODO: Perform network call
    // TODO: Handle errors
    
    let feedbackSubmissionTable = FeedbackSubmissionTableController(
      Array(incorrectIdentifiers.keys),
      Array(correctIdentifiers.keys),
      style: .insetGrouped)
    
    feedbackSubmissionTable.title = "Confirm"
    pushViewController(feedbackSubmissionTable, animated: true)
  }
  
}
