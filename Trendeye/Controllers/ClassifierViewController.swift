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
    var photo: UIImage!
    
    var results: [VNClassificationObservation]? {
        didSet {
            print("Classification successful!")
        }
    }
    
    var tableHeaderContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    var tableHeaderPhoto: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var tableHeaderDescription: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.backgroundColor = .white
        return stack
    }()
    
    var descriptionHeader: UILabel = {
        let label = UILabel()
        label.text = "About the analysis"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var descriptionText: UITextView = {
        let view = UITextView()
        view.text = "Duis hendrerit molestie velit sit amet gravida. Cras faucibus tincidunt erat, quis tristique arcu pharetra ut."
        view.textContainer.maximumNumberOfLines = 0
        view.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        view.textContainer.lineFragmentPadding = 0
        return view
    }()
    
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
        super.viewDidLoad()
        classifier.delegate = self
        beginClassification(of: photo)
    }
    
    fileprivate func overwriteTableStyle() {
        let table = UITableView(frame: self.tableView.frame, style: .grouped)
        table.register(ClassifierResultCell.self, forCellReuseIdentifier: ClassifierResultCell.reuseIdentifier)
        self.tableView = table
    }
    
    fileprivate func applyConfigurations() {
        configureNavigationItems()
        configureTableHeaderDescription()
    }
    
    fileprivate func configureNavigationItems() {
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(handleCloseClassifier))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleSaveClassification))
    }
    
    fileprivate func configureTableHeaderDescription() {
        tableHeaderDescription.addArrangedSubview(descriptionHeader)
        tableHeaderDescription.addArrangedSubview(descriptionText)
        
        // NOTE: This will clip with a dynamic type size as the table header is statically sized and should be dynamically sized
        tableHeaderDescription.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        tableHeaderDescription.isLayoutMarginsRelativeArrangement = true
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
        let category = TEClassifierIdentityLabels[result!.identifier]
        let categoryViewController = CategoryViewController()
        
        categoryViewController.title = category
        categoryViewController.categoryName = category
        navigationController?.pushViewController(categoryViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeaderPhoto.image = photo
        tableHeaderContainer.addArrangedSubview(tableHeaderPhoto)
        tableHeaderContainer.addArrangedSubview(tableHeaderDescription)
        tableHeaderDescription.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return tableHeaderContainer
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableViewFooter
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
