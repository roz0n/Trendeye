//
//  ClassificationTableFooterView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/15/21.
//

import UIKit

class ClassificationTableFooterView: UITextView {
  
  // MARK: - Initializers
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    
    backgroundColor = .clear
    alpha = 0.35
    font = UIFont.boldSystemFont(ofSize: 14)
    text = "Powered by data from TrendList.org"
    textAlignment = .center
    textContainer?.maximumNumberOfLines = 1
    textContainer?.lineFragmentPadding = 0
    textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    isUserInteractionEnabled = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
