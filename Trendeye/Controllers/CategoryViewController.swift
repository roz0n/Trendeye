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
    var imageCollection: CategoryCollectionView!
    var imageCollectionLimit = 15
    var imageCollectionLinks: [String]?
    let imageCollectionSpacing: CGFloat = 16
    var trendListWebView: SFSafariViewController!
    
    var descriptionText: String? {
        didSet {
            configureDescription()
        }
    }
    
    var mainContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.Colors.ViewBackground
        return view
    }()
    
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
        view.isEditable = false
        view.backgroundColor = K.Colors.ViewBackground
        return view
    }()
    
    var imageCollectionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var trendListButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = K.Colors.NavigationBar
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
    
    override func viewDidLoad() {
        applyConfigurations()
        applyLayouts()
        fetchData()
    }
    
    // MARK: - Configuration
    
    fileprivate func applyConfigurations() {
        configureView()
        configureDescription()
        configureImageCollection()
        configureWebView()
        configureTrendListButton()
    }
    
    fileprivate func configureView() {
        // view.backgroundColor = K.Colors.ViewBackground
    }
    
    fileprivate func configureDescription() {
        let paragraphStyle = NSMutableParagraphStyle()
        let kernValue: CGFloat = -0.15
        let fontSize: CGFloat = 16
        paragraphStyle.lineHeightMultiple = 1.25
        
        guard descriptionText != nil else { return }
        
        descriptionView.attributedText = NSMutableAttributedString(
            string: descriptionText!.count > 0 ? descriptionText! : "No description available",
            attributes: [
                NSAttributedString.Key.kern: kernValue,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .medium)])
        descriptionView.sizeToFit()
    }
    
    fileprivate func configureImageCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: imageCollectionSpacing, left: imageCollectionSpacing, bottom: imageCollectionSpacing, right: imageCollectionSpacing)
        layout.minimumLineSpacing = imageCollectionSpacing
        layout.minimumInteritemSpacing = imageCollectionSpacing
        layout.sectionHeadersPinToVisibleBounds = true
        
        imageCollection = CategoryCollectionView(frame: .zero, collectionViewLayout: layout)
        imageCollection.delegate = self
        imageCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsInRow: CGFloat = 3
        let cellPadding: CGFloat = imageCollectionSpacing
        
        // Obtain amount of total padding required by the row
        let totalInsetSize: CGFloat = (imageCollectionSpacing * 2)
        let totalCellPadding: CGFloat = (cellsInRow - 1) * cellPadding // cellsInRow - 1 because the last item in the row goes without padding
        let totalPadding = totalInsetSize + totalCellPadding
        
        // Subtract the total padding from the width of the gallery view and divide by the number of cells in the row
        let cellSize: CGFloat = (imageCollection.bounds.width - totalPadding) / 3
        return CGSize(width: cellSize, height: cellSize).customRound()
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryCollectionHeaderView.reuseIdentifier, for: indexPath) as! CategoryCollectionHeaderView
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let header = CategoryCollectionHeaderView()
        return CGSize(width: imageCollection?.frame.width ?? 0, height: header.label.frame.height + (header.padding / 8))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollectionLinks?.count ?? imageCollectionLimit
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: CategoryImageCell.reuseIdentifier, for: indexPath) as! CategoryImageCell
        
        guard imageCollectionLinks != nil && imageCollectionLinks!.count > 0 && imageCollectionLinks!.count >= indexPath.row else {
            // There are no images for the category or at this index.
            // Don't bother to check the cache, just return empty cells with no border.
            return cell
        }
        
        // MARK: - Cell Image Cache Check
        // TODO: When we resume the app from a suspended state, the cache clears these images. Either increase the size of the cache, or fetch them again.
        
        let imageKey = (imageCollectionLinks?[indexPath.row])! as NSString
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = imageCollectionLinks?[indexPath.row] else { return }
        presentFullscreenImage(url)
    }
    
    // MARK: - Helpers
    
    fileprivate func presentFullscreenImage(_ url: String) {
        let fullView = FullScreenImageView()
        fullView.url = url
        fullView.modalPresentationStyle = .overFullScreen
        fullView.modalTransitionStyle = .coverVertical
        present(fullView, animated: true, completion: nil)
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
        TENetworkManager.shared.fetchCategoryImages(identifier, imageCollectionLimit) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let imageData):
                        print("Category image links fetch success: will use cached versions if available")
                        self?.imageCollectionLinks = imageData.data.map { $0.images.small }
                        self?.imageCollectionLinks?.forEach {
                            // The cache manager will not make a request for the image if it is already cached :)
                            TECacheManager.shared.fetchAndCacheImage(from: $0)
                            self?.imageCollection.reloadData()
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
    
    func applyLayouts() {
        layoutContainer()
        layoutHeader()
        layoutImageCollection()
        layoutButton()
    }
    
    func layoutContainer() {
        view.addSubview(mainContainer)
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func layoutHeader() {
        let headerPadding: CGFloat = 16
        headerContainer.addArrangedSubview(descriptionView)
        mainContainer.addSubview(headerContainer)
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: mainContainer.safeAreaLayoutGuide.topAnchor, constant: headerPadding),
            headerContainer.leadingAnchor.constraint(equalTo: mainContainer.safeAreaLayoutGuide.leadingAnchor, constant: headerPadding),
            headerContainer.trailingAnchor.constraint(equalTo: mainContainer.safeAreaLayoutGuide.trailingAnchor, constant: -(headerPadding)),
        ])
    }
    
    func layoutImageCollection() {
        mainContainer.addSubview(imageCollectionContainer)
        imageCollectionContainer.addSubview(imageCollection)
        imageCollection.fillOther(view: imageCollectionContainer)
        NSLayoutConstraint.activate([
            imageCollectionContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: (imageCollectionSpacing / 2)),
            imageCollectionContainer.leadingAnchor.constraint(equalTo: mainContainer.safeAreaLayoutGuide.leadingAnchor),
            imageCollectionContainer.trailingAnchor.constraint(equalTo: mainContainer.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func layoutButton() {
        let buttonYPadding: CGFloat = 20
        let buttonXPadding: CGFloat = 16
        let buttonHeight: CGFloat = 50
        view.addSubview(trendListButtonContainer)
        trendListButtonContainer.addSubview(trendListButton)
        NSLayoutConstraint.activate([
            trendListButtonContainer.topAnchor.constraint(equalTo: imageCollectionContainer.bottomAnchor),
            trendListButtonContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trendListButtonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trendListButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trendListButton.topAnchor.constraint(equalTo: trendListButtonContainer.topAnchor, constant: buttonYPadding),
            trendListButton.leadingAnchor.constraint(equalTo: trendListButtonContainer.leadingAnchor, constant: buttonXPadding),
            trendListButton.trailingAnchor.constraint(equalTo: trendListButtonContainer.trailingAnchor, constant: -(buttonXPadding)),
            trendListButton.bottomAnchor.constraint(equalTo: trendListButtonContainer.bottomAnchor, constant: -(buttonYPadding)),
            trendListButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
}
