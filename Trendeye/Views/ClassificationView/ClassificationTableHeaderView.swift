//
//  ClassificationTableHeaderView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit

class ClassificationTableHeaderView: UIView {
    
    let buttonSize: CGFloat = 55
    var enlargeButton: PhotoEnlargeButton!
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyConfigurations()
        applyLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    fileprivate func applyConfigurations() {
        configureButton()
    }
    
    fileprivate func configureButton() {
        let title = "Enlarge Classifier Photo"
        let icon = UIImage(
            systemName: K.Icons.Enlarge,
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 24,
                weight: .bold))!
        
        enlargeButton = PhotoEnlargeButton(height: 55, width: 55)
        enlargeButton.setTitle(title, for: .application)
        enlargeButton.backgroundColor = K.Colors.White
        enlargeButton.setImage(icon, for: .normal)
        enlargeButton.tintColor = K.Colors.Black
    }
    
}

// MARK: - Layout

fileprivate extension ClassificationTableHeaderView {
    
    func applyLayouts() {
        layoutImageView()
        layoutButton()
    }
    
    func layoutImageView() {
        let xPadding: CGFloat = 10
        let yPadding: CGFloat = 20
        addSubview(imageView)
//        imageView.frame = self.frame
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: yPadding),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xPadding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(xPadding)),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(yPadding))
        ])
    }
    
    func layoutButton() {
        let padding: CGFloat = 20
        imageView.addSubview(enlargeButton)
        NSLayoutConstraint.activate([
            enlargeButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(padding)),
            enlargeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -(padding))
        ])
    }
    
}

