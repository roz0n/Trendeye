//
//  ClassifierTableHeaderView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/11/21.
//

import UIKit

class ClassifierTableHeaderView: UIView {
    
    let photoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout

fileprivate extension ClassifierTableHeaderView {
    
    func applyLayouts() {
        layoutPhotoView()
    }
    
    func layoutPhotoView() {
        addSubview(photoView)
        photoView.fillOther(view: self)
    }
    
}

