//
//  PositiveFeedbackSubmissionController.swift
//  PositiveFeedbackSubmissionController
//
//  Created by Arnaldo Rozon on 8/11/21.
//

import UIKit

class PositiveFeedbackSubmissionController: UITableViewController {
  
  // MARK: - Properties
  
  let cellIdentifier = "positiveFeedbackSubmissionCell"
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
}

// MARK: - Table View Methods

extension PositiveFeedbackSubmissionController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 10
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
}
