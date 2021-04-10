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
        view.backgroundColor = .systemPink
        applyAllConfigurations()
        applyAllLayouts()
    }
    
    fileprivate func applyAllConfigurations() {
        configurePhotoView()
    }
    
    fileprivate func configurePhotoView() {
        photoView.image = selectedPhoto
        photoView.contentMode = .scaleAspectFill
    }
    
}

// MARK: - Layout

fileprivate extension ConfirmationViewController {
    
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
            photoView.heightAnchor.constraint(equalToConstant: 545)
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
