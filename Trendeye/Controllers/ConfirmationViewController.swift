//
//  ConfirmationViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

final class ConfirmationViewController: UIViewController {
    
    var selectedPhoto: UIImage!
    let blurEffect = UIBlurEffect(style: .regular)
    var blurView = UIVisualEffectView()
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
    
    var photoBackground: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        return view
    }()
    
    var photoBlurView: UIView = {
        let view = UIView()
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
        photoView.image = selectedPhoto
        photoView.contentMode = .scaleAspectFit
        photoView.clipsToBounds = true
    }
    
    fileprivate func configurePhotoBackground() {
        photoBackground.image = selectedPhoto
        photoBackground.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
    }
    
}

// MARK: - Layout

fileprivate extension ConfirmationViewController {
    
    func applyLayouts() {
        layoutHeaderView()
        layoutPhotoView()
//        layoutBlurView()
        layoutControlsView()
    }
    
    func layoutHeaderView() {
        let headerHeight: CGFloat = 100
        headerView.addSubview(headerLabel)
        headerLabel.fillOther(view: headerView)
        view.addSubview(headerView)
//        headerView.layer.zPosition = 4
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func layoutPhotoView() {
        let photoHeight: CGFloat = 545
        view.addSubview(photoBackground)
        view.addSubview(photoView)
//        photoBackground.layer.zPosition = 1
//        photoView.layer.zPosition = 3
        
        NSLayoutConstraint.activate([
            photoBackground.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            photoBackground.heightAnchor.constraint(equalToConstant: photoHeight),
            photoBackground.widthAnchor.constraint(equalTo: view.widthAnchor),
            photoBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            photoView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            photoView.heightAnchor.constraint(equalToConstant: photoHeight),
            photoView.widthAnchor.constraint(equalTo: view.widthAnchor),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func layoutBlurView() {
//        blurView.effect = blurEffect
//        photoBackground.addSubview(blurView)
//        blurView.fillOther(view: photoBackground)
//        blurView.fillOther(view: view)
//        blurView.layer.zPosition = 2
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = photoBackground.frame
        view.backgroundColor = .systemGreen
        view.layer.opacity = 0.5
        self.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: 545),
            view.widthAnchor.constraint(equalTo: view.widthAnchor),
            view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func layoutControlsView() {
        let controlsPadding: CGFloat = -30
        view.addSubview(controlsView)
//        controlsView.layer.zPosition = 4
        
        NSLayoutConstraint.activate([
            controlsView.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            controlsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            controlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: controlsPadding),
            controlsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
}
