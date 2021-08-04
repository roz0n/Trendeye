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
  
  var incorrectClassificationIdentifiers = [String: Bool]()
  var correctClassificationIdentifiers =  [String: Bool]()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    view.backgroundColor = .systemPurple
  }
  
  // MARK: - Initializers
  
  convenience init(with identifers: [String]) {
    let incorrectClassificationTable = FeedbackSelectionTableController(type: .incorrect)
    
    incorrectClassificationTable.classifiedIdentifiers = identifers
    incorrectClassificationTable.navigationItem.title = "Report Incorrect Analysis"
    incorrectClassificationTable.navigationItem.backButtonTitle = ""
    
    self.init(rootViewController: incorrectClassificationTable)
  }
  
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func presentCorrectClassificationTable() {
    let correctClassificationTable = FeedbackSelectionTableController(type: .correct)
    
    correctClassificationTable.selectedIdentifiers = correctClassificationIdentifiers
    correctClassificationTable.navigationItem.title = "Select Correct Trends"
    correctClassificationTable.navigationItem.backButtonTitle = ""
    
    pushViewController(correctClassificationTable, animated: true)
  }
  
  func presentSubmitScreen() {
    // TODO: Perform network call
    // TODO: Handle errors
    
    let feedbackSubmissionTable = FeedbackSubmissionTableController(
      Array(incorrectClassificationIdentifiers.keys),
      Array(correctClassificationIdentifiers.keys),
      style: .insetGrouped)
    
    feedbackSubmissionTable.title = "Confirm"
    pushViewController(feedbackSubmissionTable, animated: true)
  }
  
}
