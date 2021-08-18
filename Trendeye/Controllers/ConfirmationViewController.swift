//
//  ConfirmationViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

final class ConfirmationViewController: UIViewController {
  
  // MARK: - Properties
  
  var selectedImage: UIImage!
  var controlsView = ConfirmationControlsView()
  
  // MARK: - Views
  
  var headerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addBorder(side: .bottom, color: K.Colors.Borders, width: 1)
    return view
  }()
  
  var headerLabel: UILabel = {
    let label = UILabel()
    let text = ConfirmationViewStrings.navigationTitle
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    return label
  }()
  
  var photoView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    configureViewController()
    configureHeader()
    configureNavigation()
    configurePhotoView()
    applyLayouts()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureViewController() {
    view.backgroundColor = K.Colors.Background
  }
  
  fileprivate func configureHeader() {
    headerView.backgroundColor = K.Colors.Background
    headerLabel.font = UIFont.systemFont(ofSize: K.Sizes.NavigationHeader, weight: .heavy)
    headerLabel.textAlignment = .center
  }
  
  fileprivate func configureNavigation() {
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.hidesBackButton = true
  }
  
  fileprivate func configurePhotoView() {
    photoView.image = selectedImage
    photoView.contentMode = .scaleAspectFit
    photoView.clipsToBounds = true
  }
  
}

// MARK: - Layout

fileprivate extension ConfirmationViewController {
  
  func applyLayouts() {
    layoutHeaderView()
    layoutControlsView()
    layoutPhotoView()
  }
  
  func layoutHeaderView() {
    headerView.addSubview(headerLabel)
    headerLabel.fillOther(view: headerView)
    view.addSubview(headerView)
    
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 100),
      headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
      headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  func layoutControlsView() {
    view.addSubview(controlsView)
    
    NSLayoutConstraint.activate([
      controlsView.heightAnchor.constraint(equalToConstant: 150),
      controlsView.widthAnchor.constraint(equalTo: view.widthAnchor),
      controlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
      controlsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
  
  func layoutPhotoView() {
    view.addSubview(photoView)
    
    NSLayoutConstraint.activate([
      photoView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
      photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      photoView.bottomAnchor.constraint(equalTo: controlsView.topAnchor, constant: -20)
    ])
  }
  
}
