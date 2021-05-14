//
//  ClassificationViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

final class ClassificationViewController: UITableViewController {
  
  // MARK: - Classifier Members
  
  var classifier = TrendClassifierManager()
  var confidenceButton = ClassifierConfidenceButton()
  
  var results: [VNClassificationObservation]? {
    didSet {
      if let results = results {
        if !results.isEmpty {
          confidenceButton.classificationTopResult = results[0]
        }
      }
    }
  }
  
  // MARK: - UI Members
  
  var stretchyHeaderContainer = StretchyTableHeaderView()
  var stretchyHeaderHeight: CGFloat = 350
  var stretchyTableHeaderContent = ClassificationTableHeaderView()
  var tableFooter = ClassificationTableFooterView()
  
  // MARK: - Other Members
  
  var selectedImage: UIImage!
  
  // MARK: - Initializers
  
  init(with image: UIImage) {
    super.init(nibName: nil, bundle: nil)
    
    self.selectedImage = image
    self.tableView = UITableView.init(
      frame: self.tableView.frame,
      style: .grouped)
    self.tableView.register(
      ClassificationTopResultCell.self,
      forCellReuseIdentifier: ClassificationTopResultCell.reuseIdentifier)
    self.tableView.register(
      ClassificationResultCell.self,
      forCellReuseIdentifier: ClassificationResultCell.reuseIdentifier)
    self.tableView.backgroundColor = K.Colors.ViewBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    applyConfigurations()
    applyLayouts()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureClassifier()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    stretchyHeaderContainer.updatePosition()
  }
  
  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    tableView.contentInset = UIEdgeInsets(
      top: stretchyHeaderHeight,
      left: 0,
      bottom: 0,
      right: 0)
    stretchyHeaderContainer.updatePosition()
  }
  
  // MARK: - Configurations
  
  fileprivate func applyConfigurations() {
    configureNavigation()
    configureStretchyHeader()
  }
  
  fileprivate func configureStretchyHeader() {
    let shouldImageScale = selectedImage.size.width > 300 || selectedImage.size.height > 300
    
    // Configure header content
    stretchyTableHeaderContent = ClassificationTableHeaderView()
    stretchyTableHeaderContent.translatesAutoresizingMaskIntoConstraints = false
    stretchyTableHeaderContent.classificationImage = shouldImageScale ? selectedImage.scaleByPercentage(10) : selectedImage
    
    // Configure header container
    stretchyHeaderContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    stretchyHeaderContainer.scrollView = tableView
    stretchyHeaderContainer.frame = CGRect(
      x: 0,
      y: tableView.safeAreaInsets.top,
      width: view.frame.width,
      height: stretchyHeaderHeight)
    
    // Creates a new background view on the tableView to use as its background
    tableView.backgroundView = UIView()
    tableView.backgroundView?.addSubview(stretchyHeaderContainer)
    
    // Adjusts the contentInset of the tableView to expose the header
    tableView.contentInset = UIEdgeInsets(
      top: stretchyHeaderHeight,
      left: 0,
      bottom: 0,
      right: 0)
  }
  
  fileprivate func configureNavigation() {
    let iconSize: CGFloat = 18
    let closeIcon = UIImage(
      systemName: K.Icons.Close,
      withConfiguration: UIImage.SymbolConfiguration(
        pointSize: iconSize,
        weight: .semibold))
    let fullScreenIcon = UIImage(
      systemName: K.Icons.Enlarge,
      withConfiguration: UIImage.SymbolConfiguration(
        pointSize: iconSize,
        weight: .semibold))
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: closeIcon,
      style: .plain,
      target: self,
      action: #selector(handleCloseClassifier))
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: fullScreenIcon, style: .plain,
      target: self,
      action: #selector(handleFullScreenButton))
    navigationItem.backButtonTitle = ""
    navigationItem.titleView = confidenceButton
  }
  
  fileprivate func configureClassifier() {
    classifier.delegate = self
    beginClassification(of: selectedImage)
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

// MARK: - TrendClassifierDelegate

extension ClassificationViewController: TrendClassifierDelegate {
  
  func didFinishClassifying(_ sender: TrendClassifierManager?, results: inout [VNClassificationObservation]) {
    if !results.isEmpty {
      self.results = sanitizeClassificationResults(&results)
    } else {
      presentSimpleAlert(
        title: "Classification Error",
        message: "Failed to classify image. Please try another or try again later.",
        actionTitle: "Close")
    }
  }
  
  func didError(_ sender: TrendClassifierManager?, error: Error?) {
    if let error = error {
      switch error as! TrendClassifierError {
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

// MARK: - UIScrollViewDelegate

extension ClassificationViewController {
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    stretchyHeaderContainer.updatePosition()
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
    let topCell = tableView.dequeueReusableCell(
      withIdentifier: ClassificationTopResultCell.reuseIdentifier,
      for: indexPath) as! ClassificationTopResultCell
    let regularCell = tableView.dequeueReusableCell(
      withIdentifier: ClassificationResultCell.reuseIdentifier,
      for: indexPath) as! ClassificationResultCell
    
    let cell = indexPath.row == 0 ? topCell : regularCell
    let result = results?[indexPath.row]
    
    cell.resultData = result
    cell.accessoryType = .disclosureIndicator
    cell.contentView.layoutIfNeeded()
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let result = results?[indexPath.row]
    let category = TrendClassifierManager.shared.indentifiers[result!.identifier]
    let categoryViewController = CategoryViewController()
    
    categoryViewController.title = category
    categoryViewController.name = category
    categoryViewController.identifier = result?.identifier
    
    navigationController?.pushViewController(categoryViewController, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView(frame: .zero)
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return tableFooter
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return .leastNonzeroMagnitude
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return ClassificationResultCell.estimatedHeight
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
