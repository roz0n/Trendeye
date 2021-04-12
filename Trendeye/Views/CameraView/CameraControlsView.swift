//
//  CameraControlsView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit

class CameraControlsView: UIView {
    
    var shootButton: CameraButton!
    var flipButton: CameraButton!
    var flashButton: CameraButton!
    
    var primaryButtonsContainer: UIStackView = {
        /**
         Contains the "Shoot" button
         */
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .equalCentering
        return stack
    }()
    
    var secondaryButtonsContainer: UIStackView = {
        /**
         Contains the "Flip" and "Flash" buttons
         */
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
    }()
    
    var previewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var galleryButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        let icon = UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
//        button.backgroundColor = UIColor(red: 0.094, green: 0.094, blue: 0.094, alpha: 0.35)
        button.setImage(icon, for: .normal)
        return button
    }()
    
    fileprivate func applyConfigurations() {
        configureButtons()
        configureThumbnail()
    }
    
    fileprivate func configureButtons() {
        // TODO: Refactor
        let shootButtonIcon = UIImage(systemName: "camera.fill",
                                      withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        let flipButtonIcon = UIImage(systemName: "arrow.triangle.2.circlepath",
                                     withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy))
        let flashButtonIcon = UIImage(systemName: "bolt.slash.fill",
                                      withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy))
        
        shootButton = CameraButton(type: .system)
        shootButton.setTitle("Shoot", for: .application)
        shootButton.setTitleColor(.white, for: .normal)
        shootButton.backgroundColor = UIColor(red: 0.094, green: 0.094, blue: 0.094, alpha: 0.35)
        shootButton.setImage(shootButtonIcon, for: .normal)
        shootButton.tintColor = .white
        
        flipButton = CameraButton(type: .system)
        flipButton.setTitle("Flip", for: .application)
        flipButton.setTitleColor(.white, for: .normal)
        flipButton.backgroundColor = UIColor(red: 0.094, green: 0.094, blue: 0.094, alpha: 0.35)
        flipButton.setImage(flipButtonIcon, for: .normal)
        flipButton.tintColor = .white
        
        flashButton = CameraButton(type: .system)
        flashButton.setTitle("Flash", for: .application)
        flashButton.setTitleColor(.white, for: .normal)
        flashButton.backgroundColor = UIColor(red: 0.094, green: 0.094, blue: 0.094, alpha: 0.35)
        flashButton.setImage(flashButtonIcon, for: .normal)
        flashButton.tintColor = .white
    }
    
    fileprivate func configureThumbnail() {
//        galleryButton.layer.cornerRadius = 24
//        galleryButton.layer.masksToBounds = true
//        galleryButton.makeCircular()
//        galleryButton.backgroundColor = UIColor(red: 0.094, green: 0.094, blue: 0.094, alpha: 0.35)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        applyConfigurations()
        applyLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout

fileprivate extension CameraControlsView {
    // These constraints are a but wonky, but they work for now
    
    func applyLayouts() {
        layoutContainers()
        layoutGalleryButton()
        layoutCameraButtons()
    }
    
    func layoutContainers() {
        let screenWidth = UIScreen.main.bounds.width
        let halfScreenWidth = (screenWidth / 2)
        
        addSubview(previewContainer)
        addSubview(primaryButtonsContainer)
        
        NSLayoutConstraint.activate([
            previewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            previewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            previewContainer.widthAnchor.constraint(equalToConstant: halfScreenWidth),
            previewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            primaryButtonsContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            primaryButtonsContainer.leadingAnchor.constraint(equalTo: previewContainer.trailingAnchor),
            primaryButtonsContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
    
    func layoutGalleryButton() {
        previewContainer.addSubview(galleryButton)
        NSLayoutConstraint.activate([
            galleryButton.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor),
            galleryButton.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor),
            galleryButton.heightAnchor.constraint(equalToConstant: 100),
            galleryButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func layoutCameraButtons() {
        secondaryButtonsContainer.addArrangedSubview(flipButton)
        secondaryButtonsContainer.addArrangedSubview(flashButton)
        primaryButtonsContainer.addArrangedSubview(shootButton)
        primaryButtonsContainer.addArrangedSubview(secondaryButtonsContainer)

        NSLayoutConstraint.activate([
            shootButton.heightAnchor.constraint(equalToConstant: 100),
            shootButton.widthAnchor.constraint(equalToConstant: 100),
            flipButton.heightAnchor.constraint(equalToConstant: 42),
            flipButton.widthAnchor.constraint(equalToConstant: 42),
            flashButton.heightAnchor.constraint(equalToConstant: 42),
            flashButton.widthAnchor.constraint(equalToConstant: 42),
        ])
    }
    
}
