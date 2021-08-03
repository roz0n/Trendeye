//
//  FeedbackTableViewCell.swift
//  FeedbackTableViewCell
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "feedbackTableCell"
  
  var resultIdentifier: String?
  
  // MARK: - View Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
