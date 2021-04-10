//
//  ConfirmationViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

final class ConfirmationViewController: UIViewController {
    
    var selectedPhoto: UIImage!
    var controlsView = ConfirmationControlsView()
    
    var photoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        applyAllConfigurations()
        applyAllGestures()
        applyAllLayouts()
    }
    
    fileprivate func applyAllConfigurations() {
        configurePhotoView()
    }
    
    fileprivate func configurePhotoView() {
        photoView.image = selectedPhoto
        photoView.contentMode = .scaleAspectFill
    }
    
    // MARK: - Gestures
    
    func applyAllGestures() {
        let acceptButton = controlsView.acceptButton
        let denyButton = controlsView.denyButton
        acceptButton?.addTarget(self, action: #selector(handleAcceptTap), for: .touchUpInside)
        denyButton?.addTarget(self, action: #selector(handleDenyTap), for: .touchUpInside)
    }
    
    @objc func handleAcceptTap() {
        // TODO: Kick over to the classifier view controller and proccess the image
        let classifierViewController = ClassifierViewController(with: selectedPhoto)
        present(classifierViewController, animated: true, completion: nil)
    }
    
    @objc func handleDenyTap() {
        // TODO: It appears that the capture session restarts when we do this. Not sure how to fix it at this time...
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Layout

fileprivate extension ConfirmationViewController {
    // TODO: These constraints will need work.
    // NOTE: Should this even be another view controller? Or should we just transform the CameraViewController to display new buttons?
    
    func applyAllLayouts() {
        layoutPhotoView()
        layoutControlsView()
    }
    
    func layoutPhotoView() {
        view.addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 510)
        ])
    }
    
    func layoutControlsView() {
        view.addSubview(controlsView)
        NSLayoutConstraint.activate([
            controlsView.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            controlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            controlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
