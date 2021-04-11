//
//  ClassifierResultCell.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/10/21.
//

import UIKit
import Vision

class ClassifierResultCell: UITableViewCell {
    
    static let reuseIdentifier = "ClassifierResultCell"
    var resultData: VNClassificationObservation!
    
    var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.backgroundColor = .systemTeal
        return stack
    }()
    
    var identifierLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGreen
        return label
    }()
    
    var confidenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemRed
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyAllLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout

fileprivate extension ClassifierResultCell {
    
    func applyAllLayouts() {
        layoutContainer()
        layoutLabels()
    }
    
    func layoutContainer() {
        contentView.addSubview(contentContainer)
        contentContainer.fillOther(view: contentView)
    }
    
    func layoutLabels() {
        // TODO: Move to constants
        let cellHeight: CGFloat = 72
        contentContainer.addArrangedSubview(identifierLabel)
        contentContainer.addArrangedSubview(confidenceLabel)
        NSLayoutConstraint.activate([
            identifierLabel.heightAnchor.constraint(equalToConstant: cellHeight),
            confidenceLabel.heightAnchor.constraint(equalToConstant: cellHeight),
            confidenceLabel.widthAnchor.constraint(equalToConstant: 82)
        ])
    }
    
}

