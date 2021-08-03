//
//  TrendsTableView.swift
//  TrendsTableView
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

class TrendsTableView: UITableViewController {
  
  // MARK: - Properties
  
  var trendIdentifiers: [String] {
    return Array(TrendClassificationManager.shared.indentifiers.values)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(TrendsTableViewCell.self, forCellReuseIdentifier: TrendsTableViewCell.reuseIdentifier)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trendIdentifiers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TrendsTableViewCell.reuseIdentifier, for: indexPath)
    let text = trendIdentifiers[indexPath.row]
    
    cell.textLabel?.text = text
    
    return cell
  }
  
}
