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
  
  var classifier = TEClassificationManager()
  var confidenceButton = ClassifierConfidenceButton(type: .system)
  var topResultMetric: TEClassificationMetric?
  
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
      
      topResultMetric = TEClassificationManager.shared.getClassificationMetric(for: topResult)
      confidenceButton.classificationMetric = topResultMetric
    }
  }
  
  var resultIdentifiers: [String]? {
    guard let results = results else {
      return []
    }
    
    let allIdentifiers = results.map { $0.identifier }
    return TEClassificationManager.shared.indentifiers.filter { allIdentifiers.contains($0.key) }.map { $0.value }
  }
  
  // MARK: - UI Properties
  
  var selectedImage: UIImage!
  var stretchyHeaderContainer = StretchyTableHeaderView()
  var stretchyHeaderHeight: CGFloat = 350
  var stretchyTableHeaderContent = ClassificationImageHeader()
  var tableFooter = ClassificationTableFooterView()
  
  var aboutView: InfoModalViewController = {
    let view = InfoModalViewController(iconSymbol: K.Icons.Analysis, titleText: "About Analysis", bodyText: "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. Nullam non ante nisi. Quisque ante quam, ornare nec est sed, facilisis fermentum sapien. Aliquam non dui at mi tincidunt dignissim.", buttonText: "Close")
    view.modalPresentationStyle = .formSheet
    view.modalTransitionStyle = .crossDissolve
    return view
  }()
  
  var confidenceView: InfoModalViewController = {
    let view = InfoModalViewController(iconSymbol: K.Icons.Classifier, titleText: "Confidence", bodyText: "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. Nullam non ante nisi.", buttonText: "Close")
    view.modalPresentationStyle = .formSheet
    view.modalTransitionStyle = .crossDissolve
    return view
  }()
  
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
    tableView.backgroundColor = K.Colors.Background
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
    configureConfidenceButtonGesture()
    configureConfidenceView()
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
    stretchyTableHeaderContent.classificationImage = shouldImageScale ? selectedImage.scaleToPercent(10) : selectedImage
    
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
  
  fileprivate func configureConfidenceView() {
    confidenceView.bodyContent = getConfidenceMetricsListItems()
  }
  
  fileprivate func configureConfidenceButtonGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedConfidenceButton))
    confidenceButton.addGestureRecognizer(tapGesture)
  }
  
  fileprivate func configureAboutButtonGesture(button: UIButton) {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAboutButton))
    button.addGestureRecognizer(tapGesture)
  }
  
  func configurePositiveFeedbackGesture(button: UIButton) {
    let positiveFeedbackGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPositiveFeedback))
    button.addGestureRecognizer(positiveFeedbackGesture)
  }
  
  func configureNegativeFeedbackGesture(button: UIButton) {
    let negativeFeedbackGesture = UITapGestureRecognizer(target: self, action: #selector(tappedNegativeFeedback))
    button.addGestureRecognizer(negativeFeedbackGesture)
  }
  
  // MARK: - Gestures
  
  @objc func tappedConfidenceButton() {
    present(confidenceView, animated: true, completion: nil)
  }
  
  @objc func tappedAboutButton() {
    present(aboutView, animated: true, completion: nil)
  }
  
  @objc func tappedPositiveFeedback() {
    guard results != nil else {
      return
    }
    
    let positiveFeedbackController = FeedbackViewController(
      type: .positive,
      for: results!,
      classificationIdentifiers: resultIdentifiers,
      classificationImage: selectedImage)
    
    positiveFeedbackController.modalPresentationStyle = .formSheet
    positiveFeedbackController.modalTransitionStyle = .crossDissolve
    
    present(positiveFeedbackController, animated: true, completion: nil)
  }
  
  @objc func tappedNegativeFeedback() {
    guard let resultIdentifiers = resultIdentifiers, results != nil else {
      return
    }
    
    let negativeFeedbackController = FeedbackViewController(
      type: .negative,
      for: results!,
      classificationIdentifiers: resultIdentifiers,
      classificationImage: selectedImage)
    
    negativeFeedbackController.modalPresentationStyle = .formSheet
    negativeFeedbackController.modalTransitionStyle = .crossDissolve
    
    present(negativeFeedbackController, animated: true, completion: nil)
  }
  
  // MARK: - Helpers
  
  fileprivate func getConfidenceMetricsListItems() -> UIStackView {
    let container = UIStackView()
    
    container.translatesAutoresizingMaskIntoConstraints = false
    container.axis = .vertical
    container.spacing = 20
    
    container.addArrangedSubview(InfoListItemView(iconSymbol: K.Icons.ArrowUpSquare, iconColor: K.Colors.Green, headerText: "High Confidence", bodyText: "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. "))
    container.addArrangedSubview(InfoListItemView(iconSymbol: K.Icons.ArrowMidSquare, iconColor: K.Colors.Yellow, headerText: "Mild Confidence", bodyText: "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. "))
    container.addArrangedSubview(InfoListItemView(iconSymbol: K.Icons.ArrowDownSquare, iconColor: K.Colors.Red, headerText: "Low Confidence", bodyText: "Etiam sit amet urna a dolor iaculis hendrerit at id sapien. "))
    
    return container
  }
  
  fileprivate func getNavigationBackgroundColor(metric: TEClassificationMetric) -> UIColor? {
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
    navigationController?.navigationBar.tintColor = K.Colors.Foreground
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

extension ClassificationViewController: TEClassificationDelegate {
  
  func didFinishClassifying(_ sender: TEClassificationManager?, results: inout [VNClassificationObservation]) {
    if !results.isEmpty {
      self.results = sanitizeClassificationResults(&results)
    } else {
      presentSimpleAlert(title: "Classification Error", message: "Failed to classify image. Please try another or try again later.", actionTitle: "Close")
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
    cell.selectionStyle = .none
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ClassificationTableHeader.reuseIdentifier) as! ClassificationTableHeader
    
    configureAboutButtonGesture(button: cell.primaryButton)
    configurePositiveFeedbackGesture(button: cell.positiveFeedbackButton)
    configureNegativeFeedbackGesture(button: cell.negativeFeedbackButton)
    
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
    let fullScreenImageView = FullImageViewController()
    
    fullScreenImageView.modalPresentationStyle = .formSheet
    fullScreenImageView.modalTransitionStyle = .crossDissolve
    fullScreenImageView.image = selectedImage
    
    present(fullScreenImageView, animated: true, completion: nil)
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
