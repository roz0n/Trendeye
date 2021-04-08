//
//  CameraControlsView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit

class CameraControlsView: UIView {
    
    // TODO: Move to its own file
    let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Shoot", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
        translatesAutoresizingMaskIntoConstraints = false
        configureButtonLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout

fileprivate extension CameraControlsView {
    
    func configureButtonLayout() {
        addSubview(cameraButton)
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 100),
            cameraButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
