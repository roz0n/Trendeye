//
//  FeedbackViewController.swift
//  FeedbackViewController
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

enum FeedbackTable {
  case correct
  case incorrect
}

class FeedbackViewController: UINavigationController {
  
  // MARK: - Properties
  
  var classifiedIdentifiers: [String]
  var incorrectIdentifiers = [String: Bool]()
  var correctIdentifiers =  [String: Bool]()
  
  var allIdentifiers: [String] {
    return Array(TrendClassificationManager.shared.indentifiers.values)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Initializers
  
  convenience init(with identifers: [String]) {
    let incorrectIdentifiersTable = FeedbackSelectionTableController(type: .incorrect, identifiers: nil)
    
    incorrectIdentifiersTable.classifiedIdentifiers = identifers
    incorrectIdentifiersTable.navigationItem.title = "Report Incorrect Analysis"
    incorrectIdentifiersTable.navigationItem.backButtonTitle = ""
    
    self.init(rootViewController: incorrectIdentifiersTable, classifiedIdentifiers: identifers)
  }
  
  init(rootViewController: UIViewController, classifiedIdentifiers: [String]) {
    self.classifiedIdentifiers = classifiedIdentifiers
    super.init(rootViewController: rootViewController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func getFilteredIdentifiers(classified classifiedIdentifiers: [String], all allIdentifiers: [String]) -> [String] {
    return allIdentifiers.filter { !classifiedIdentifiers.contains($0) }
  }
  
  func presentCorrectClassificationTable() {
    // The full list of identifiers needs to be filtered in order to remove the values that were present in the classification being reported
    let filteredIdentifiers = getFilteredIdentifiers(classified: classifiedIdentifiers, all: allIdentifiers)
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
