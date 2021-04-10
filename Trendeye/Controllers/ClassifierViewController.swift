//
//  ClassifierViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

final class ClassifierViewController: UIViewController, TEClassifierDelegate {
    
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
    
    override func viewDidLoad() {
        view.backgroundColor = .systemIndigo
        classifier.delegate = self
        beginClassification(of: photo)
    }
    
    // MARK: - Classification Helpers
    
    fileprivate func beginClassification(of photo: UIImage) {
        guard let image = CIImage(image: photo) else { return }
        classifier.classifyImage(image)
    }
    
    // MARK: - TEClassifierDelegate
    
    func didFinishClassifying(_ sender: TEClassifierManager?, results: [VNClassificationObservation]) {
        print("Finished classifying image!")
        
        if !results.isEmpty {
            self.results = results
            
            results.forEach({
                print("Identifier: \($0.identifier)   ||   Confidence: \($0.confidence)")
            })
        } else {
            // Present something as results came back empty... maybe a UIAlert?
        }
        
        // TODO: Update view controller to present results
    }
    
    func didError(_ sender: TEClassifierManager?, error: Error?) {
        print("Error, failed to classify image.")
        
        if let error = error {
            switch error as! TEClassifierError {
                case .modelError:
                    print("Failed to initialize model")
                case .classificationError:
                    print("Vision request failed")
                case .handlerError:
                    print("Image request handler failed")
            }
        }
    }
    
}
