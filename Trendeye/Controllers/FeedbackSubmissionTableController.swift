//
//  FeedbackSubmissionTableController.swift
//  FeedbackSubmissionTableController
//
//  Created by Arnaldo Rozon on 8/3/21.
//

import UIKit

class FeedbackSubmissionTableController: UITableViewController {
  
  // MARK: - Properties
  
  let cellIdentifier = "feedbackSubmissionCell"
  
  var feedbackNavigationController: FeedbackViewController? {
    return navigationController as? FeedbackViewController
  }
  
  let networkManager = TENetworkManager()
  let incorrectIdentifiers: [String]
  let correctIdentifiers: [String]
  let sectionTitles = ["Incorrect Classifications", "Correct Classifications"]
  let sectionData: [Int: [String]]
  
  // MARK: - Initializers
  
  init(_ incorrect: [String], _ correct: [String], style: UITableView.Style) {
    self.incorrectIdentifiers = incorrect
    self.correctIdentifiers = correct
    self.sectionData = [0: incorrectIdentifiers, 1: correctIdentifiers]
    
    super.init(style: style)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsSelection = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    
    configureNavigation()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureNavigation() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(tappedSubmitButton))
  }
  
  @objc func tappedSubmitButton() {
    submitFeedbackData()
  }
  
  // MARK: - Networking
  
  // TODO: Lots of refactoring here
  func submitFeedbackData() {
    // Image
    let encodedImage = feedbackNavigationController?.classificationImage.scaleAndEncode()
    
    // Classification results
    let classificationResults = feedbackNavigationController?.classificationResults
    var encodedResultsStr: String?
    
    if let encodedResults = try? JSONEncoder().encode(classificationResults), let response = String(data: encodedResults, encoding: .utf8) {
      encodedResultsStr = response
    } else {
      encodedResultsStr = nil
    }
    
    // Classifications
    
    // Date
    let dateStr = String(Date().timeIntervalSince1970)
    
    // Device id
    let deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    let classificationData = ClassificationFeedback(
      type: .negative,
      // TODO: Handle these nil values
      image: encodedImage!,
      classificationResult: encodedResultsStr!,
      incorrectIdentifiers: incorrectIdentifiers,
      correctIdentifiers: correctIdentifiers,
      date: dateStr,
      deviceId: deviceId!)
    
    networkManager.postClassificationFeedback(type: .negative, data: classificationData) { [weak self] (result) in
      switch result {
        case .success(_):
          print("Successfully posted feedback data")
          
          DispatchQueue.main.async {
            self?.presentFeedbackSubmissionAlert(title: "Feedback Submitted", message: "Thank you for helping improve Trendeye image analysis!")
          }
        case .failure(let error):
          print("Error posting feedback data:, \(error.rawValue)")
          
          DispatchQueue.main.async {
            self?.presentFeedbackSubmissionAlert(title: "Oops", message: "Something went wrong, please try again later.")
          }
          return
      }
    }
  }
  
  // MARK: - Helpers
  
  func presentFeedbackSubmissionAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Close", style: .default) { [weak self] action in
      self?.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
}

// MARK: - UITableViewDataSource

extension FeedbackSubmissionTableController {
  
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
    
    guard let cellSectionData = sectionData[indexPath.section] else {
      return cell
    }
    
    cell.textLabel?.text = cellSectionData[indexPath.row]
    
    return cell
  }
  
}
