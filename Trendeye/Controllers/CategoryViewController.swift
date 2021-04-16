//
//  CategoryViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var name: String!
    var descriptionText: String?
    
    var headerContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    var categoryDescriptionView: UITextView = {
        let view = UITextView()
        view.textContainer.maximumNumberOfLines = 0
        view.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.sizeToFit()
        view.isScrollEnabled = false
        return view
    }()
    
    var sourceLabel: UILabel = {
        let label = UILabel()
        label.text = "Source: TrendList.org"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.alpha = 0.35
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        applyConfigurations()
    }
    
    override func viewDidLoad() {
        applyLayouts()
    }
    
    fileprivate func applyConfigurations() {
        configureNavigation()
        configureDescription()
    }
    
    fileprivate func configureNavigation() {
        view.backgroundColor = K.Colors.ViewBackground
    }
    
    fileprivate func configureDescription() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        categoryDescriptionView.attributedText = NSMutableAttributedString(
            string: descriptionText ?? "No description available",
            attributes: [
                NSAttributedString.Key.kern : -0.15,
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)])
    }
    
}

// MARK: - Layout

fileprivate extension CategoryViewController {
    
    func applyLayouts() {
        layoutDescription()
    }
    
    func layoutDescription() {
        view.addSubview(headerContainer)
        headerContainer.addArrangedSubview(categoryDescriptionView)
        headerContainer.addArrangedSubview(sourceLabel)
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            headerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 14),
            headerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -14)
        ])
    }
    
}

