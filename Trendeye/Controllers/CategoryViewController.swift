//
//  CategoryViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit
import SafariServices

final class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
    
    var identifier: String!
    var name: String!
    var galleryView: CategoryCollectionView!
    var galleryImageKeys: [String]?
    var trendListWebView: SFSafariViewController!
    
    var descriptionText: String? {
        didSet {
            configureDescription()
        }
    }
    
    var galleryData: [ProjectImage]? {
        didSet {
            if let galleryData = galleryData {
                configureGalleryImages(images: galleryData)
            }
        }
    }
    
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
        return view
    }()
    
    var trendListButton: UIButton = {
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
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGalleryView()
    }
    
    // MARK: - Configuration
    
    fileprivate func applyConfigurations() {
        configureView()
        configureDescription()
        configureWebView()
        configureTrendListButton()
    }
    
    fileprivate func configureView() {
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
        // TODO: Use sizeForItemAt to calculate the cell sizes instead of doing this manually how you've done here
        /**
         NOTE: This configuration must be set within `viewDidLayoutSubviews` so that constraints for the container are set before performing calculations with the bounds values.
         */
        let containerHeight = galleryContainer.bounds.size.height
        let numberInRow: CGFloat = 3
        let cellXPadding: CGFloat = 20
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: (containerHeight / numberInRow) - 15, height:(containerHeight / numberInRow) - 15)
        layout.sectionInset = UIEdgeInsets(top: 10, left: cellXPadding, bottom: 0, right: cellXPadding)
        
        galleryView = CategoryCollectionView(frame: .zero, collectionViewLayout: layout)
        galleryView.delegate = self
        galleryView.dataSource = self
        galleryContainer.addSubview(galleryView)
        galleryView.fillOther(view: galleryContainer)
    }
    
    fileprivate func configureGalleryImages(images: [ProjectImage]) {
        let links = images.map { $0.images.small }
        galleryImageKeys = links
        
        links.forEach {
            TECacheManager.shared.fetchAndCacheImage(from: $0)
            DispatchQueue.main.async { [weak self] in
                self?.galleryView.reloadData()
            }
        }
    }
    
    fileprivate func configureWebView() {
        let url = URL(string: TEDataManager.shared.getEndpoint("trends", endpoint: identifier, type: "web"))
        trendListWebView = SFSafariViewController(url: url!)
        trendListWebView.delegate = self
    }
    
    fileprivate func configureTrendListButton() {
        trendListButton.addTarget(self, action: #selector(handleTrendListButtonTap), for: .touchUpInside)
    }
    
    // MARK: - Gestures
    
    @objc func handleTrendListButtonTap() {
        present(trendListWebView, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionView Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryView.dequeueReusableCell(withReuseIdentifier: CategoryImageCell.reuseIdentifier, for: indexPath) as! CategoryImageCell
        guard galleryImageKeys != nil && galleryImageKeys!.count > 0 else { return cell }
        
        let imageKey = (galleryImageKeys?[indexPath.row])! as NSString
        // TODO: Should caching occur inside the data manager as opposed to the VC? That might lend to better separation of concerns.
        let imageData = TECacheManager.shared.imageCache.object(forKey: imageKey)
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.image = imageData
        
        cell.contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - Data Fetching
    
    fileprivate func fetchData() {
        fetchDescription()
        fetchImages()
    }
    
    fileprivate func fetchDescription() {
        // TODO: Do not perform these calls unless the data is not yet in the cache
        TEDataManager.shared.fetchCategoryDescription(identifier) { [weak self] (descriptionData, remoteUrl) in
            self?.handleDescriptionResponse(descriptionData, remoteUrl)
        }
    }
    
    fileprivate func fetchImages() {
        // TODO: Do not perform these calls unless the data is not yet in the cache
        TEDataManager.shared.fetchCategoryImages(identifier) { [weak self] (imageData) in
            self?.handleImageResponse(imageData)
        }
    }
    
    fileprivate func handleDescriptionResponse(_ response: GenericAPIResponse, _ remoteUrl: String) {
        DispatchQueue.main.async { [weak self] in
            // TODO: Should caching occur inside the data manager as opposed to the VC? That might lend to better separation of concerns.
            TECacheManager.shared.fetchAndCacheText(from: remoteUrl)
            let textKey = remoteUrl as NSString
            self?.descriptionText = TECacheManager.shared.textCache.object(forKey: textKey) as String?
        }
    }
    
    fileprivate func handleImageResponse(_ response: GenericAPIResponse2) {
        DispatchQueue.main.async { [weak self] in
            self?.galleryData = response.data
        }
    }
    
}

// MARK: - Layout

fileprivate extension CategoryViewController {
    
    // TODO: The hard coded height values are temporary, check `sizeForItemAt`
    
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
            headerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(headerPadding)),
            headerContainer.heightAnchor.constraint(equalToConstant: 140)
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
        view.addSubview(trendListButton)
        NSLayoutConstraint.activate([
            trendListButton.topAnchor.constraint(equalTo: galleryContainer.bottomAnchor, constant: buttonYPadding),
            trendListButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: buttonXPadding),
            trendListButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(buttonXPadding)),
            trendListButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(buttonYPadding)),
            trendListButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
}
