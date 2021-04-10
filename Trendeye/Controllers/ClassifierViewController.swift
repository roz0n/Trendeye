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
            print("Classification successful")
        }
    }
    
    init(with photo: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.photo = photo
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(ClassifierResultCell.self, forCellReuseIdentifier: ClassifierResultCell.reuseIdentifier)
        tableView.backgroundColor = .systemIndigo
        
        classifier.delegate = self
        beginClassification(of: photo)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassifierResultCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        
    // MARK: - TEClassifierDelegate
    
    func didFinishClassifying(_ sender: TEClassifierManager?, results: [VNClassificationObservation]) {
        print("Completed image classification!")
        
        if !results.isEmpty {
            self.results = results
            results.forEach({
                print("Identifier: \($0.identifier)   ||   Confidence: \($0.confidence)")
            })
        } else {
            presentAlert(title: "Oh no", message: "Seems like something went wrong on our end. Sorry about that.", actionTitle: "Try again later")
        }
        
        // TODO: Update view controller to present results
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
