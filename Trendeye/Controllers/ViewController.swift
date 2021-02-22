//
//  ViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 2/21/21.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TEClassifierDelegate {
    
    let classifier = TEClassifierManager()
    let picker = UIImagePickerController()
    
    var results: [VNClassificationObservation]? {
        didSet {
            print("Classification successful")
        }
    }
    
    let displayImage: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPurple
        
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        classifier.delegate = self
        
        configureLayout()
        configureGestures()
    }
    
}

// MARK: - Image Picker Controller Delegate

extension ViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            displayImage.image = image
        }
        
        guard let userImage = CIImage(image: displayImage.image!) else {
            fatalError("Failure converting image")
        }
        
        picker.dismiss(animated: true, completion: nil)
        classifier.processImage(userImage)
    }
    
}

// MARK: - Classifier Delegate

extension ViewController {
    
    func didFinishProcessing(_: TEClassifierManager?, results: [VNClassificationObservation]) {
        if !results.isEmpty {
            self.results = results
        }
    }
    
    func didError(_: TEClassifierManager?, error: Error?) {
        switch error as! TEClassifierError {
            case .modelError:
                print("Failed to initialize model")
            case .processError:
                print("Vision request failed")
            case .handlerError:
                print("Image request handler failed")
        }
    }
    
}

// MARK: - Gestures

private extension ViewController {
    
    func configureGestures() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func cameraButtonTapped() {
        present(picker, animated: true, completion: nil)
    }
    
}

// MARK: - Layout

private extension ViewController {
    
    func configureLayout() {
        view.addSubview(displayImage)
        NSLayoutConstraint.activate([
            displayImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            displayImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            displayImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            displayImage.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
    
}
