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
    var tableHeader = ClassificationTableHeaderView()
    var tableFooter = ClassificationTableFooterView()
    var photo: UIImage!
    var results: [VNClassificationObservation]?
    
    init(with photo: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.photo = photo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyStyles()
        applyConfigurations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classifier.delegate = self
        beginClassification(of: photo)
    }
    
    fileprivate func applyStyles() {
        overwriteTableStyles()
        view.backgroundColor = K.Colors.ViewBackground
        tableView.backgroundColor = K.Colors.ViewBackground
    }
    
    fileprivate func overwriteTableStyles() {
        let table = UITableView(frame: self.tableView.frame, style: .grouped)
        table.register(ClassificationResultCell.self, forCellReuseIdentifier: ClassificationResultCell.reuseIdentifier)
        tableView = table
    }
    
    fileprivate func applyConfigurations() {
        configureNavigation()
    }
    
    fileprivate func configureNavigation() {
        let iconSize: CGFloat = 18
        let closeIcon = UIImage(systemName: K.Icons.Close, withConfiguration: UIImage.SymbolConfiguration(pointSize: iconSize, weight: .semibold))
        let shareIcon = UIImage(systemName: K.Icons.Share, withConfiguration: UIImage.SymbolConfiguration(pointSize: iconSize, weight: .semibold))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(handleCloseClassifier))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: shareIcon, style: .plain, target: self, action: #selector(handleSaveClassification))
        navigationItem.backButtonTitle = ""
    }
    
    @objc func handleCloseClassifier() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSaveClassification() {
        print("Tapped share!")
    }
    
    fileprivate func presentAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func beginClassification(of photo: UIImage) {
        guard let image = CIImage(image: photo) else { return }
        classifier.classifyImage(image)
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassificationResultCell.reuseIdentifier, for: indexPath) as! ClassificationResultCell
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
        tableHeader.photoView.image = photo
        return tableHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableFooter
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
    
    // MARK: - TEClassificationDelegate
    
    func didFinishClassifying(_ sender: TEClassificationManager?, results: [VNClassificationObservation]) {
        if !results.isEmpty {
            self.results = results
        } else {
            presentAlert(title: "Oh no", message: "Seems like something went wrong on our end. Sorry about that.", actionTitle: "Try again later")
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
