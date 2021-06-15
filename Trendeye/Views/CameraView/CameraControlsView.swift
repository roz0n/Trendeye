//
//  CameraControlsView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit

class CameraControlsView: UIView {
  
  // MARK: - Button Properties
  
  var shootButton: CameraButton!
  var flipButton: CameraButton!
  var flashButton: CameraButton!
  var galleryButton: CameraButton!
  var captureModeButton: CameraButton!
  
  // MARK: -
  
  let largeButtonSize: CGFloat = 100
  let smallButtonSize: CGFloat = 42
  
  // MARK: - Container Properties
  
  var stackContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.spacing = 12
    stack.distribution = .equalCentering
    return stack
  }()
  
  var leadingButtonsContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .equalCentering
    return stack
  }()
  
  var trailingButtonsContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .equalCentering
    return stack
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
    let galleryIcon = UIImage(
      systemName: K.Icons.Gallery,
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .heavy))!
    
    // This should initially be the opposite of CameraViewController's selectedCaptureMode
    let cropIcon = UIImage(
      systemName: K.Icons.CaptureManual,
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
    galleryButton = createButton(
      title: "Gallery",
      tintColor: K.Colors.White,
      backgroundColor: K.Colors.TransparentButtons,
      image: galleryIcon)
    captureModeButton = createButton(
      title: "CaptureMode",
      tintColor: K.Colors.White,
      backgroundColor: K.Colors.TransparentButtons,
      image: cropIcon)
  }
  
  // MARK: - Helpers
  
  fileprivate func createButton(title: String, tintColor: UIColor, backgroundColor: UIColor, image: UIImage) -> CameraButton {
    let button = CameraButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
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
  func applyLayouts() {
    layoutStackContainer()
    layoutCameraButtons()
  }
  
  func layoutStackContainer() {
    let buttonXPadding: CGFloat = 20
    
    addSubview(stackContainer)
    
    NSLayoutConstraint.activate([
      stackContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      stackContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: buttonXPadding),
      stackContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -buttonXPadding),
    ])
  }
  
  func layoutCameraButtons() {
    leadingButtonsContainer.addArrangedSubview(captureModeButton)
    leadingButtonsContainer.addArrangedSubview(galleryButton)
    
    trailingButtonsContainer.addArrangedSubview(flipButton)
    trailingButtonsContainer.addArrangedSubview(flashButton)
    
    stackContainer.addArrangedSubview(leadingButtonsContainer)
    stackContainer.addArrangedSubview(shootButton)
    stackContainer.addArrangedSubview(trailingButtonsContainer)
    
    NSLayoutConstraint.activate([
      captureModeButton.heightAnchor.constraint(equalToConstant: smallButtonSize),
      captureModeButton.widthAnchor.constraint(equalToConstant: smallButtonSize),
      galleryButton.heightAnchor.constraint(equalToConstant: smallButtonSize),
      galleryButton.widthAnchor.constraint(equalToConstant: smallButtonSize),
      
      shootButton.heightAnchor.constraint(equalToConstant: largeButtonSize),
      shootButton.widthAnchor.constraint(equalToConstant: largeButtonSize),
      
      flipButton.heightAnchor.constraint(equalToConstant: smallButtonSize),
      flipButton.widthAnchor.constraint(equalToConstant: smallButtonSize),
      flashButton.heightAnchor.constraint(equalToConstant: smallButtonSize),
      flashButton.widthAnchor.constraint(equalToConstant: smallButtonSize),
    ])
  }
  
}
