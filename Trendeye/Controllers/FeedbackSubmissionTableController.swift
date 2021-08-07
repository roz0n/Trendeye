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
  let incorrectClassifications: [String]
  let correctClassifications: [String]
  let sectionTitles = ["Incorrect Classifications", "Correct Classifications"]
  let sectionData: [Int: [String]]
  
    // MARK: - Initializers
  
  init(_ incorrect: [String], _ correct: [String], style: UITableView.Style) {
    self.incorrectClassifications = incorrect
    self.correctClassifications = correct
    self.sectionData = [0: incorrectClassifications, 1: correctClassifications]
    
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
  
  func submitFeedbackData() {
    let classificationData = ClassificationFeedback(
      type: "negative",
      image: "ios-image",
      classificationResult: "ios-classification-result",
      classificationIdentifiers: ["ios", "ios2", "ios3"],
      correctIdentifiers: ["ios-identifiers2", "ios-identifiers3", "ios-identifiers4"],
      date: "ios-date",
      deviceId: "ios-device-id")
    
    networkManager.postClassificationFeedback(type: .negative, data: classificationData) { [weak self] (result) in
      switch result {
        case .success(_):
          print("Successfully posted feedback data")
          
          DispatchQueue.main.async {
            self?.presentFeedbackSubmissionAlert()
          }
        case .failure(let error):
        print("Error posting feedback data:, \(error.rawValue)")
        }
    }
  }
  
    // MARK: - Helpers
  
  func presentFeedbackSubmissionAlert() {
    let alert = UIAlertController(title: "Feedback Submitted", message: "Thank you for helping improve Trendeye image analysis!", preferredStyle: .alert)
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
