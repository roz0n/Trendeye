//
//  ClassifierViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

final class ClassifierViewController: UITableViewController, TEClassifierDelegate {
    
    var classifier = TEClassifierManager()
    var photo: UIImage!
    
    var results: [VNClassificationObservation]? {
        didSet {
            print("Classification successful!")
        }
    }
    
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
    }
    
    fileprivate func configureNavigationItems() {
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(handleCloseClassifier))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleSaveClassification))
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
        var allControllers = navigationController.viewControllers
        allControllers.remove(at: (allControllers.count - 2 ))
        navigationController.viewControllers = allControllers
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
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
