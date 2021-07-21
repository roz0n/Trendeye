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
    let header = UIView()
    
    header.translatesAutoresizingMaskIntoConstraints = false
//    header.backgroundColor = K.Colors.NavigationBar
    
    return header
  }()
  
  var headerLabel: UILabel = {
    let label = UILabel()
    let text = "Confirm Photo"
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    
    return label
  }()
  
  var photoView: UIImageView = {
    let view = UIImageView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16
    
    return view
  }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    applyStyles()
    applyConfigurations()
    applyLayouts()
  }
  
  // MARK: - Configurations
  
  fileprivate func applyStyles() {
    let headerFontSize: CGFloat = 17
    
    view.backgroundColor = K.Colors.ViewBackground
    headerView.backgroundColor = K.Colors.ViewBackground
    headerLabel.font = AppFonts.Satoshi.font(face: .black, size: headerFontSize)
    headerLabel.textAlignment = .center
  }
  
  fileprivate func applyConfigurations() {
    configureNavigation()
    configurePhotoView()
  }
  
  fileprivate func configureNavigation() {
    navigationItem.hidesBackButton = true
  }
  
  fileprivate func configurePhotoView() {
    photoView.image = selectedImage
    photoView.contentMode = .scaleAspectFill
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
    let headerHeight: CGFloat = 100
    
    headerView.addSubview(headerLabel)
    headerLabel.fillOther(view: headerView)
    
    view.addSubview(headerView)
    
    headerView.backgroundColor = .red
    
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: headerHeight),
      headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
      headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  func layoutControlsView() {
    let controlsPadding: CGFloat = -30
    
    controlsView.backgroundColor = .green
    view.addSubview(controlsView)
    
    NSLayoutConstraint.activate([
      controlsView.heightAnchor.constraint(equalToConstant: 125),
      controlsView.widthAnchor.constraint(equalTo: view.widthAnchor),
      controlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: controlsPadding),
      controlsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
  
  func layoutPhotoView() {
    photoView.backgroundColor = .blue
    view.addSubview(photoView)
        
    NSLayoutConstraint.activate([
      photoView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
      photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      photoView.bottomAnchor.constraint(equalTo: controlsView.topAnchor, constant: -20)
    ])
  }
  
}
