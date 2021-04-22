//
//  FullscreenImageView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/21/21.
//

import UIKit

// TODO: Add error view incase there's a failure getting the large image
class FullscreenImageView: UIViewController {
    
    var url: String! {
        didSet {
            self.url = url.replacingOccurrences(of: "small", with: "big")
            TECacheManager.shared.fetchAndCacheImage(from: self.url)
            imageView.image = TECacheManager.shared.imageCache.object(forKey: self.url! as NSString)
        }
    }
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func viewDidLoad() {
        applyLayouts()
    }
    
}

// MARK: - Layout

fileprivate extension FullscreenImageView {
    
    func applyLayouts() {
        layoutBlurView()
        layoutImageView()
    }
    
    func layoutBlurView() {
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

