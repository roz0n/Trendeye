//
//  ClassificationTableFooterView.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/15/21.
//

import UIKit

class ClassificationTableFooterView: UITextView {
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    text = "Powered by data from TrendList.org"
    font = UIFont.boldSystemFont(ofSize: 14)
    textAlignment = .center
    textContainer?.maximumNumberOfLines = 1
    textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    textContainer?.lineFragmentPadding = 0
    backgroundColor = .clear
    alpha = 0.35
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
