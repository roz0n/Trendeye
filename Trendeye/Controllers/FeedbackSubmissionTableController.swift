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
    presentSimpleAlert(title: "Feedback Submitted", message: "Thank you for helping improve Trendeye image analysis!", actionTitle: "Close")
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
