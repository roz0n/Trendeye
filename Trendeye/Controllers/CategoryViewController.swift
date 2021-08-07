//
//  CategoryViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit
import SafariServices

final class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
  
  // MARK: - Properties
  
  var identifier: String!
  var name: String!
  var contentErrorView: ContentErrorView!
  var imageCollection: CategoryCollectionView!
  var imageCollectionLayout = UICollectionViewFlowLayout()
  var imageCollectionLimit = 15
  var imageCollectionLinks: [String]?
  let imageCollectionSpacing: CGFloat = 16
  var imageCollectionHeaderHeight: CGFloat?
  var trendListWebView: SFSafariViewController!
  
  var descriptionText: String?
  
  var descriptionFetchError: Bool = false {
    didSet {
      //      DispatchQueue.main.async { [weak self] in
      //        if let text = self?.descriptionText {
      //          self?.configureDescription(text: text)
      //        }
      //      }
    }
  }
  
  var imageFetchError: Bool = false {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.layoutErrorView()
        self?.contrentContainer.layoutSubviews()
      }
    }
  }
  
  // MARK: - Views
  
  var contrentContainer: UIStackView = {
    let view = UIStackView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.spacing = 0
    view.backgroundColor = K.Colors.Red
    
    return view
  }()
  
  var descriptionView: UITextView = {
    let textView = UITextView()
    
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.textContainer.maximumNumberOfLines = 0
    textView.textContainer.lineBreakMode = .byWordWrapping
    textView.isScrollEnabled = false
    textView.isEditable = false
    textView.isUserInteractionEnabled = false
    textView.backgroundColor = K.Colors.Yellow
    
    return textView
  }()
  
  var imageCollectionContainer: UIView = {
    let view = UIView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .purple
    
    return view
  }()
  
  var trendListButtonContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var trendListButton: UIButton = {
    let button = UIButton(type: .system)
    let fontSize: CGFloat = 18
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("View on Trend List", for: .normal)
    button.setTitleColor(K.Colors.White, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    button.layer.cornerRadius = 8
    button.backgroundColor = K.Colors.Blue
    
    return button
  }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureImageCollection()
    configureContentErrorView()
    configureWebView()
    configureTrendListButton()
    
    fetchData()
    applyLayouts()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureViewController() {
    navigationItem.largeTitleDisplayMode = .always
    view.backgroundColor = K.Colors.Black
  }
  
  fileprivate func configureImageCollection() {
    imageCollectionLayout.sectionInset = UIEdgeInsets(top: imageCollectionSpacing, left: imageCollectionSpacing, bottom: imageCollectionSpacing, right: imageCollectionSpacing)
    imageCollectionLayout.minimumLineSpacing = imageCollectionSpacing
    imageCollectionLayout.minimumInteritemSpacing = imageCollectionSpacing
    imageCollection = CategoryCollectionView(frame: .zero, collectionViewLayout: imageCollectionLayout)
    imageCollection.delegate = self
    imageCollection.dataSource = self
  }
  
  fileprivate func configureContentErrorView() {
    let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 48, weight: .medium)
    let errorIcon = UIImage(systemName: K.Icons.Exclamation, withConfiguration: iconConfiguration)
    
    contentErrorView = ContentErrorView(
      image: errorIcon!,
      title: "Unable to Load Trend Images",
      message: "Looks like we’re having some trouble connecting to our servers. Try again later.")
  }
  
  fileprivate func configureWebView() {
    let url = URL(string: TENetworkManager.shared.getEndpoint("trends", endpoint: identifier, type: "web"))
    
    trendListWebView = SFSafariViewController(url: url!)
    trendListWebView.modalPresentationCapturesStatusBarAppearance = true
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
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryCollectionHeaderView.reuseIdentifier, for: indexPath) as! CategoryCollectionHeaderView
      
      headerCell.setText(descriptionText ?? "")
      
      return headerCell
    } else {
      return UICollectionReusableView()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if descriptionText != nil && imageCollectionHeaderHeight == nil {
      // This isn't ideal -- dequeuing the cell in this method -- but this seems like the only reasonable, non-hacky way to get a dynamically sized collection view header.
      // We can take a hit on performance as the dequeuing will only occur twice at most (when the collection view initially loads and when it's reloaded after we fetch the category description text from the API).
      let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryCollectionHeaderView.reuseIdentifier, for: IndexPath()) as! CategoryCollectionHeaderView
      
      headerCell.setText(descriptionText ?? "")
      imageCollectionHeaderHeight = headerCell.textView.sizeThatFits(headerCell.textView.bounds.size).height
    }
    
    return CGSize(width: imageCollection.bounds.width, height: imageCollectionHeaderHeight ?? .leastNonzeroMagnitude)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageCollectionLinks?.count ?? imageCollectionLimit
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: CategoryImageCell.reuseIdentifier, for: indexPath) as! CategoryImageCell
    
    guard imageCollectionLinks != nil && !imageCollectionLinks!.isEmpty && imageCollectionLinks!.count >= indexPath.row else {
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
    let fullView = FullScreenImageViewController()
    
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
            self?.descriptionFetchError = true
            self?.descriptionText = "Description not available"
            print(error)
          case .none:
            fatalError(TENetworkError.none.rawValue)
        }
      }
    }
  }
  
  fileprivate func fetchImages() {
    TENetworkManager.shared.fetchCategoryImages(identifier, imageCollectionLimit) { [weak self] (result) in
      switch result {
        case .success(let imageData):
          print("Category image links fetch success: will use cached versions if available")
          self?.imageCollectionLinks = imageData.data.map { $0.images.small }
          self?.imageCollectionLinks?.forEach {
            // The cache manager will not make a request for the image if it is already cached :)
            TECacheManager.shared.fetchAndCacheImage(from: $0)
            
          }
        case .failure(let error):
          self?.imageFetchError = true
          print(error)
      }
      
      DispatchQueue.main.async { [weak self] in
        self?.imageCollection.reloadData()
      }
    }
  }
  
}

// MARK: - Layout

fileprivate extension CategoryViewController {
  
  func applyLayouts() {
    layoutContainer()
    layoutImageCollection()
    layoutButton()
  }
  
  func layoutContainer() {
    view.addSubview(contrentContainer)
    
    NSLayoutConstraint.activate([
      contrentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      contrentContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      contrentContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
  }
  
  func layoutImageCollection() {
    contrentContainer.addArrangedSubview(imageCollectionContainer)
    imageCollectionContainer.addSubview(imageCollection)
    imageCollection.fillOther(view: imageCollectionContainer)
  }
  
  func layoutErrorView() {
    let padding: CGFloat = 16
    
    imageCollectionContainer.removeFromSuperview()
    contrentContainer.addSubview(contentErrorView)
    
    NSLayoutConstraint.activate([
      contentErrorView.topAnchor.constraint(equalTo: contrentContainer.topAnchor, constant: padding),
      contentErrorView.leadingAnchor.constraint(equalTo: contrentContainer.leadingAnchor),
      contentErrorView.trailingAnchor.constraint(equalTo: contrentContainer.trailingAnchor),
      contentErrorView.centerYAnchor.constraint(equalTo: contrentContainer.centerYAnchor)
    ])
  }
  
  func layoutButton() {
    let buttonYPadding: CGFloat = 20
    let buttonXPadding: CGFloat = 16
    let buttonHeight: CGFloat = 50
    
    view.addSubview(trendListButtonContainer)
    trendListButtonContainer.addSubview(trendListButton)
    
    NSLayoutConstraint.activate([
      trendListButtonContainer.topAnchor.constraint(equalTo: contrentContainer.bottomAnchor),
      trendListButtonContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      trendListButtonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      trendListButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      trendListButton.topAnchor.constraint(equalTo: trendListButtonContainer.topAnchor, constant: buttonYPadding),
      trendListButton.leadingAnchor.constraint(equalTo: trendListButtonContainer.leadingAnchor, constant: buttonXPadding),
      trendListButton.trailingAnchor.constraint(equalTo: trendListButtonContainer.trailingAnchor, constant: -(buttonXPadding)),
      trendListButton.bottomAnchor.constraint(equalTo: trendListButtonContainer.bottomAnchor, constant: -(buttonYPadding)),
      trendListButton.heightAnchor.constraint(equalToConstant: buttonHeight),
      
      // NOTE: This constraint is needed here to center the error content to the superview
      contrentContainer.bottomAnchor.constraint(equalTo: trendListButtonContainer.topAnchor)
    ])
  }
  
}
