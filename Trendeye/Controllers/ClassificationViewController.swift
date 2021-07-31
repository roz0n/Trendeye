//
//  ClassificationViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

final class ClassificationViewController: UITableViewController {
  
  // MARK: - Classifier Properties
  
  var classifier = TrendClassificationManager()
  var confidenceButton = ClassifierConfidenceButton(type: .system)
  var topResultMetric: TrendClassificationMetric?
  
  var results: [VNClassificationObservation]? {
    didSet {
      guard let results = results else { return }
      
      if !results.isEmpty {
        topResult = results[0]
      }
    }
  }
  
  var topResult: VNClassificationObservation? {
    didSet {
      guard let topResult = topResult else { return }
      
      topResultMetric = TrendClassificationManager.shared.getClassificationMetric(for: topResult)
      confidenceButton.classificationMetric = topResultMetric
    }
  }
  
  // MARK: - UI Properties
  
  var selectedImage: UIImage!
  var stretchyHeaderContainer = StretchyTableHeaderView()
  var stretchyHeaderHeight: CGFloat = 350
  var stretchyTableHeaderContent = ClassificationImageHeader()
  var tableFooter = ClassificationTableFooterView()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  // MARK: - Initializers
  
  init(with image: UIImage) {
    super.init(nibName: nil, bundle: nil)
    
    selectedImage = image
    tableView = UITableView.init(frame: self.tableView.frame, style: .grouped)
    tableView.register(ClassificationViewCell.self, forCellReuseIdentifier: ClassificationViewCell.reuseIdentifier)
    tableView.register(ClassificationTableHeader.self, forHeaderFooterViewReuseIdentifier: ClassificationTableHeader.reuseIdentifier)
    tableView.backgroundColor = K.Colors.ViewBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureClassifier()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    stretchyHeaderContainer.updatePosition()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    configureNavigation()
    configureTableView()
    configureStretchyHeader()
    applyLayouts()
  }
  
  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    
    tableView.contentInset = UIEdgeInsets(top: stretchyHeaderHeight, left: 0, bottom: 0, right: 0)
    stretchyHeaderContainer.updatePosition()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    resetNavigationBar()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureStretchyHeader() {
    let shouldImageScale = selectedImage.size.width > 300 || selectedImage.size.height > 300
    
    // Configure header content
    stretchyTableHeaderContent = ClassificationImageHeader()
    stretchyTableHeaderContent.translatesAutoresizingMaskIntoConstraints = false
    stretchyTableHeaderContent.classificationImage = shouldImageScale ? selectedImage.scaleByPercentage(10) : selectedImage
    
    // Configure header container
    stretchyHeaderContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    stretchyHeaderContainer.scrollView = tableView
    stretchyHeaderContainer.frame = CGRect(x: 0, y: tableView.safeAreaInsets.top, width: view.frame.width, height: stretchyHeaderHeight)
    
    // Creates a new background view on the tableView to use as its background
    tableView.backgroundView = UIView()
    tableView.backgroundView?.addSubview(stretchyHeaderContainer)
    
    // Adjusts the contentInset of the tableView to expose the header
    tableView.contentInset = UIEdgeInsets(top: stretchyHeaderHeight, left: 0, bottom: 0, right: 0)
    
    // This weird bug appeared when we added the table view header, this fixes it
    tableView.setContentOffset(CGPoint(x: 0, y: -(stretchyHeaderHeight)), animated: true)
  }
  
  fileprivate func configureNavigation() {
    let iconSize: CGFloat = 18
    let closeIcon = UIImage(systemName: K.Icons.Close, withConfiguration: UIImage.SymbolConfiguration(pointSize: iconSize, weight: .semibold))
    let fullScreenIcon = UIImage(systemName: K.Icons.Enlarge, withConfiguration: UIImage.SymbolConfiguration(pointSize: iconSize, weight: .semibold))
    
    // Configure buttons
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(handleCloseClassifier))
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: fullScreenIcon, style: .plain, target: self, action: #selector(handleFullScreenButton))
    navigationItem.backButtonTitle = ""
    navigationItem.titleView = confidenceButton
    
    // Configure bar
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.backButtonTitle = ""
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.isOpaque = true
    navigationController?.navigationBar.tintColor = K.Colors.Black
    
    // Set navigation bar background corresponsing to top metric
    if let topResultMetric = topResultMetric {
      navigationController?.navigationBar.barTintColor = getNavigationBackgroundColor(metric: topResultMetric)
    }
  }
  
  fileprivate func configureTableView() {
    tableView.separatorStyle = .none
  }
  
  fileprivate func configureClassifier() {
    classifier.delegate = self
    beginClassification(of: selectedImage)
  }
  
  // MARK: - Helpers
  
  fileprivate func getNavigationBackgroundColor(metric: TrendClassificationMetric) -> UIColor? {
    switch metric {
      case .low:
        return K.Colors.Red
      case .mild:
        return K.Colors.Yellow
      case .high:
        return K.Colors.Green
    }
  }
  
  fileprivate func resetNavigationBar() {
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.isOpaque = false
    navigationController?.navigationBar.barTintColor = nil
    navigationController?.navigationBar.tintColor = K.Colors.Icon
  }
  
  // MARK: - Classification Helpers
  
  fileprivate func beginClassification(of photo: UIImage) {
    guard let image = CIImage(image: photo) else { return }
    classifier.classifyImage(image)
  }
  
  // TODO: This method needs to ensure we don't remain with 0 results
  
  fileprivate func sanitizeClassificationResults(_ results: inout [VNClassificationObservation]) -> [VNClassificationObservation] {
    for result in results {
      let confidence = (result.confidence * 100)
      
      if confidence < 2 {
        let removalIndex = results.firstIndex(of: result)
        if let removalIndex = removalIndex {
          results.remove(at: removalIndex)
        }
      }
    }
    
    return results
  }
  
}

// MARK: - UIScrollViewDelegate

extension ClassificationViewController {
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    stretchyHeaderContainer.updatePosition()
  }
  
}

// MARK: - TrendClassifierDelegate

extension ClassificationViewController: TrendClassificationDelegate {
  
  func didFinishClassifying(_ sender: TrendClassificationManager?, results: inout [VNClassificationObservation]) {
    if !results.isEmpty {
      self.results = sanitizeClassificationResults(&results)
    } else {
      presentSimpleAlert(title: "Classification Error", message: "Failed to classify image. Please try another or try again later.", actionTitle: "Close")
    }
  }
  
  func didError(_ sender: TrendClassificationManager?, error: Error?) {
    if let error = error {
      switch error as! TrendClassificationError {
        case .modelError:
          print("Classification error: failed to initialize model")
        case .classificationError:
          print("Classification error: vision request failed")
        case .handlerError:
          print("Classification error: image request handler failed")
      }
    }
  }
  
}

// MARK: - UITableViewDataSource

extension ClassificationViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ClassificationViewCell.reuseIdentifier, for: indexPath) as! ClassificationViewCell
    cell.resultData = results?[indexPath.row]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return tableView.dequeueReusableHeaderFooterView(withIdentifier: ClassificationTableHeader.reuseIdentifier) as! ClassificationTableHeader
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let result = results?[indexPath.row]
    let category = TrendClassificationManager.shared.indentifiers[result!.identifier]
    let categoryViewController = CategoryViewController()
    
    categoryViewController.title = category
    categoryViewController.name = category
    categoryViewController.identifier = result?.identifier
    
    navigationController?.pushViewController(categoryViewController, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return tableFooter
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 100
  }
  
}

// MARK: - Gestures

extension ClassificationViewController {
  
  @objc func handleCloseClassifier() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func handleFullScreenButton() {
    let fullView = FullScreenImageView()
    
    fullView.modalPresentationStyle = .overFullScreen
    fullView.modalTransitionStyle = .coverVertical
    fullView.image = selectedImage
    
    present(fullView, animated: true, completion: nil)
  }
  
}

// MARK: - Layout

fileprivate extension ClassificationViewController {
  
  func applyLayouts() {
    layoutStretchHeader()
  }
  
  func layoutStretchHeader() {
    stretchyHeaderContainer.addSubview(stretchyTableHeaderContent)
    
    NSLayoutConstraint.activate([
      stretchyTableHeaderContent.topAnchor.constraint(equalTo: stretchyHeaderContainer.topAnchor),
      stretchyTableHeaderContent.leadingAnchor.constraint(equalTo: stretchyHeaderContainer.leadingAnchor),
      stretchyTableHeaderContent.trailingAnchor.constraint(equalTo: stretchyHeaderContainer.trailingAnchor),
      stretchyTableHeaderContent.bottomAnchor.constraint(equalTo: stretchyHeaderContainer.bottomAnchor),
    ])
  }
  
}
