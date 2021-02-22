//
//  ViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 2/21/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    let displayImage: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPurple
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        configureLayout()
        configureGestures()
    }
    
}

// MARK: - Image Picker Controller Delegate

extension ViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            displayImage.image = image
            
            guard let userImage = CIImage(image: image) else {
                fatalError("Failure converting image")
            }
            
            processImage(userImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func processImage(_ image: CIImage) {
        // TODO: Check the init method for the model and reafactor this method
        guard let model = try? VNCoreMLModel(for: TrendClassifier(configuration: MLModelConfiguration.init()).model) else {
            fatalError("Failure loading CoreML model")
        }
        
        let visionReq = VNCoreMLRequest(model: model) { (request, error) in
            if error != nil {
                print("Error processing image")
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            print("Results: \(results)")
        }
        
        let visionHandler = VNImageRequestHandler(ciImage: image)
        
        do {
            try visionHandler.perform([visionReq])
        } catch {
            print("Error classifying image")
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
        present(imagePicker, animated: true, completion: nil)
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
