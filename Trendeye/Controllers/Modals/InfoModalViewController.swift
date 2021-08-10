//
//  InfoModalViewController.swift
//  InfoModalViewController
//
//  Created by Arnaldo Rozon on 7/31/21.
//

import UIKit

class InfoModalViewController: UIViewController {
  
  // MARK: - Properties
  
  var iconSymbol: String {
    didSet {
      configureIconView(with: iconSymbol)
    }
  }
  
  var titleText: String {
    didSet {
      titleLabel.text = title
    }
  }
  
  var bodyText: String {
    didSet {
      bodyTextView.attributedText = setBodyText(to: bodyText)
    }
  }
  
  var buttonText: String {
    didSet {
      actionButton.setTitle(buttonText, for: .normal)
    }
  }
  
  // MARK: - Views
  
  let backgroundBlurView: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    
    return view
  }()
  
  var containerView: UIStackView = {
    let view = UIStackView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.spacing = 24
    
    return view
  }()
  
  var iconContainer: UIView = {
    let view = UIView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    return view
  }()
  
  var iconView: UIImageView = {
    let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .blue
    view.contentMode = .center
    view.makeCircular()
    
    return view
  }()
  
  var titleLabel: UILabel = {
    let label = UILabel()
    
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    
    return label
  }()
  
  var bodyTextView: UITextView = {
    let view = UITextView()
    
    view.textContainer.maximumNumberOfLines = 0
    view.textAlignment = .center
    view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    view.textColor = K.Colors.White
    view.backgroundColor = .clear
    view.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    view.isUserInteractionEnabled = false
    view.isEditable = false
    view.isSelectable = false
    
    return view
  }()
  
  var actionButton: UIButton = {
    let button = UIButton(type: .system)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(K.Colors.White, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    button.layer.cornerRadius = 8
    button.backgroundColor = K.Colors.Blue
    
    return button
  }()
  
  // MARK: - Initializers
  
  init(iconSymbol: String, titleText: String, bodyText: String, buttonText: String) {
    self.iconSymbol = iconSymbol
    self.titleText = titleText
    self.bodyText = bodyText
    self.buttonText = buttonText
    
    super.init(nibName: nil, bundle: nil)
    
    configureTextViews()
    configureIconView(with: iconSymbol)
    configureButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureActionButtonGesture()
    applyLayouts()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureViewController() {
    view.backgroundColor = .clear
  }
  
  fileprivate func configureTextViews() {
    titleLabel.text = titleText
    bodyTextView.attributedText = setBodyText(to: bodyText)
  }
  
  fileprivate func configureIconView(with symbol: String) {
    let configuration = UIImage.SymbolConfiguration(pointSize: 42, weight: .bold)
    iconView.image = UIImage(systemName: symbol, withConfiguration: configuration)?.withTintColor(K.Colors.White, renderingMode: .alwaysOriginal)
  }
  
  fileprivate func configureButton() {
    actionButton.setTitle(buttonText, for: .normal)
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

// MARK: - Helpers

func setBodyText(to text: String) -> NSMutableAttributedString {
  let paragraphStyle = NSMutableParagraphStyle()
  paragraphStyle.lineHeightMultiple = 1.26
  paragraphStyle.alignment = .center
  
  return NSMutableAttributedString(string: text, attributes: [
    NSAttributedString.Key.paragraphStyle: paragraphStyle,
    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium),
    NSAttributedString.Key.foregroundColor: K.Colors.White])
  
}

// MARK: - Layout

fileprivate extension InfoModalViewController {
  
  func applyLayouts() {
    layoutBackground()
    layoutContainer()
    layoutButton()
    layoutContent()
    layoutIcon()
  }
  
  func layoutBackground() {
    view.addSubview(backgroundBlurView)
    backgroundBlurView.fillOther(view: view)
  }
  
  func layoutContainer() {
    backgroundBlurView.contentView.addSubview(containerView)
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
      containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
    ])
  }
  
  func layoutButton() {
    view.addSubview(actionButton)
    
    NSLayoutConstraint.activate([
      actionButton.heightAnchor.constraint(equalToConstant: 64),
      actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      
      // Necessary for the button to sit beneath the scroll view
      containerView.bottomAnchor.constraint(equalTo: actionButton.topAnchor)
    ])
  }
  
  func layoutContent() {
    containerView.addArrangedSubview(iconContainer)
    containerView.addArrangedSubview(titleLabel)
    containerView.addArrangedSubview(bodyTextView)
  }
  
  func layoutIcon() {
    iconContainer.addSubview(iconView)
    
    NSLayoutConstraint.activate([
      // Icon
      iconView.widthAnchor.constraint(equalToConstant: 110),
      iconView.heightAnchor.constraint(equalToConstant: 110),
      iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
      iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
      
      // Container
      iconContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor),
      iconContainer.heightAnchor.constraint(equalToConstant: 110),
    ])
  }
  
}
