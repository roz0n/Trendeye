//
//  NegativeFeedbackSubmissionController.swift
//  NegativeFeedbackSubmissionController
//
//  Created by Arnaldo Rozon on 8/3/21.
//

import UIKit
import Vision

class NegativeFeedbackSubmissionController: UITableViewController {
  
  // MARK: - Properties
  
  let cellIdentifier = "negativefeedbackSubmissionCell"
  
  var feedbackNavigationController: FeedbackViewController? {
    return navigationController as? FeedbackViewController
  }
  
  let feedbackType: ClassificationFeedbackType
  let incorrectIdentifiers: [String]
  let correctIdentifiers: [String]
  let sectionTitles = ["Incorrect Classifications", "Correct Classifications"]
  let sectionData: [Int: [String]]
  
  // MARK: - Initializers
  
  init(type feedbackType: ClassificationFeedbackType, incorrectIdentifiers: [String], correctIdentifiers: [String], style: UITableView.Style) {
    self.incorrectIdentifiers = incorrectIdentifiers
    self.correctIdentifiers = correctIdentifiers
    self.sectionData = [0: incorrectIdentifiers, 1: correctIdentifiers]
    self.feedbackType = feedbackType
    
    super.init(style: style)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
    configureNavigation()
  }
  
  // MARK: - Configurations
  
  func configureTableView() {
    tableView.allowsSelection = false
    tableView.backgroundColor = K.Colors.Black
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
  
  fileprivate func configureNavigation() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(tappedSubmitButton))
  }
  
  @objc func tappedSubmitButton() {
    feedbackNavigationController?.submitFeedbackData(
      type: feedbackType,
      correctIdentifiers: correctIdentifiers,
      incorrectIdentifiers: incorrectIdentifiers,
      onSuccess: presentSuccessAlert,
      onError: presentErrorAlert)
  }
  
  // MARK: - Helpers
  
  fileprivate func presentSuccessAlert() {
    self.presentFeedbackSubmissionAlert(title: "Feedback Submitted", message: "Thank you for helping improve image analysis.")
  }
  
  fileprivate func presentErrorAlert() {
    self.presentFeedbackSubmissionAlert(title: "Oops", message: "Something went wrong, please try again later.")
  }
  
  fileprivate func presentFeedbackSubmissionAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Close", style: .default) { [weak self] action in
      self?.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
}

// MARK: - UITableViewDataSource

extension NegativeFeedbackSubmissionController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sectionData[section]?.count ?? 0
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    cell.backgroundColor = .clear
    
    guard let cellSectionData = sectionData[indexPath.section] else {
      return cell
    }
    
    cell.textLabel?.text = cellSectionData[indexPath.row]
    
    return cell
  }
  
}
