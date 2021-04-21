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
    
    let photoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        let icon = UIImage(systemName: K.Icons.Enlarge, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))!
        
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
        layoutPhotoView()
        layoutButton()
    }
    
    func layoutPhotoView() {
        addSubview(photoView)
        photoView.fillOther(view: self)
    }
    
    func layoutButton() {
        photoView.addSubview(enlargeButton)
        NSLayoutConstraint.activate([
            enlargeButton.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -20),
            enlargeButton.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: -20)
        ])
    }
    
}

