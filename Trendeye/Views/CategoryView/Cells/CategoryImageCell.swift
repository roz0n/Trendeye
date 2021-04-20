//
//  CategoryImageCellCollectionViewCell.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/17/21.
//

import UIKit

class CategoryImageCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GalleryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func applyStyles() {
        contentView.clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    public func applyBorder() {
        // This method is called externally when the cell is dequeued if needed
        layer.borderWidth = 1
        layer.borderColor = K.Colors.BorderColor?.cgColor
    }
    
}
