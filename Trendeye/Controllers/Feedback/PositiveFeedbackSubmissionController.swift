//
//  PositiveFeedbackSubmissionController.swift
//  PositiveFeedbackSubmissionController
//
//  Created by Arnaldo Rozon on 8/11/21.
//

import UIKit

class PositiveFeedbackSubmissionController: UITableViewController {
  
  // MARK: - Properties
  
  static let reuseIdentifier = "PositiveFeedbackSubmissionCell"
  
  let classificationIdentifiers: [String]?
  
  var feedbackNavigationController: FeedbackViewController? {
    return navigationController as? FeedbackViewController
  }
  
  // MARK: - Initializers
  
  init(identifiers: [String]?) {
    self.classificationIdentifiers = identifiers
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigation()
    configureTableView()
    configureTableHeader()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureNavigation() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(tappedSubmitButton))
  }
  
  func configureTableView() {
    tableView.backgroundColor = K.Colors.Background
    tableView.allowsSelection = false
    tableView.tableFooterView = UIView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: PositiveFeedbackSubmissionController.reuseIdentifier)
  }
  
  fileprivate func configureTableHeader() {
    let instructionsView = UITextView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
    let text = "Duis efficitur metus feugiat, ultrices nibh ac, imperdiet mauris. Aliquam eu justo vehicula, tristique enim ut, dignissim diam."
    let style = NSMutableParagraphStyle()
    
    style.lineSpacing = 4
    instructionsView.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: style])
    instructionsView.textContainerInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
    instructionsView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    instructionsView.textColor = K.Colors.DimmedForeground
    instructionsView.backgroundColor = .clear
    instructionsView.isUserInteractionEnabled = false
    
    tableView.tableHeaderView = instructionsView
  }
  
  // MARK: - Gestures
  
  @objc func tappedSubmitButton() {
    feedbackNavigationController?.submitFeedbackData(type: .positive, validIdentifiers: classificationIdentifiers, invalidIdentifiers: nil, onSuccess: presentSuccessAlert, onError: presentErrorAlert)
  }
  
  fileprivate func presentSuccessAlert() {
    self.presentFeedbackSubmissionAlert(title: "Feedback Submitted", message: "Thank you for helping improve image analysis.")
  }
  
  fileprivate func presentErrorAlert() {
    self.presentFeedbackSubmissionAlert(title: "Oops", message: "Something went wrong, please try again later.")
  }
  
  fileprivate func presentFeedbackSubmissionAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Close", style: .default) { [weak self] action in
      self?.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
}

// MARK: - Table View Methods

extension PositiveFeedbackSubmissionController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return classificationIdentifiers?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PositiveFeedbackSubmissionController.reuseIdentifier, for: indexPath)
    
    guard let classificationIdentifiers = classificationIdentifiers else {
      return cell
    }
    
    cell.textLabel?.text = classificationIdentifiers[indexPath.row]
    cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    cell.backgroundColor = .clear
    
    return cell
  }
  
}
