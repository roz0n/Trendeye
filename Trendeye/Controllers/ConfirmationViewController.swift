//
//  ConfirmationViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

final class ConfirmationViewController: UIViewController {
  
  var selectedImage: UIImage!
  var controlsView = ConfirmationControlsView()
  
  var headerView: UIView = {
    let header = UIView()
    header.translatesAutoresizingMaskIntoConstraints = false
    header.backgroundColor = K.Colors.NavigationBar
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
    return view
  }()
  
  var blurView: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var photoBackground: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func viewDidLoad() {
    applyStyles()
    applyConfigurations()
    applyLayouts()
  }
  
  fileprivate func applyStyles() {
    let headerFontSize: CGFloat = 17
    
    view.backgroundColor = K.Colors.ViewBackground
    
    headerView.backgroundColor = K.Colors.ViewBackground
    headerLabel.font = AppFonts.Satoshi.font(face: .black, size: headerFontSize)
    headerLabel.textAlignment = .center
  }
  
  // MARK: - Configurations
  
  fileprivate func applyConfigurations() {
    configureNavigation()
    configurePhotoBackground()
    configurePhotoView()
  }
  
  fileprivate func configureNavigation() {
    navigationItem.hidesBackButton = true
  }
  
  fileprivate func configurePhotoView() {
    photoView.image = selectedImage
    photoView.contentMode = .scaleAspectFit
    photoView.clipsToBounds = true
  }
  
  fileprivate func configurePhotoBackground() {
    photoBackground.image = selectedImage
    photoBackground.contentMode = .scaleAspectFill
    photoView.clipsToBounds = true
  }
  
}

// MARK: - Layout

fileprivate extension ConfirmationViewController {
  
  func applyLayouts() {
    layoutHeaderView()
    layoutPhotoView()
    layoutControlsView()
  }
  
  func layoutHeaderView() {
    let headerHeight: CGFloat = 100
    
    headerView.addSubview(headerLabel)
    headerLabel.fillOther(view: headerView)
    
    view.addSubview(headerView)
    
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: headerHeight),
      headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
      headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  func layoutPhotoView() {
    let photoHeight: CGFloat = 545
    
    blurView.translatesAutoresizingMaskIntoConstraints = false
    
    view.insertSubview(photoBackground, at: 0)
    view.insertSubview(blurView, at: 1)
    view.insertSubview(photoView, at: 2)
        
    NSLayoutConstraint.activate([
      photoBackground.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      photoBackground.heightAnchor.constraint(equalToConstant: photoHeight),
      photoBackground.widthAnchor.constraint(equalTo: view.widthAnchor),
      photoBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      blurView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      blurView.heightAnchor.constraint(equalToConstant: photoHeight),
      blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
      blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      photoView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      photoView.heightAnchor.constraint(equalToConstant: photoHeight),
//      photoView.widthAnchor.constraint(equalTo: view.widthAnchor),
//      photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  func layoutControlsView() {
    let controlsPadding: CGFloat = -30
    
    view.addSubview(controlsView)
    
    NSLayoutConstraint.activate([
      controlsView.topAnchor.constraint(equalTo: photoView.bottomAnchor),
      controlsView.widthAnchor.constraint(equalTo: view.widthAnchor),
      controlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: controlsPadding),
      controlsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
  
}
