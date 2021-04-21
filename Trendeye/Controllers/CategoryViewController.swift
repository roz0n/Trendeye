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
    var galleryImagesLinks: [String]?
    let galleryLayoutSpacing: CGFloat = 16
    var trendListWebView: SFSafariViewController!
    
    var descriptionText: String? {
        didSet {
            configureDescription()
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
        view.backgroundColor = K.Colors.ViewBackground
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
    
    // MARK: - Configuration
    
    fileprivate func applyConfigurations() {
        configureView()
        configureDescription()
        configureGalleryView()
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
        descriptionView.sizeToFit()
    }
    
    fileprivate func configureGalleryView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: galleryLayoutSpacing, bottom: 0, right: galleryLayoutSpacing)
        layout.minimumLineSpacing = galleryLayoutSpacing
        layout.minimumInteritemSpacing = galleryLayoutSpacing
        
        galleryView = CategoryCollectionView(frame: .zero, collectionViewLayout: layout)
        galleryView.delegate = self
        galleryView.dataSource = self
        galleryContainer.addSubview(galleryView)
        galleryView.fillOther(view: galleryContainer)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsInRow: CGFloat = 3
        let cellPadding: CGFloat = galleryLayoutSpacing
        
        // Obtain amount of total padding required by the row
        let totalInsetSize: CGFloat = (galleryLayoutSpacing * 2)
        let totalCellPadding: CGFloat = (cellsInRow - 1) * cellPadding // cellsInRow - 1 because the last item in the row goes without padding
        let totalPadding = totalInsetSize + totalCellPadding
        
        // Subtract the total padding from the width of the gallery view and divide by the number of cells in the row
        let cellSize: CGFloat = (galleryView.bounds.width - totalPadding) / 3
        return CGSize(width: cellSize, height: cellSize)
    }
    
    fileprivate func configureWebView() {
        let url = URL(string: TENetworkManager.shared.getEndpoint("trends", endpoint: identifier, type: "web"))
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
        
        guard galleryImagesLinks != nil && galleryImagesLinks!.count > 0 && galleryImagesLinks!.count >= indexPath.row else {
            // There are no images for the category or at this index.
            // Don't bother to check the cache, just return empty cells with no border.
            return cell
        }
        
        // MARK: - Cell Image Cache Check
        // TODO: When we resume the app from a suspended state, the cache clears these images. Either increase the size of the cache, or fetch them again.
        
        let imageKey = (galleryImagesLinks?[indexPath.row])! as NSString
        let imageData = TECacheManager.shared.imageCache.object(forKey: imageKey)
        let imageView = UIImageView(frame: cell.contentView.bounds)
        
        imageView.image = imageData
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        
        cell.applyBorder()
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    
    
    // MARK: - Data Fetching
    
    fileprivate func fetchData() {
        fetchDescription()
        fetchImages()
    }
    
    fileprivate func fetchDescription() {
        TENetworkManager.shared.fetchCategoryDescription(identifier) { [weak self] (result, cachedData) in
            DispatchQueue.main.async {
                guard cachedData == nil else {
                    print("Using cached description data")
                    self?.descriptionText = cachedData
                    return
                }
                
                switch result {
                    case .success(let descriptionData):
                        print("Using fresh description data")
                        self?.descriptionText = descriptionData.data.description
                    case .failure(let error):
                        print(error)
                    case .none:
                        fatalError(TENetworkError.none.rawValue)
                }
            }
        }
    }
    
    fileprivate func fetchImages() {
        TENetworkManager.shared.fetchCategoryImages(identifier) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let imageData):
                        print("Successfully obtained gallery image links, will used cached versions if available")
                        self?.galleryImagesLinks = imageData.data.map { $0.images.small }
                        self?.galleryImagesLinks?.forEach {
                            // The cache manager will not make a request for the image if it is already cached :)
                            TECacheManager.shared.fetchAndCacheImage(from: $0)
                            self?.galleryView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                }
            }
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
        ])
    }
    
    func layoutLabel() {
        let headerYPadding: CGFloat = 10
        view.addSubview(galleryLabel)
        NSLayoutConstraint.activate([
            galleryLabel.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: headerYPadding),
            galleryLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor)
        ])
    }
    
    func layoutGallery() {
        let containerYPadding: CGFloat = 10
        view.addSubview(galleryContainer)
        NSLayoutConstraint.activate([
            galleryContainer.topAnchor.constraint(equalTo: galleryLabel.bottomAnchor, constant: containerYPadding),
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
