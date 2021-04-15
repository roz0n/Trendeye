//
//  ClassifierViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

// TODO: Break up the header and footer views into their own files

final class ClassifierViewController: UITableViewController, TEClassifierDelegate {
    
    var classifier = TEClassifierManager()
    var tableHeader = ClassifierTableHeaderView()
    var photo: UIImage!
    
    var results: [VNClassificationObservation]? {
        didSet {
            print("Classification successful!")
        }
    }
    
    var tableViewFooter: UITextView = {
        let view = UITextView()
        view.text = "Powered by data from TrendList.org"
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textAlignment = .center
        view.textContainer.maximumNumberOfLines = 1
        view.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        view.textContainer.lineFragmentPadding = 0
        view.backgroundColor = .clear
        view.alpha = 0.35
        return view
    }()
    
    init(with photo: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.photo = photo
        overwriteTableStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyConfigurations()
        removePreviousViewController()
    }
    
    override func viewDidLoad() {
        classifier.delegate = self
        beginClassification(of: photo)
    }
    
    fileprivate func overwriteTableStyle() {
        let table = UITableView(frame: self.tableView.frame, style: .grouped)
        table.register(ClassifierResultCell.self, forCellReuseIdentifier: ClassifierResultCell.reuseIdentifier)
        self.tableView = table
    }
    
    fileprivate func applyConfigurations() {
        configureNavigation()
        configureStyles()
    }
    
    fileprivate func configureStyles() {
        view.backgroundColor = K.Colors.Background
        tableView.backgroundColor = K.Colors.Background
    }
    
    fileprivate func configureNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseClassifier))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleSaveClassification))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
    
    fileprivate func removePreviousViewController() {
        guard let navigationController = self.navigationController else { return }
        
        let controllerToRemove = "ConfirmationViewController"
        var allControllers = navigationController.viewControllers
        
        for (index, controller) in allControllers.enumerated() {
            let name = String(describing: type(of: controller))
            if name == controllerToRemove {
                allControllers.remove(at: index)
                navigationController.viewControllers = allControllers
                break
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassifierResultCell.reuseIdentifier, for: indexPath) as! ClassifierResultCell
        let result = results?[indexPath.row]
        
        cell.resultData = result
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = results?[indexPath.row]
        let category = TEClassifierManager.shared.indentifiers[result!.identifier]
        let categoryViewController = CategoryViewController()
        categoryViewController.title = category
        categoryViewController.name = category
        // TODO: This is a placeholder
        categoryViewController.descriptionText = "This typography trend consists of placing words on the sides of the format. Composition seems so avant-garde, but it has one major disadvantage. It forced people to read in four different directions. which can be fun, but not everytime. \n"
        navigationController?.pushViewController(categoryViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeader.tableHeaderPhoto.image = photo
        return tableHeader
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableViewFooter
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
    
    // MARK: - TEClassifierDelegate
    
    func didFinishClassifying(_ sender: TEClassifierManager?, results: [VNClassificationObservation]) {
        if !results.isEmpty {
            self.results = results
        } else {
            presentAlert(title: "Oh no", message: "Seems like something went wrong on our end. Sorry about that.", actionTitle: "Try again later")
        }
    }
    
    func didError(_ sender: TEClassifierManager?, error: Error?) {
        if let error = error {
            switch error as! TEClassifierError {
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
