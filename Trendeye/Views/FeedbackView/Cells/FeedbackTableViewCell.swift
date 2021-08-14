//
//  FeedbackTableViewCell.swift
//  FeedbackTableViewCell
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "FeedbackTableCell"
  
  var resultIdentifier: String?
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
