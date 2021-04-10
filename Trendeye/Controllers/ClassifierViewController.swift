//
//  ClassifierViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

// TODO: On second thought, this whole thing needs to be a UITableViewController... ugh

final class ClassifierViewController: UIViewController, UIScrollViewDelegate, TEClassifierDelegate {
    
    var classifier = TEClassifierManager()
    var photo: UIImage!
    
    var scrollContainer: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .systemIndigo
        return view
    }()
    
    var photoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        return view
    }()
    
    var results: [VNClassificationObservation]? {
        didSet {
            print("Classification successful")
        }
    }
    
    init(with photo: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.photo = photo
        photoView.image = photo
        photoView.contentMode = .scaleAspectFill
        configureScrollView()
        applyLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyConfigurations()
        removePreviousViewController()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
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
    
    fileprivate func configureScrollView() {
        scrollContainer.delegate = self
        scrollContainer.isScrollEnabled = true
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

// MARK: - Layout

fileprivate extension ClassifierViewController {
    
    func applyLayouts() {
        layoutPhotoView()
    }
    
    func layoutPhotoView() {
        view.addSubview(scrollContainer)
        scrollContainer.frame = self.view.bounds
        scrollContainer.addSubview(photoView)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 240),
            photoView.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor)
        ])
    }
    
}

