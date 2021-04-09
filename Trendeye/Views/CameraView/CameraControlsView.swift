//
//  CameraControlsView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit

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
        stack.spacing = 0
        stack.distribution = .fillProportionally
        stack.backgroundColor = .systemYellow
        return stack
    }()
    
    var secondaryButtonsContainer: UIStackView = {
        /**
         Contains the "Flip" and "Flash" buttons
         */
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
    var previewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        return view
    }()
    
    var galleryThumbnail: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemYellow
        
        applyAllConfigurations()
        applyAllLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func applyAllConfigurations() {
        configureButtons()
        configureThumbnail()
    }
    
    fileprivate func configureButtons() {
        shootButton = CameraButton(type: .system)
        shootButton.setTitle("SH", for: .normal)
        shootButton.setTitleColor(.white, for: .normal)
        shootButton.backgroundColor = .systemBlue
        
        flipButton = CameraButton(type: .system)
        flipButton.setTitle("FL", for: .normal)
        flipButton.setTitleColor(.white, for: .normal)
        flipButton.backgroundColor = .systemRed
        
        flashButton = CameraButton(type: .system)
        flashButton.setTitle("FS", for: .normal)
        flashButton.setTitleColor(.white, for: .normal)
        flashButton.backgroundColor = .systemGreen
    }
    
    fileprivate func configureThumbnail() {
        galleryThumbnail.layer.cornerRadius = 24
        galleryThumbnail.layer.masksToBounds = true
    }
    
}

// MARK: - Layout

fileprivate extension CameraControlsView {
    
    func applyAllLayouts() {
        layoutContainers()
        layoutThumbnail()
        layoutButtons()
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
            primaryButtonsContainer.topAnchor.constraint(equalTo: self.topAnchor),
            primaryButtonsContainer.leadingAnchor.constraint(equalTo: previewContainer.trailingAnchor),
            primaryButtonsContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            primaryButtonsContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func layoutThumbnail() {
        previewContainer.addSubview(galleryThumbnail)
        NSLayoutConstraint.activate([
            galleryThumbnail.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor),
            galleryThumbnail.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 20),
            galleryThumbnail.heightAnchor.constraint(equalToConstant: 100),
            galleryThumbnail.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func layoutButtons() {
        secondaryButtonsContainer.addArrangedSubview(flipButton)
        secondaryButtonsContainer.addArrangedSubview(flashButton)
        primaryButtonsContainer.addArrangedSubview(shootButton)
        primaryButtonsContainer.addArrangedSubview(secondaryButtonsContainer)
        
        NSLayoutConstraint.activate([
            //            shootButton.heightAnchor.constraint(equalToConstant: 100),
                        shootButton.widthAnchor.constraint(equalToConstant: 100),
            //            flipButton.heightAnchor.constraint(equalToConstant: 50),
            //            flipButton.widthAnchor.constraint(equalToConstant: 50),
            //            flashButton.heightAnchor.constraint(equalToConstant: 50),
            //            flashButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
