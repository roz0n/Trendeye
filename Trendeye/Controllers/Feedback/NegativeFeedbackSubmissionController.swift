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
  
  let reuseIdentifier = "NegativefeedbackSubmissionCell"
  
  var feedbackNavigationController: FeedbackViewController? {
    return navigationController as? FeedbackViewController
  }
  
  let feedbackType: ClassificationFeedbackType
  let invalidIdentifiers: [String]
  let validIdentifiers: [String]
  let sectionTitles = [NegativeFeedbackSubmissionStrings.invalidSectionTitle, NegativeFeedbackSubmissionStrings.validSectionTitle]
  let sectionData: [Int: [String]]
  
  // MARK: - Initializers
  
  init(type feedbackType: ClassificationFeedbackType, invalidIdentifiers: [String], validIdentifiers: [String], style: UITableView.Style) {
    self.invalidIdentifiers = invalidIdentifiers
    self.validIdentifiers = validIdentifiers
    self.sectionData = [0: invalidIdentifiers, 1: validIdentifiers]
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
    tableView.backgroundColor = K.Colors.Background
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
  
  fileprivate func configureNavigation() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: NegativeFeedbackSubmissionStrings.submitButton,
      style: .done,
      target: self,
      action: #selector(tappedSubmitButton))
  }
  
  @objc func tappedSubmitButton() {
    feedbackNavigationController?.submitFeedbackData(
      type: feedbackType,
      validIdentifiers: validIdentifiers,
      invalidIdentifiers: invalidIdentifiers,
      onSuccess: presentSuccessAlert,
      onError: presentErrorAlert)
  }
  
  // MARK: - Helpers
  
  fileprivate func presentSuccessAlert() {
    self.presentFeedbackSubmissionAlert(
      title: NegativeFeedbackSubmissionStrings.successAlertTitle,
      message: NegativeFeedbackSubmissionStrings.successAlertBody)
  }
  
  fileprivate func presentErrorAlert() {
    self.presentFeedbackSubmissionAlert(
      title: NegativeFeedbackSubmissionStrings.errorAlertTitle,
      message: NegativeFeedbackSubmissionStrings.errorAlertBody)
  }
  
  fileprivate func presentFeedbackSubmissionAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: NegativeFeedbackSubmissionStrings.submissionAlertButton, style: .default) { [weak self] action in
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
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    cell.backgroundColor = .clear
    
    guard let cellSectionData = sectionData[indexPath.section] else {
      return cell
    }
    
    cell.textLabel?.text = cellSectionData[indexPath.row]
    
    return cell
  }
  
}
