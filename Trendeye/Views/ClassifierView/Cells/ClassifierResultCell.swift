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
    
    var resultData: VNClassificationObservation! {
        didSet {
            identifierLabel.text = TEClassifierManager.shared.indentifiers[resultData.identifier]
            confidenceLabel.text = "\(TEClassifierManager.shared.convertConfidenceToPercent(resultData.confidence))%"
        }
    }
    
    var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    var identifierLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        label.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return label
    }()
    
    var confidenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout

fileprivate extension ClassifierResultCell {
    
    func applyLayouts() {
        layoutContainer()
        layoutLabels()
    }
    
    func layoutContainer() {
        contentView.addSubview(contentContainer)
        contentContainer.fillOther(view: contentView)
    }
    
    func layoutLabels() {
        contentContainer.addArrangedSubview(identifierLabel)
        contentContainer.addArrangedSubview(confidenceLabel)
        
        contentContainer.backgroundColor = .systemTeal
        identifierLabel.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
//            contentContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            identifierLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            confidenceLabel.widthAnchor.constraint(equalToConstant: 82)
        ])
    }
    
}

