//
//  FeedbackTableView.swift
//  FeedbackTableView
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

class FeedbackTableView: UITableViewController {
  
  // MARK: - Properties
  
  var classificationIdentifiers: [String]?
  
  var selectedIdentifiers: [String: Bool] = [:] {
    didSet {
      if !selectedIdentifiers.isEmpty {
        // Call method in parent
        let feedbackController = navigationController as! FeedbackViewController
        feedbackController.badClassificationIdentifiers = selectedIdentifiers
      }
    }
  }
  
  var allTrendIdentifiers: [String] {
    return Array(TrendClassificationManager.shared.indentifiers.values)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.reuseIdentifier)
  }
  
}

// MARK: - Table view data source

extension FeedbackTableView {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return classificationIdentifiers?.count ?? allTrendIdentifiers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.reuseIdentifier, for: indexPath) as! FeedbackTableViewCell
    
    guard let classifiedIdentifiers = classificationIdentifiers else {
      return cell
    }
    
    let identifier = classifiedIdentifiers[indexPath.row]
    
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
    guard let dataList = classificationIdentifiers else {
      return
    }
    
    let identifier = dataList[indexPath.row]
    
    if selectedIdentifiers[identifier] == nil {
      selectedIdentifiers[identifier] = true
    } else {
      selectedIdentifiers[identifier]?.toggle()
    }
    
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
}
