//
//  ConfirmationControlsView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

class ConfirmationControlsView: UIView {
    
    var acceptButton: ConfirmationButton!
    var denyButton: ConfirmationButton!
    
    var buttonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        applyConfigurations()
        applyLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    fileprivate func applyConfigurations() {
        configureButtons()
        configureStyles()
    }
    
    fileprivate func configureStyles() {
        backgroundColor = K.Colors.Background
    }
    
    fileprivate func configureButtons() {
        // TODO: Refactor
        let acceptButtonIcon = UIImage(systemName: "hand.thumbsup.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        let denyButtonIcon = UIImage(systemName: "hand.thumbsdown.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        
        acceptButton = ConfirmationButton(type: .system)
        acceptButton.setTitle("Accept", for: .application)
        acceptButton.backgroundColor = K.Colors.Green
        acceptButton.setImage(acceptButtonIcon, for: .normal)
        acceptButton.tintColor = K.Colors.Black
        
        
        denyButton = ConfirmationButton(type: .system)
        denyButton.setTitle("Deny", for: .application)
        denyButton.backgroundColor = K.Colors.Red
        denyButton.setImage(denyButtonIcon, for: .normal)
        denyButton.tintColor = K.Colors.Black
    }
    
}

// MARK: - Layout

fileprivate extension ConfirmationControlsView {
    
    func applyLayouts() {
        layoutButtons()
    }
    
    func layoutButtons() {
        buttonsContainer.addArrangedSubview(denyButton)
        buttonsContainer.addArrangedSubview(acceptButton)
        addSubview(buttonsContainer)
        NSLayoutConstraint.activate([
            buttonsContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            buttonsContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            buttonsContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}

