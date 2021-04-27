//
//  TELogoView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/26/21.
//

import UIKit

class TELogoView: UIView {
    
    let image = UIImage(named: "AppLogo")!
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    convenience init() {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureLogoImage()
        self.applyLayouts()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureLogoImage() {
        imageView.image = UIImage(named: "AppLogo")
    }
    
}

// MARK: - Layout

fileprivate extension TELogoView {
    
    func applyLayouts() {
        layoutLogo()
    }
    
    func layoutLogo() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
