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
  var activityIndicator = UIActivityIndicatorView(style: .large)
  var contentErrorView: ContentErrorView!
  var networkManager = TENetworkManager()
  var imageCollection: CategoryCollectionView!
  var imageCollectionLayout = UICollectionViewFlowLayout()
  var imageCollectionLimit = 15
  var imageCollectionLinks: [String]?
  let imageCollectionSpacing: CGFloat = 16
  var imageCollectionHeaderHeight: CGFloat?
  var trendListWebView: SFSafariViewController!
  var descriptionText: String?
  
  var imageFetchError: Bool = false {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.layoutErrorView()
        self?.contentContainer.layoutSubviews()
      }
    }
  }
  
  // MARK: - Views
  
  var contentContainer: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.spacing = 0
    return view
  }()
  
  var imageCollectionContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var actionButtonContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addBorder(side: .top, color: K.Colors.Borders, width: 1)
    return view
  }()
  
  var trendListButton: UIButton = {
    let button = UIButton(type: .system)
    let fontSize: CGFloat = 18
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(CategoryViewStrings.trendlistButton, for: .normal)
    button.setTitleColor(K.Colors.White, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    button.layer.cornerRadius = 8
    button.backgroundColor = K.Colors.Blue
    return button
  }()
  
  // MARK: - Lifecycle
  
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
    view.backgroundColor = K.Colors.Background
  }
  
  fileprivate func configureImageCollection() {
    imageCollectionLayout.sectionInset = UIEdgeInsets(top: 0, left: imageCollectionSpacing, bottom: imageCollectionSpacing, right: imageCollectionSpacing)
    imageCollectionLayout.minimumLineSpacing = imageCollectionSpacing
    imageCollectionLayout.minimumInteritemSpacing = imageCollectionSpacing
    
    imageCollection = CategoryCollectionView(frame: .zero, collectionViewLayout: imageCollectionLayout)
    imageCollection.delegate = self
    imageCollection.dataSource = self
    imageCollection.backgroundColor = K.Colors.Background
  }
  
  fileprivate func configureContentErrorView() {
    let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 48, weight: .medium)
    let errorIcon = UIImage(systemName: K.Icons.Exclamation, withConfiguration: iconConfiguration)
    
    contentErrorView = ContentErrorView(
      image: errorIcon!,
      title: CategoryViewStrings.errorViewTitle,
      message: CategoryViewStrings.errorViewBody)
  }
  
  fileprivate func configureWebView() {
    let url = URL(string: networkManager.getEndpoint("trends", endpoint: identifier, type: "web"))
    
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
    
    let imageKey = (imageCollectionLinks?[indexPath.row])! as NSString
    let imageData = TECacheManager.shared.imageCache.object(forKey: imageKey)
    let imageView = UIImageView(frame: cell.contentView.bounds)
    
    imageView.image = imageData
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    
    cell.addBorder()
    cell.contentView.addSubview(imageView)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let url = imageCollectionLinks?[indexPath.row] else { return }
    presentFullscreenImage(url)
  }
  
  // MARK: - Helpers
  
  fileprivate func presentFullscreenImage(_ url: String) {
    let fullView = FullscreenImageController()
    
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
    networkManager.fetchCategoryDescription(identifier) { [weak self] (result, cachedData) in
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
            self?.descriptionText = "No description available"
            print(error)
          case .none:
            fatalError(TENetworkError.none.rawValue)
        }
      }
    }
  }
  
  fileprivate func fetchImages() {
    activityIndicator.startAnimating()
    
    networkManager.fetchCategoryImages(identifier, imageCollectionLimit) { [weak self] (result) in
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
          
          DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
          }
          
          print(error)
      }
      
      DispatchQueue.main.async { [weak self] in
        self?.imageCollection.reloadData()
        self?.activityIndicator.stopAnimating()
      }
    }
  }
  
}

// MARK: - Layout

fileprivate extension CategoryViewController {
  
  func applyLayouts() {
    layoutContainer()
    layoutImageCollection()
    layoutActivityIndicator()
    layoutButton()
  }
  
  func layoutContainer() {
    view.addSubview(contentContainer)
    
    NSLayoutConstraint.activate([
      contentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      contentContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      contentContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
  }
  
  func layoutImageCollection() {
    contentContainer.addArrangedSubview(imageCollectionContainer)
    imageCollectionContainer.addSubview(imageCollection)
    imageCollection.fillOther(view: imageCollectionContainer)
  }
  
  func layoutActivityIndicator() {
    imageCollectionContainer.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      activityIndicator.centerYAnchor.constraint(equalTo: imageCollectionContainer.centerYAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: imageCollectionContainer.centerXAnchor)
    ])
  }
  
  func layoutErrorView() {
    let xPadding: CGFloat = 16
    
    imageCollectionContainer.removeFromSuperview()
    contentContainer.addSubview(contentErrorView)
    
    NSLayoutConstraint.activate([
      contentErrorView.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
      contentErrorView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
      contentErrorView.widthAnchor.constraint(equalTo: contentContainer.widthAnchor, constant: -(xPadding))
    ])
  }
  
  func layoutButton() {
    let yPadding: CGFloat = 20
    let xPadding: CGFloat = 16
    let height: CGFloat = 50
    
    view.addSubview(actionButtonContainer)
    actionButtonContainer.addSubview(trendListButton)
    
    NSLayoutConstraint.activate([
      actionButtonContainer.topAnchor.constraint(equalTo: contentContainer.bottomAnchor),
      actionButtonContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      actionButtonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      actionButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      trendListButton.topAnchor.constraint(equalTo: actionButtonContainer.topAnchor, constant: yPadding),
      trendListButton.leadingAnchor.constraint(equalTo: actionButtonContainer.leadingAnchor, constant: xPadding),
      trendListButton.trailingAnchor.constraint(equalTo: actionButtonContainer.trailingAnchor, constant: -(xPadding)),
      trendListButton.bottomAnchor.constraint(equalTo: actionButtonContainer.bottomAnchor, constant: -(yPadding)),
      trendListButton.heightAnchor.constraint(equalToConstant: height),
      
      // NOTE: This constraint is needed here to center the error content to the superview
      contentContainer.bottomAnchor.constraint(equalTo: actionButtonContainer.topAnchor)
    ])
  }
  
}
