//
//  ResultsViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 2/21/21.
//

import UIKit

class ResultsViewController: UIViewController {
    
    let container: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        return view
    }()
    
    let stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 10
        view.backgroundColor = .systemPink
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureStack()
        configureLayout()
    }
    
}

// MARK: - Layout

private extension ResultsViewController {
    
    func configureStack() {
        for _ in 1...60 {
            let panel = ResultsPanel()
            stack.addArrangedSubview(panel)
        }
    }
    
    func configureLayout() {
        view.addSubview(container)
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: container.widthAnchor)
        ])
    }
    
}
