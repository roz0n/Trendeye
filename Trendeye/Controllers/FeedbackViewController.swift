//
//  FeedbackViewController.swift
//  FeedbackViewController
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

enum ClassificationFeedback {
  case positive
  case negative
}

class FeedbackViewController: UINavigationController {
  
  // MARK: - Properties
  
  var badClassificationIdentifiers = [String: Bool]()
  var correctClassificationIdentifiers =  [String: Bool]()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    view.backgroundColor = .systemPurple
  }
  
  // MARK: - Initializers
  
//  convenience init() {
//    let classificationResultsViewController = FeedbackTableView()
//    self.init(rootViewController: classificationResultsViewController)
//  }
  
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
