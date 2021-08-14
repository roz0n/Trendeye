//
//  InfoModalViewController.swift
//  InfoModalViewController
//
//  Created by Arnaldo Rozon on 7/31/21.
//

import UIKit

// TODO: There is an ambigious size for the scroll view here, fix it later
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
  
  var bodyContent: UIView?
  
  // MARK: - Views
  
  let backgroundBlurView: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    return view
  }()
  
  var scrollContainer: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.showsVerticalScrollIndicator = false
    return view
  }()
  
  var iconContainer: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .blue
    view.makeCircular()
    return view
  }()
  
  var iconView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .center
    return view
  }()
  
  var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    label.textColor = K.Colors.White
    return label
  }()
  
  var bodyTextView: UITextView = {
    let view = UITextView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textContainer.maximumNumberOfLines = 0
    view.textAlignment = .center
    view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    view.textColor = K.Colors.White
    view.backgroundColor = .clear
    view.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    view.isUserInteractionEnabled = false
    view.isScrollEnabled = false
    view.isEditable = false
    view.isSelectable = false
    return view
  }()
  
  var bodyContentContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .red
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
    configureActionButton()
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
  
  fileprivate func configureActionButton() {
    actionButton.setTitle(buttonText, for: .normal)
  }
  
  // MARK: - Gestures
  
  fileprivate func configureActionButtonGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedActionButton))
    actionButton.addGestureRecognizer(tapGesture)
  }
  
  @objc func tappedActionButton() {
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
    layoutIcon()
    layoutTitleLabel()
    layoutBodyText()
    
    if bodyContent != nil {
      layoutBodyContent()
    }
  }
  
  func layoutBackground() {
    view.addSubview(backgroundBlurView)
    backgroundBlurView.fillOther(view: view)
  }
  
  func layoutContainer() {
    backgroundBlurView.contentView.addSubview(scrollContainer)
    
    NSLayoutConstraint.activate([
      scrollContainer.topAnchor.constraint(equalTo: backgroundBlurView.contentView.topAnchor, constant: 42),
      scrollContainer.leadingAnchor.constraint(equalTo: backgroundBlurView.contentView.leadingAnchor, constant: 20),
      scrollContainer.trailingAnchor.constraint(equalTo: backgroundBlurView.contentView.trailingAnchor, constant: -20),
    ])
  }
  
  func layoutButton() {
    backgroundBlurView.contentView.addSubview(actionButton)
    
    NSLayoutConstraint.activate([
      actionButton.heightAnchor.constraint(equalToConstant: 56),
      actionButton.leadingAnchor.constraint(equalTo: backgroundBlurView.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      actionButton.trailingAnchor.constraint(equalTo: backgroundBlurView.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      actionButton.bottomAnchor.constraint(equalTo: backgroundBlurView.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      
      // Necessary for the button to sit beneath the scroll view
      scrollContainer.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20)
    ])
  }
  
  func layoutIcon() {
    scrollContainer.addSubview(iconContainer)
    iconContainer.addSubview(iconView)
        
    NSLayoutConstraint.activate([
      // Container
      iconContainer.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
      iconContainer.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
      iconContainer.heightAnchor.constraint(equalToConstant: 110),
      iconContainer.widthAnchor.constraint(equalToConstant: 110),

      // Icon
      iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
      iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
    ])
  }
  
  func layoutTitleLabel() {
    scrollContainer.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 20),
      titleLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
      titleLabel.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor)
    ])
  }
  
  func layoutBodyText() {
    scrollContainer.addSubview(bodyTextView)
    
    NSLayoutConstraint.activate([
      bodyTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      bodyTextView.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
      bodyTextView.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor)
    ])
    
    if bodyContent == nil {
      bodyTextView.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor).isActive = true
    }
  }
  
  func layoutBodyContent() {
    guard let bodyContent = bodyContent else { return }
    scrollContainer.addSubview(bodyContent)
    
    NSLayoutConstraint.activate([
      bodyContent.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 30),
      bodyContent.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
      bodyContent.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor),
      bodyContent.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
    ])
  }
  
}
