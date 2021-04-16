//
//  PhotoEnlargeButton.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/9/21.
//

import UIKit

// TODO: This should be a global class called RoundButton that ConfirmationButton and PhotoEnlargeButton inherit from

class PhotoEnlargeButton: UIButton {
    
    var height: CGFloat?
    var width: CGFloat?
    
    init(height: CGFloat, width: CGFloat) {
        super.init(frame: .zero)
        self.height = height
        self.width = width
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height),
            self.widthAnchor.constraint(equalToConstant: width)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 90),
            self.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeCircular()
    }
    
}
