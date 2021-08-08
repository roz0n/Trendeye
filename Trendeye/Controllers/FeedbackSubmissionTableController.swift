//
//  FeedbackSubmissionTableController.swift
//  FeedbackSubmissionTableController
//
//  Created by Arnaldo Rozon on 8/3/21.
//

import UIKit
import Vision

class FeedbackSubmissionTableController: UITableViewController {
  
  // MARK: - Properties
  
  let cellIdentifier = "feedbackSubmissionCell"
  
  var feedbackNavigationController: FeedbackViewController? {
    return navigationController as? FeedbackViewController
  }
  
  let networkManager = TENetworkManager()
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
    
    tableView.allowsSelection = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    
    configureNavigation()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureNavigation() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(tappedSubmitButton))
  }
  
  @objc func tappedSubmitButton() {
    submitFeedbackData(type: feedbackType)
  }
  
  // MARK: - Networking
  
  func submitFeedbackData(type: ClassificationFeedbackType) {
    let encodedImage = feedbackNavigationController?.classificationImage.scaleAndEncode()
    let encodedClassificationResult = encodeClassificationResults(results: feedbackNavigationController?.classificationResults)
    let encodedDate = String(Date().timeIntervalSince1970)
    let deviceInfo = UIDevice().getDeviceInfo()
    
    var incorrectClassificationIdentifiers: [String]?
    var correctClassificationIdentifiers: [String]?
    
    switch type {
      case .positive:
        break
      case .negative:
        incorrectClassificationIdentifiers = incorrectIdentifiers
        correctClassificationIdentifiers = correctIdentifiers
    }
    
    let classificationData = ClassificationFeedback(
      type: type.rawValue,
      image: encodedImage,
      classificationResults: encodedClassificationResult,
      incorrectIdentifiers: incorrectClassificationIdentifiers,
      correctIdentifiers: correctClassificationIdentifiers,
      date: encodedDate,
      deviceInfo: deviceInfo)
    
    networkManager.postClassificationFeedback(type: .negative, data: classificationData) { [weak self] (result) in
      switch result {
        case .success(_):
          print("Successfully posted feedback data")
          
          DispatchQueue.main.async {
            self?.presentFeedbackSubmissionAlert(title: "Feedback Submitted", message: "Thank you for helping improve image analysis.")
          }
        case .failure(let error):
          print("Error posting feedback data: \(error.rawValue)")
          
          DispatchQueue.main.async {
            self?.presentFeedbackSubmissionAlert(title: "Oops", message: "Something went wrong, please try again later.")
          }
          return
      }
    }
  }
  
  // MARK: - Helpers
  
  func encodeClassificationResults(results: [VNClassificationObservation]?) -> String? {
    guard let results = results else {
      return nil
    }
    
    let encodedResults = try? JSONEncoder().encode(results)
    
    guard let encodedResults = encodedResults else {
      return nil
    }
    
    return String(data: encodedResults, encoding: .utf8)
  }
  
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
