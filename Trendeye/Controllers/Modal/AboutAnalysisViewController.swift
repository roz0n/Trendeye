//
//  AboutAnalysisViewController.swift
//  AboutAnalysisViewController
//
//  Created by Arnaldo Rozon on 8/2/21.
//

import UIKit

class AboutAnalysisViewController: UIViewController {
  
  // MARK: - Views
  
  var container: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.spacing = 24
    return view
  }()
  
  var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Hello there!"
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    return label
  }()
  
  var descriptionText: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textContainer.maximumNumberOfLines = 0
    view.textAlignment = .center
    view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    view.textColor = K.Colors.White
    view.backgroundColor = .clear
    view.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    view.isUserInteractionEnabled = false
    view.isEditable = false
    view.isSelectable = false
    
    // Text configuration
    let text = "Aenean nec imperdiet enim, quis tincidunt nisi. Vivamus sit amet massa at elit mollis sodales facilisis ut leo. Sed maximus dui id nisl tempor aliquam tutls."
    var paragraphStyle = NSMutableParagraphStyle()
    
    paragraphStyle.lineHeightMultiple = 1.26
    paragraphStyle.alignment = .center
    
    view.attributedText = NSMutableAttributedString(string: text, attributes: [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium),
      NSAttributedString.Key.foregroundColor: K.Colors.White])
    
    return view
  }()
  
  var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "SampleSplashGraphic")!.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20))
    view.heightAnchor.constraint(equalToConstant: 376).isActive = true
    return view
  }()
  
  var actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Get Started", for: .normal)
    button.setTitleColor(K.Colors.White, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    button.layer.cornerRadius = 8
    button.backgroundColor = K.Colors.Blue
    button.heightAnchor.constraint(equalToConstant: 64).isActive = true
    return button
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureActionButtonGesture()
    applyLayouts()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureViewController() {
    view.backgroundColor = K.Colors.ViewBackground
  }
  
  // MARK: - Gestures
  
  fileprivate func configureActionButtonGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedActionButton))
    actionButton.addGestureRecognizer(tapGesture)
  }
  
  @objc func tappedActionButton() {
    dismiss(animated: true, completion: nil)
    dismiss(animated: true) {
      // TODO: Save to userDefaults that this screen has been presented already as it should only be presented once.
      print("Dismissed welcome screen")
    }
  }
  
}

// MARK: - Layout

fileprivate extension AboutAnalysisViewController {
  
  func applyLayouts() {
    layoutContainer()
    layoutContent()
  }
  
  func layoutContainer() {
    view.addSubview(container)
    
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35)
    ])
  }
  
  func layoutContent() {
    container.addArrangedSubview(titleLabel)
    container.addArrangedSubview(descriptionText)
    container.addArrangedSubview(imageView)
    container.addArrangedSubview(actionButton)
  }

}
