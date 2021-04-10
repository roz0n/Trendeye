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
        stack.distribution = .equalSpacing
        stack.backgroundColor = .systemPurple
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray
        applyAllConfigurations()
        applyAllLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    fileprivate func applyAllConfigurations() {
        configureButtons()
    }
    
    fileprivate func configureButtons() {
        acceptButton = ConfirmationButton(type: .system)
        acceptButton.setTitle("YES", for: .normal)
        denyButton = ConfirmationButton(type: .system)
        denyButton.setTitle("NO", for: .normal)
    }
    
}

// MARK: - Layout

fileprivate extension ConfirmationControlsView {
    
    func applyAllLayouts() {
        layoutButtons()
    }
    
    func layoutButtons() {
        buttonsContainer.addArrangedSubview(acceptButton)
        buttonsContainer.addArrangedSubview(denyButton)
        addSubview(buttonsContainer)
        buttonsContainer.fillOther(view: self)
    }
    
}

