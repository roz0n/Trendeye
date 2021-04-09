//
//  CameraViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit

class CameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var controlsView = CameraControlsView()
    
    var cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        layoutCameraView()
        layoutControlsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        captureSession.stopRunning()
    }
    
}

// MARK: - Capture Session Configuration

fileprivate extension CameraViewController {
    
    /**
     Coordinates the input and output data from the devices camera.
     */
    func configureCaptureSession() {
        // Create a new capture session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let rearCamera = AVCaptureDevice.default(for: .video) else {
            // TODO: Display error screen
            print("Error: Unable to access back camera")
            return
        }
        
        /**
         AVCaptureDeviceInput  serves as the middle man to attach the input device to the session.
         */
        do {
            // Create new input device
            let input = try AVCaptureDeviceInput(device: rearCamera)
            // Attach output to the capture session
            stillImageOutput = AVCapturePhotoOutput()
            
            let canInputOutputWithDevice = captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput)
            if canInputOutputWithDevice {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                configureLivePreview()
            }
        } catch let error {
            print("Error - Failed to connect to input device:", error)
        }
    }
    
    /**
     This method allows us to actually display what the camera sees on the screen by outputting it to a UIView.
     */
    func configureLivePreview() {
        // Set the video preview layer to an AVCaptureVideoPreviewLayer with the session attached
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // Configure how to resize the layer's output
        videoPreviewLayer.videoGravity = .resizeAspectFill
        // Fix the orientation to portrait
        videoPreviewLayer.connection?.videoOrientation = .portrait
        // Add the layer as a sublayer
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        // Start the capture session on a background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
            
            // Once the session has started, set the preview layer's frame to that of the container UIView on the main thread
            DispatchQueue.main.async {
                self?.videoPreviewLayer.frame = (self?.cameraView.frame)!
            }
        }
    }
    
}

// MARK: - Layout

fileprivate extension CameraViewController {
    
    func layoutCameraView() {
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func layoutControlsView() {
        view.addSubview(controlsView)
        NSLayoutConstraint.activate([
            controlsView.topAnchor.constraint(equalTo: cameraView.bottomAnchor),
            controlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            controlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            controlsView.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
    
}
