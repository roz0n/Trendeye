//
//  ClassifierTableHeaderView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit

class ClassifierTableHeaderView: UIStackView {
    
    var tableHeaderPhoto: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var tableHeaderDescription: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.backgroundColor = .white
        return stack
    }()
    
    var descriptionHeader: UILabel = {
        let label = UILabel()
        label.text = "About the analysis"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var descriptionText: UITextView = {
        let view = UITextView()
        view.text = "Duis hendrerit molestie velit sit amet gravida. Cras faucibus tincidunt erat, quis tristique arcu pharetra ut."
        view.textContainer.maximumNumberOfLines = 0
        view.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        view.textContainer.lineFragmentPadding = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        applyConfigurations()
        applyLayouts()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func applyConfigurations() {
        configureTableHeaderDescription()
    }
    
    fileprivate func configureTableHeaderDescription() {
        tableHeaderDescription.addArrangedSubview(descriptionHeader)
        tableHeaderDescription.addArrangedSubview(descriptionText)
        
        // NOTE: This will clip with a dynamic type size as the table header is statically sized and should be dynamically sized
        tableHeaderDescription.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        tableHeaderDescription.isLayoutMarginsRelativeArrangement = true
    }
    
}

// MARK: - Layout

fileprivate extension ClassifierTableHeaderView {
    
    func applyLayouts() {
        layoutHeaderDescription()
    }
    
    func layoutHeaderDescription() {
        addArrangedSubview(tableHeaderPhoto)
        addArrangedSubview(tableHeaderDescription)
        tableHeaderDescription.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}

