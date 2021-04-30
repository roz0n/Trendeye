//
//  ClassificationViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

final class ClassificationViewController: UITableViewController, TEClassificationDelegate {
  
  var classifier = TEClassificationManager()
  var stretchHeaderContainer = StretchyTableHeaderView()
  var stretchHeaderHeight: CGFloat = 350
  var tableFooter = ClassificationTableFooterView()
  var selectedImage: UIImage!
  var results: [VNClassificationObservation]?
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    applyConfigurations()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureClassifier()
//    tableView.rowHeight = UITableView.automaticDimension
//    tableView.estimatedRowHeight = 70
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    stretchHeaderContainer.updatePosition()
  }
  
  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    tableView.contentInset = UIEdgeInsets(
      top: stretchHeaderHeight,
      left: 0,
      bottom: 0,
      right: 0)
    stretchHeaderContainer.updatePosition()
  }
  
  // MARK: - Configurations
  
  fileprivate func applyConfigurations() {
    configureNavigation()
    configureStretchyHeader()
  }
  
  fileprivate func configureStretchyHeader() {
    // Configures header content
    let tableHeaderContent = ClassificationTableHeaderView()
    let targetSize = CGSize(width: 200, height: 200)
    let scaledImage = selectedImage.scaleByAspect(to: targetSize)
    
    tableHeaderContent.translatesAutoresizingMaskIntoConstraints = false
    tableHeaderContent.classificationImage = selectedImage
    
    // Configures header
    stretchHeaderContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    stretchHeaderContainer.scrollView = tableView
    stretchHeaderContainer.frame = CGRect(
      x: 0,
      y: tableView.safeAreaInsets.top,
      width: view.frame.width,
      height: stretchHeaderHeight)
    
    // TODO: Move this to the Layout extension
    // Set header content constraints
    stretchHeaderContainer.addSubview(tableHeaderContent)
    NSLayoutConstraint.activate([
      tableHeaderContent.topAnchor.constraint(equalTo: stretchHeaderContainer.topAnchor),
      tableHeaderContent.leadingAnchor.constraint(equalTo: stretchHeaderContainer.leadingAnchor),
      tableHeaderContent.trailingAnchor.constraint(equalTo: stretchHeaderContainer.trailingAnchor),
      tableHeaderContent.bottomAnchor.constraint(equalTo: stretchHeaderContainer.bottomAnchor),
    ])
    
    // Creates a new background view on the tableView to use as its background
    tableView.backgroundView = UIView()
    tableView.backgroundView?.addSubview(stretchHeaderContainer)
    
    // Adjusts the contentInset of the tableView to expose the header
    tableView.contentInset = UIEdgeInsets(
      top: stretchHeaderHeight,
      left: 0,
      bottom: 0,
      right: 0)
  }
  
  fileprivate func configureNavigation() {
    let iconSize: CGFloat = 18
    let closeIcon = UIImage(
      systemName: K.Icons.Close,
      withConfiguration: UIImage.SymbolConfiguration(pointSize: iconSize,
                                                     weight: .semibold))
    let fullScreenIcon = UIImage(
      systemName: K.Icons.Enlarge,
      withConfiguration: UIImage.SymbolConfiguration(pointSize: iconSize,
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
  }
  
  fileprivate func configureClassifier() {
    classifier.delegate = self
    beginClassification(of: selectedImage)
  }
  
  // MARK: - Helpers
  
  fileprivate func beginClassification(of photo: UIImage) {
    guard let image = CIImage(image: photo) else { return }
    classifier.classifyImage(image)
  }
  
  // MARK: - Gestures
  
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
  
  // MARK: - UIScrollViewDelegate Methods
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    stretchHeaderContainer.updatePosition()
  }
  
  // MARK: - UITableView Methods
  
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
    let category = TEClassificationManager.shared.indentifiers[result!.identifier]
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
    return 120
  }
  
  // MARK: - TEClassificationDelegate Methods
  
  func didFinishClassifying(_ sender: TEClassificationManager?, results: [VNClassificationObservation]) {
    if !results.isEmpty {
      self.results = results
    } else {
      presentSimpleAlert(
        title: "Classification Error",
        message: "Failed to classify image. Please try another or try again later.",
        actionTitle: "Close")
    }
  }
  
  func didError(_ sender: TEClassificationManager?, error: Error?) {
    if let error = error {
      switch error as! TEClassificationError {
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
