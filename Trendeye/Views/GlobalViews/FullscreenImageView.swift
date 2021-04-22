//
//  FullscreenImageView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/21/21.
//

import UIKit

// TODO: Add an error view incase there's a failure getting the large image
class FullscreenImageView: UIViewController {
    
    var closeButton = UIButton(type: .system)
    var saveButton = UIButton(type: .system)
    
    var url: String! {
        didSet {
            self.url = url.replacingOccurrences(of: "small", with: "big")
            TECacheManager.shared.fetchAndCacheImage(from: self.url)
            imageView.image = TECacheManager.shared.imageCache.object(forKey: self.url! as NSString)
        }
    }
    
    let backgroundBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerControls: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.axis = .horizontal
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override func viewDidLoad() {
        imageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender:))))
        applyConfigurations()
        applyLayouts()
    }
    
    fileprivate func applyConfigurations() {
        configureHeaderControls()
    }
    
    fileprivate func configureHeaderControls() {
        let closeImage = UIImage(systemName: K.Icons.Close)
        let saveImage = UIImage(systemName: K.Icons.Save)
        
        closeButton.addTarget(self, action: #selector(handleCloseTap), for: .touchUpInside)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.tintColor = K.Colors.White
        
        saveButton.addTarget(self, action: #selector(handleSaveTap), for: .touchUpInside)
        saveButton.setImage(saveImage, for: .normal)
        saveButton.tintColor = K.Colors.White
    }
    
    // MARK: - Gestures
    
    @objc func handleCloseTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSaveTap() {
        // TODO: Show an alert once the image is saved
        guard let image = self.imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    @objc func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        switch sender.state {
            case .changed:
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) { [weak self] in
                    self?.imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
                }
            case .ended:
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) { [weak self] in
                    self?.imageView.transform = .identity
                }
            default:
                return
        }
    }
    
}

// MARK: - Layout

fileprivate extension FullscreenImageView {
    
    func applyLayouts() {
        layoutBackgroundBlurView()
        layoutHeaderBlurView()
        layoutHeaderControls()
        layoutImageView()
    }
    
    func layoutBackgroundBlurView() {
        view.addSubview(backgroundBlurView)
        NSLayoutConstraint.activate([
            backgroundBlurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundBlurView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundBlurView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func layoutHeaderBlurView() {
        let headerHeight: CGFloat = 72
        view.addSubview(headerBlurView)
        NSLayoutConstraint.activate([
            headerBlurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerBlurView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerBlurView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerBlurView.heightAnchor.constraint(equalToConstant: headerHeight)
        ])
    }
    
    func layoutHeaderControls() {
        let padding: CGFloat = 20
        headerBlurView.contentView.addSubview(headerControls)
        headerControls.addArrangedSubview(closeButton)
        headerControls.addArrangedSubview(saveButton)
        NSLayoutConstraint.activate([
            headerControls.topAnchor.constraint(equalTo: headerBlurView.contentView.topAnchor),
            headerControls.leadingAnchor.constraint(equalTo: headerBlurView.contentView.leadingAnchor, constant: padding),
            headerControls.trailingAnchor.constraint(equalTo: headerBlurView.contentView.trailingAnchor, constant: -(padding)),
            headerControls.bottomAnchor.constraint(equalTo: headerBlurView.contentView.bottomAnchor)
        ])
    }
    
    func layoutImageView() {
        let padding: CGFloat = 20
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(padding)),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(padding))
        ])
    }
    
}
