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
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillProportionally
        stack.backgroundColor = .systemYellow
        return stack
    }()
    
    var secondaryButtonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 1
        stack.distribution = .fillEqually
        return stack
    }()
    
    var previewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemTeal
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
        backgroundColor = .systemGreen
        translatesAutoresizingMaskIntoConstraints = false
        
        configureButtons()
        applyAllLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtons() {
        shootButton = CameraButton(type: .system)
        flipButton = CameraButton(type: .system)
        flashButton = CameraButton(type: .system)
        
        shootButton.setTitle("Shoot", for: .normal)
        shootButton.setTitleColor(.white, for: .normal)
        shootButton.backgroundColor = .systemBlue
        
        flipButton.setTitle("Flip", for: .normal)
        flipButton.setTitleColor(.white, for: .normal)
        flipButton.backgroundColor = .systemRed
        
        flashButton.setTitle("Flash", for: .normal)
        flashButton.setTitleColor(.white, for: .normal)
        flashButton.backgroundColor = .systemRed
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
        addSubview(previewContainer)
        addSubview(primaryButtonsContainer)
        
        NSLayoutConstraint.activate([
            previewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            previewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            previewContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            previewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            primaryButtonsContainer.topAnchor.constraint(equalTo: self.topAnchor),
            primaryButtonsContainer.leadingAnchor.constraint(equalTo: previewContainer.trailingAnchor),
            primaryButtonsContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            primaryButtonsContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func layoutThumbnail() {
        previewContainer.addSubview(galleryThumbnail)
        
        NSLayoutConstraint.activate([
            galleryThumbnail.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
            galleryThumbnail.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor),
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
            
        ])
    }
    
}
