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
        //        super.viewDidLoad()
        configureClassifier()
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
    
    fileprivate func applyConfigurations() {
        configureNavigation()
        configureStretchyHeader()
    }
    
    fileprivate func configureStretchyHeader() {
        // Configures header content
        let tableHeaderContent = ClassificationTableHeaderView()
        tableHeaderContent.translatesAutoresizingMaskIntoConstraints = false
        
        
        let targetSize = CGSize(width: 100, height: 100)
        
        let scaledImage = selectedImage.scaleByAspect(
            to: targetSize
        )
        
        tableHeaderContent.imageView.image = scaledImage
        
        // Configures header
        stretchHeaderContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stretchHeaderContainer.scrollView = tableView
        stretchHeaderContainer.frame = CGRect(
            x: 0,
            y: tableView.safeAreaInsets.top,
            width: view.frame.width,
            height: stretchHeaderHeight)
        
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
        let shareIcon = UIImage(
            systemName: K.Icons.Share,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: iconSize,
                                                           weight: .semibold))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: closeIcon,
            style: .plain,
            target: self,
            action: #selector(handleCloseClassifier))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: shareIcon, style: .plain,
            target: self,
            action: #selector(handleSaveClassification))
        navigationItem.backButtonTitle = ""
    }
    
    fileprivate func configureClassifier() {
        classifier.delegate = self
        beginClassification(of: selectedImage)
    }
    
    fileprivate func presentAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func beginClassification(of photo: UIImage) {
        guard let image = CIImage(image: photo) else { return }
        classifier.classifyImage(image)
    }
    
    // MARK: - Gestures
    
    @objc func handleCloseClassifier() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSaveClassification() {
        print("Tapped share!")
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ClassificationResultCell.reuseIdentifier,
            for: indexPath) as! ClassificationResultCell
        let result = results?[indexPath.row]
        
        cell.resultData = result
        cell.accessoryType = .disclosureIndicator
        
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
        return 72
    }
    
    // MARK: - TEClassificationDelegate Methods
    
    func didFinishClassifying(_ sender: TEClassificationManager?, results: [VNClassificationObservation]) {
        if !results.isEmpty {
            self.results = results
        } else {
            presentAlert(title: "Oh no",
                         message: "Seems like something went wrong on our end. Sorry about that.",
                         actionTitle: "Try again later")
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
