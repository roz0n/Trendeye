//
//  ContentErrorView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/26/21.
//

import UIKit

class ContentErrorView: UIView {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var message: String? {
        didSet {
            messageView.text = message
        }
    }
    
    let container: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalCentering
        stack.axis = .vertical
        stack.backgroundColor = .brown
        return stack
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        view.backgroundColor = .systemPink
        view.contentMode = .center
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = AppFonts.Satoshi.font(face: .black, size: 16)
        label.backgroundColor = .systemTeal
        return label
    }()
    
    let messageView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.font = AppFonts.Satoshi.font(face: .medium, size: 16)
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isScrollEnabled = false
        textView.isEditable = false
//        textView.contentInset = UIEdgeInsets(top: 30, left: 60, bottom: -30, right: -60)
        textView.backgroundColor = .systemGreen
        return textView
    }()
    
    init(image: UIImage, title: String, message: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = image
        self.title = title
        self.message = message
        self.backgroundColor = .cyan
        self.applyLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout

fileprivate extension ContentErrorView {
    
    func applyLayouts() {
        layoutContainer()
        layoutIcon()
        layoutTitle()
        layoutMessage()
    }
    
    func layoutContainer() {
        addSubview(container)
        container.fillOther(view: self)
    }
    
    func layoutIcon() {
        imageView.image = image
        container.addArrangedSubview(imageView)
    }
    
    func layoutTitle() {
        titleLabel.text = title
        container.addArrangedSubview(titleLabel)
    }
    
    func layoutMessage() {
        messageView.text = message
        container.addArrangedSubview(messageView)
    }
    
}

