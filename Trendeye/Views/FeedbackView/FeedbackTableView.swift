//
//  FeedbackTableView.swift
//  FeedbackTableView
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

class FeedbackTableView: UITableViewController {
  
  // MARK: - Properties
  
  let tableType: FeedbackTable
  
  var feedbackNavigationController: FeedbackViewController? {
    return navigationController as? FeedbackViewController
  }
  
  // MARK: -
  
  var classificationIdentifiers: [String]?
  
  var allTrendIdentifiers: [String] {
    return Array(TrendClassificationManager.shared.indentifiers.values)
  }
  
  var selectedIdentifiers: [String: Bool] = [:] {
    didSet {
      if tableType == .incorrect {
        feedbackNavigationController?.incorrectClassificationIdentifiers = selectedIdentifiers
      } else {
        feedbackNavigationController?.correctClassificationIdentifiers = selectedIdentifiers
      }
    }
  }
  
  // This variable determines the identifiers we use to populate the list of selected identifiers
  var sourceIdentifiers: [String]? {
    return tableType == .incorrect ? classificationIdentifiers : allTrendIdentifiers
  }
  
  // MARK: -
  
  var nextButton: UIBarButtonItem?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.reuseIdentifier)
  }
  
  // MARK: - Initializers
  
  init(type: FeedbackTable) {
    self.tableType = type
    super.init(style: .plain)
    
    configureNavigationBar()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  func configureNavigationBar() {
    nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(tappedNextButton))
    nextButton?.isEnabled = false
    
    navigationItem.rightBarButtonItem = nextButton
  }
  
  // MARK: - Gestures
  
  @objc func tappedNextButton() {
    tableType == .incorrect ?
    feedbackNavigationController?.presentCorrectClassificationTable() :
    feedbackNavigationController?.presentSubmitScreen()
  }
  
  // MARK: - Helpers
  
  func getBarButtonStatus() -> Bool {
    return !selectedIdentifiers.isEmpty
  }
  
}

// MARK: - Table view data source

extension FeedbackTableView {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableType == .incorrect ? classificationIdentifiers!.count : allTrendIdentifiers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.reuseIdentifier, for: indexPath) as! FeedbackTableViewCell
    
    guard let sourceIdentifiers = sourceIdentifiers else {
      return cell
    }
    
    let identifier = sourceIdentifiers[indexPath.row]
    
    if selectedIdentifiers[identifier] == true {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    
    cell.resultIdentifier = identifier
    cell.textLabel?.text = identifier
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let sourceIdentifiers = sourceIdentifiers else {
      return
    }
    
    let identifier = sourceIdentifiers[indexPath.row]
    
    if selectedIdentifiers[identifier] == nil {
      selectedIdentifiers[identifier] = true
    } else {
      selectedIdentifiers[identifier]?.toggle()
    }
    
    nextButton?.isEnabled = getBarButtonStatus()
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
}
