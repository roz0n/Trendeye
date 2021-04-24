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
        view.contentMode = .scaleAspectFit
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
        configureShadow()
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
    
    fileprivate func configureShadow() {
        photoView.layer.masksToBounds = false
        photoView.layer.shadowColor = K.Colors.Black!.cgColor
        photoView.layer.shadowOpacity = 0.5
        photoView.layer.shadowOffset = CGSize.zero
        photoView.layer.shadowRadius = 6
    }
    
}

// MARK: - Layout

fileprivate extension ClassificationTableHeaderView {
    
    func applyLayouts() {
        layoutPhotoView()
//        layoutButton()
    }
    
    func layoutPhotoView() {
        let xPadding: CGFloat = 10
        let yPadding: CGFloat = 20
        addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: yPadding),
            photoView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: xPadding),
            photoView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -(xPadding)),
            photoView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -(yPadding))
        ])
    }
    
//    func layoutButton() {
//        photoView.addSubview(enlargeButton)
//        NSLayoutConstraint.activate([
//            enlargeButton.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -20),
//            enlargeButton.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: -20)
//        ])
//    }
    
}

