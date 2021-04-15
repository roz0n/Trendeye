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
        return view
    }()
    
    override func viewDidLoad() {
        applyConfigurations()
        applyGestures()
        applyLayouts()
    }
    
    fileprivate func applyConfigurations() {
        configureNavigation()
        configurePhotoView()
        configureStyles()
    }
    
    fileprivate func configureStyles() {
        view.backgroundColor = K.Colors.NavigationBar
    }
    
    fileprivate func configureNavigation() {
        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func configurePhotoView() {
        photoView.image = selectedPhoto
        photoView.contentMode = .scaleAspectFill
    }
    
    // MARK: - Gestures
    
    func applyGestures() {
        let acceptButton = controlsView.acceptButton
        let denyButton = controlsView.denyButton
        acceptButton?.addTarget(self, action: #selector(handleAcceptTap), for: .touchUpInside)
        denyButton?.addTarget(self, action: #selector(handleDenyTap), for: .touchUpInside)
    }
    
    @objc func handleAcceptTap() {
        let classifierViewController = ClassifierViewController(with: selectedPhoto)
        classifierViewController.navigationItem.hidesBackButton = true
        classifierViewController.title = "Trend Analysis"
        classifierViewController.navigationItem.backButtonTitle = "Back"
        navigationController?.pushViewController(classifierViewController, animated: true)
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
    
    func applyLayouts() {
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
