//
//  ResultsPanel.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 2/21/21.
//

import UIKit

class ResultsPanel: UIView {
    
    var categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "Result"
        return categoryLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemTeal
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout

private extension ResultsPanel {
    
    func configureLayout() {
        addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: self.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
}
