//
//  CameraViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit

class CameraViewController: UIViewController {
    
    var cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var controlsView: CameraControlsView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemPink
        configureCameraView()
        configureControlsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

// MARK: - Layout

fileprivate extension CameraViewController {
    
    func configureCameraView() {
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func configureControlsView() {
        controlsView = CameraControlsView()
        view.addSubview(controlsView)
        NSLayoutConstraint.activate([
            controlsView.topAnchor.constraint(equalTo: cameraView.bottomAnchor),
            controlsView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            controlsView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            controlsView.heightAnchor.constraint(equalToConstant: 160),
            controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
