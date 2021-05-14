//
//  CameraControlsView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit

class CameraControlsView: UIView {
  
  var shootButton: CameraButton!
  var flipButton: CameraButton!
  var flashButton: CameraButton!
  
  var primaryButtonsContainer: UIStackView = {
    // Contains the "Shoot" button
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.spacing = 12
    stack.distribution = .equalCentering
    return stack
  }()
  
  var secondaryButtonsContainer: UIStackView = {
    // Contains the "Flip" and "Flash" buttons
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .equalCentering
    return stack
  }()
  
  var previewContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var galleryButton: UIButton = {
    let button = UIButton(type: .system)
    let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
    let icon = UIImage(systemName: K.Icons.Gallery, withConfiguration: config)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.tintColor = .white
    button.setImage(icon, for: .normal)
    return button
  }()
  
  // MARK: - Configurations
  
  fileprivate func applyConfigurations() {
    configureControlButtons()
  }
  
  fileprivate func configureControlButtons() {
    let shootIcon = UIImage(
      systemName: K.Icons.Shoot,
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))!
    let flipIcon = UIImage(
      systemName: K.Icons.Flip,
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy))!
    let flashIcon = UIImage(
      systemName: K.Icons.Flash,
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy))!
    
    shootButton = createButton(
      title: "Shoot",
      tintColor: K.Colors.White,
      backgroundColor: K.Colors.TransparentButtons,
      image: shootIcon)
    flipButton = createButton(
      title: "Flip",
      tintColor: K.Colors.White,
      backgroundColor: K.Colors.TransparentButtons,
      image: flipIcon)
    flashButton = createButton(
      title: "Flash",
      tintColor: K.Colors.White,
      backgroundColor: K.Colors.TransparentButtons,
      image: flashIcon)
  }
  
  // MARK: - Helpers
  
  fileprivate func createButton(title: String, tintColor: UIColor, backgroundColor: UIColor, image: UIImage) -> CameraButton {
    let button = CameraButton(type: .system)
    button.setTitle(title, for: .application)
    button.backgroundColor = backgroundColor
    button.setImage(image, for: .normal)
    button.tintColor = tintColor
    return button
  }
  
  func toggleFlashButtonState(for position: AVCaptureDevice.Position) {
    switch position {
      case .front:
        let flashDisabledIcon = UIImage(
          systemName: K.Icons.FlashDisabled,
          withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy))!
        flashButton.isUserInteractionEnabled = false
        flashButton.layer.opacity = 0.3
        flashButton.setImage(
          flashDisabledIcon, for: .normal)
      case .back:
        let flashIcon = UIImage(
          systemName: K.Icons.Flash,
          withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy))!
        flashButton.isUserInteractionEnabled = true
        flashButton.layer.opacity = 1
        flashButton.setImage(
          flashIcon, for: .normal)
      default:
        break
    }
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    applyConfigurations()
    applyLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Layout

fileprivate extension CameraControlsView {
  // These constraints are a bit wonky, but they work for now
  
  func applyLayouts() {
    layoutContainers()
    layoutGalleryButton()
    layoutCameraButtons()
  }
  
  func layoutContainers() {
    let screenWidth = UIScreen.main.bounds.width
    let halfScreenWidth = (screenWidth / 2)
    
    addSubview(previewContainer)
    addSubview(primaryButtonsContainer)
    
    NSLayoutConstraint.activate([
      previewContainer.topAnchor.constraint(equalTo: self.topAnchor),
      previewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      previewContainer.widthAnchor.constraint(equalToConstant: halfScreenWidth),
      previewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      primaryButtonsContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      primaryButtonsContainer.leadingAnchor.constraint(equalTo: previewContainer.trailingAnchor),
      primaryButtonsContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
    ])
  }
  
  func layoutGalleryButton() {
    previewContainer.addSubview(galleryButton)
    NSLayoutConstraint.activate([
      galleryButton.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor),
      galleryButton.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor),
      galleryButton.heightAnchor.constraint(equalToConstant: 100),
      galleryButton.widthAnchor.constraint(equalToConstant: 100),
    ])
  }
  
  func layoutCameraButtons() {
    secondaryButtonsContainer.addArrangedSubview(flipButton)
    secondaryButtonsContainer.addArrangedSubview(flashButton)
    primaryButtonsContainer.addArrangedSubview(shootButton)
    primaryButtonsContainer.addArrangedSubview(secondaryButtonsContainer)
    
    NSLayoutConstraint.activate([
      shootButton.heightAnchor.constraint(equalToConstant: 100),
      shootButton.widthAnchor.constraint(equalToConstant: 100),
      flipButton.heightAnchor.constraint(equalToConstant: 42),
      flipButton.widthAnchor.constraint(equalToConstant: 42),
      flashButton.heightAnchor.constraint(equalToConstant: 42),
      flashButton.widthAnchor.constraint(equalToConstant: 42),
    ])
  }
  
}
