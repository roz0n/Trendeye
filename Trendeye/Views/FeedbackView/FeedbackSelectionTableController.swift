//
//  FeedbackSelectionTableController.swift
//  FeedbackSelectionTableController
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

class FeedbackSelectionTableController: UITableViewController, UISearchResultsUpdating {
  
  // MARK: - Properties
  
  let tableType: FeedbackTable
  
  var feedbackNavigationController: FeedbackViewController? {
    return navigationController as? FeedbackViewController
  }
  
  // MARK: - Views
  
  var nextButton: UIBarButtonItem?
  var searchController: UISearchController?
  
  // MARK: - Identifier Data Properties
  
  var classifiedIdentifiers: [String]?
  
  var allTrendIdentifiers: [String] {
    return Array(TrendClassificationManager.shared.indentifiers.values)
  }
  
  // We filter the results during a search, therefore we need a variable we can overwrite and not the computed variable above
  // TODO: These need to be filtered for the trends from the classifier the user did not label as incorrect
  var trendIdentifiers: [String]?
  
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
    return tableType == .incorrect ? classifiedIdentifiers : trendIdentifiers
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.reuseIdentifier)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // This corrects a bug when we navigation back to this view controller in its .correct state
    nextButton?.isEnabled = getBarButtonStatus()
  }
  
  // MARK: - Initializers
  
  init(type: FeedbackTable) {
    self.tableType = type
    super.init(style: .plain)
    
    configureNavigationBar()
    
    if tableType == .correct {
      trendIdentifiers = allTrendIdentifiers
      configureSearchController()
    } else {
      configureTableHeader()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  func configureTableHeader() {
    let instructionsView = UITextView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
    let text = "Please select the incorrectly classified trends from your image analysis. Your selections will be used to better inform future analysis."
    let style = NSMutableParagraphStyle()
    
    style.lineSpacing = 4
    instructionsView.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: style])
    instructionsView.textContainerInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
    instructionsView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    instructionsView.textColor = K.Colors.Icon.withAlphaComponent(0.5)
    
    tableView.tableHeaderView = instructionsView
  }
  
  func configureNavigationBar() {
    nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(tappedNextButton))
    nextButton?.isEnabled = getBarButtonStatus()
    
    navigationItem.rightBarButtonItem = nextButton
  }
  
  func configureSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController?.searchResultsUpdater = self
    searchController?.hidesNavigationBarDuringPresentation = false
    searchController?.obscuresBackgroundDuringPresentation = false
    searchController?.definesPresentationContext = true
    searchController?.searchBar.placeholder = "Search"
    searchController?.searchBar.backgroundImage = UIImage()
    searchController?.searchBar.backgroundColor = .systemBackground
    
    navigationItem.hidesSearchBarWhenScrolling = false
    tableView.tableHeaderView = searchController!.searchBar
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
  
  func resetData() {
    trendIdentifiers = allTrendIdentifiers
    tableView.reloadData()
  }
  
  func filterData(for query: String) {
    trendIdentifiers?.removeAll()
    trendIdentifiers = allTrendIdentifiers.filter { $0.lowercased().contains(query.lowercased()) }
    tableView.reloadData()
  }
  
}

// MARK: - UISearchResultsUpdating

extension FeedbackSelectionTableController {
  
  func updateSearchResults(for searchController: UISearchController) {
    // update results here
    guard let query = searchController.searchBar.text else { return }
    
    guard query != "" else {
      resetData()
      return
    }
    
    filterData(for: query)
  }
  
}

// MARK: - UITableViewDataSource

extension FeedbackSelectionTableController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableType == .incorrect ? classifiedIdentifiers?.count ?? 0 : trendIdentifiers?.count ?? 0
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
