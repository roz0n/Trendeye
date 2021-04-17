//
//  CategoryViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var name: String!
    var descriptionText: String?
    var galleryView: CategoryCollectionView!
    
    var headerContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    var descriptionView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainer.maximumNumberOfLines = 0
        view.textContainer.lineBreakMode = .byWordWrapping
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.sizeToFit()
        return view
    }()
    
    var galleryLabel: UITextView = {
        let label = UITextView()
        let fontSize: CGFloat = 18
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textContainer.maximumNumberOfLines = 0
        label.textContainer.lineBreakMode = .byWordWrapping
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = .clear
        label.font = AppFonts.Satoshi.font(face: .bold, size: fontSize)
        label.text = "More like this"
        return label
    }()
    
    var galleryContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        return view
    }()
    
    var trendlistButton: UIButton = {
        let button = UIButton(type: .system)
        let fontSize: CGFloat = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View on Trend List", for: .normal)
        button.setTitleColor(K.Colors.Black, for: .normal)
        button.titleLabel?.font = AppFonts.Satoshi.font(face: .black, size: fontSize)
        button.layer.cornerRadius = 8
        button.backgroundColor = K.Colors.White
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        applyConfigurations()
    }
    
    override func viewDidLoad() {
        applyLayouts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGalleryView()
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
        let kernValue: CGFloat = -0.15
        let fontSize: CGFloat = 16
        paragraphStyle.lineHeightMultiple = 1.25
        
        descriptionView.attributedText = NSMutableAttributedString(
            string: descriptionText ?? "No description available",
            attributes: [
                NSAttributedString.Key.kern: kernValue,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .medium)])
    }
    
    fileprivate func configureGalleryView() {
        let containerWidth = galleryContainer.bounds.size.width
        let containerHeight = galleryContainer.bounds.size.height
        let numberInRow: CGFloat = 3
        let cellXPadding: CGFloat = 20
        let cellYPadding: CGFloat = 30
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: (containerWidth / numberInRow) - cellXPadding, height:(containerHeight / numberInRow) - cellYPadding)
        layout.sectionInset = UIEdgeInsets(top: cellYPadding, left: cellXPadding, bottom: cellYPadding, right: cellXPadding)
        
        galleryView = CategoryCollectionView(frame: .zero, collectionViewLayout: layout)
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        galleryView.backgroundColor = .systemGreen
        galleryView.delegate = self
        galleryView.dataSource = self
        galleryView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCell")
        galleryContainer.addSubview(galleryView)
        galleryView.fillOther(view: galleryContainer)
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath)
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        cell.backgroundColor = .systemBlue
        return cell
    }
    
}

// MARK: - Layout

fileprivate extension CategoryViewController {
    
    func applyLayouts() {
        layoutDescription()
        layoutLabel()
        layoutGallery()
        layoutButton()
    }
    
    func layoutDescription() {
        let headerPadding: CGFloat = 14
        view.addSubview(headerContainer)
        headerContainer.addArrangedSubview(descriptionView)
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: headerPadding),
            headerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: headerPadding),
            headerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(headerPadding))
        ])
    }
    
    func layoutLabel() {
        let headerXPadding: CGFloat = 1
        let headerYPadding: CGFloat = 10
        view.addSubview(galleryLabel)
        NSLayoutConstraint.activate([
            galleryLabel.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: headerYPadding),
            galleryLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: headerXPadding)
        ])
    }
    
    func layoutGallery() {
        view.addSubview(galleryContainer)
        NSLayoutConstraint.activate([
            galleryContainer.topAnchor.constraint(equalTo: galleryLabel.bottomAnchor),
            galleryContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            galleryContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func layoutButton() {
        let buttonYPadding: CGFloat = 20
        let buttonXPadding: CGFloat = 14
        let buttonHeight: CGFloat = 50
        view.addSubview(trendlistButton)
        NSLayoutConstraint.activate([
            trendlistButton.topAnchor.constraint(equalTo: galleryContainer.bottomAnchor, constant: buttonYPadding),
            trendlistButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: buttonXPadding),
            trendlistButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(buttonXPadding)),
            trendlistButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(buttonYPadding)),
            trendlistButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
}
