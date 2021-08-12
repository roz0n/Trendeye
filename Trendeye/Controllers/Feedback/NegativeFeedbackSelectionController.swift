//
//  NegativeFeedbackSelectionController.swift
//  NegativeFeedbackSelectionController
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

class NegativeFeedbackSelectionController: UITableViewController, UISearchResultsUpdating {
  
  // MARK: - Properties
  
  let tableType: FeedbackTable
  
  var feedbackNavigationController: FeedbackViewController? {
    return navigationController as? FeedbackViewController
  }
  
  // MARK: - Views
  
  var nextButton: UIBarButtonItem?
  var searchController: UISearchController?
  
  // MARK: - Identifier Data Properties
  
  // This is used when loading the "correct" table, it's a filtered list of all the identifiers
  // It's not needed in the "incorrect" table, as that only loads the classified identifiers
  var allIdentifiers: [String]?
  var classificationIdentifiers: [String]?
  
  // This value is initially identical to `allIdentifiers` but is mutated during searches to present filtered results
  var trendIdentifiers: [String]?
  
  // These are the identifiers the user has selected as correct and incorrect
  // They are sent back to the parent view controller for processing upon completion of the feedback flow
  var selectedIdentifiers: [String: Bool] = [:] {
    didSet {
      if tableType == .incorrectIdentifiers {
        feedbackNavigationController?.incorrectIdentifiers = selectedIdentifiers
      } else {
        feedbackNavigationController?.correctIdentifiers = selectedIdentifiers
      }
    }
  }
  
  // This variable determines the identifiers we use to populate the list of selected identifiers
  var sourceIdentifiers: [String]? {
    return tableType == .incorrectIdentifiers ? classificationIdentifiers : trendIdentifiers
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
    configureTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // This corrects a bug when we navigation back to this view controller in its .correct state
    nextButton?.isEnabled = getBarButtonStatus()
  }
  
  // MARK: - Initializers
  
  init(type: FeedbackTable, identifiers: [String]?) {
    self.tableType = type
    self.allIdentifiers = identifiers
    
    super.init(style: .plain)
    
    configureNavigationBar()
    
    if tableType == .correctIdentifiers {
      trendIdentifiers = allIdentifiers
      configureSearchController()
    } else {
      configureTableHeader()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  fileprivate func configureView() {
    view.backgroundColor = K.Colors.Black
  }
  
  fileprivate func configureTableView() {
    tableView.backgroundColor = K.Colors.Black
    tableView.tableFooterView = UIView()
    tableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.reuseIdentifier)
  }
  
  fileprivate func configureTableHeader() {
    let instructionsView = UITextView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
    let text = "Please select the incorrectly classified trends from your image analysis. Your selections will be used to better inform future analysis."
    let style = NSMutableParagraphStyle()
    
    style.lineSpacing = 4
    instructionsView.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: style])
    instructionsView.textContainerInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
    instructionsView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    instructionsView.textColor = K.Colors.Icon.withAlphaComponent(0.5)
    instructionsView.backgroundColor = .clear
    instructionsView.isUserInteractionEnabled = false
    
    tableView.tableHeaderView = instructionsView
  }
  
  fileprivate func configureNavigationBar() {
    nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(tappedNextButton))
    nextButton?.isEnabled = getBarButtonStatus()
    
    navigationItem.rightBarButtonItem = nextButton
  }
  
  fileprivate func configureSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController?.searchResultsUpdater = self
    searchController?.hidesNavigationBarDuringPresentation = false
    searchController?.obscuresBackgroundDuringPresentation = false
    searchController?.definesPresentationContext = true
    searchController?.searchBar.placeholder = "Search"
    searchController?.searchBar.backgroundImage = UIImage()
    searchController?.searchBar.backgroundColor = K.Colors.Black
    
    navigationItem.hidesSearchBarWhenScrolling = false
    tableView.tableHeaderView = searchController!.searchBar
  }
  
  // MARK: - Gestures
  
  @objc func tappedNextButton() {
    tableType == .incorrectIdentifiers ?
    feedbackNavigationController?.presentCorrectClassificationTableView() :
    feedbackNavigationController?.presentFeedbackSubmissionTable(type: .negative)
  }
  
  // MARK: - Helpers
  
  fileprivate func getBarButtonStatus() -> Bool {
    return !selectedIdentifiers.isEmpty
  }
  
  fileprivate func resetData() {
    trendIdentifiers = allIdentifiers
    tableView.reloadData()
  }
  
  fileprivate func filterData(for query: String) {
    trendIdentifiers?.removeAll()
    trendIdentifiers = allIdentifiers?.filter { $0.lowercased().contains(query.lowercased()) }
    tableView.reloadData()
  }
  
}

// MARK: - UISearchResultsUpdating

extension NegativeFeedbackSelectionController {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text else { return }
    
    guard query != "" else {
      resetData()
      return
    }
    
    filterData(for: query)
  }
  
}

// MARK: - UITableViewDataSource

extension NegativeFeedbackSelectionController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableType == .incorrectIdentifiers ? classificationIdentifiers?.count ?? 0 : trendIdentifiers?.count ?? 0
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