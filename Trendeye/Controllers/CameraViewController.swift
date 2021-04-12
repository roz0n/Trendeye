//
//  CameraViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit

final class CameraViewController: UIViewController, UIGestureRecognizerDelegate, AVCapturePhotoCaptureDelegate {
    
    var captureSession: AVCaptureSession!
    var imageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var controlsView = CameraControlsView()
    
    var shootGesture: UITapGestureRecognizer?
    
    var cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        applyLayouts()
        applyGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureCaptureSession()
        
        // NOTE: Important that this happens here or else the capture session flickers when we return to this view
        videoPreviewLayer.frame = cameraView.frame
        videoPreviewLayer.zPosition = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        captureSession.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // If image data is nil, return
        // If not, we can proccess it as raw data by calling AVCapturePhoto's `fileDataRepresentation()` method and intializing a new UIImage
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        
        // Set a UIImage thumbnail if needed or present in the UI and adjust its aspect ratio
        let thumbnail = controlsView.galleryThumbnail
        thumbnail.image = image
        thumbnail.contentMode = .scaleAspectFill
        
        if let image = image {
            presentPhotoConfirmation(with: image)
        }
    }
    
    func presentPhotoConfirmation(with photo: UIImage) {
        let confirmationViewController = ConfirmationViewController()
        confirmationViewController.selectedPhoto = photo
        confirmationViewController.navigationItem.title = "Confirm Photo"
        
        navigationItem.hidesBackButton = true
        navigationController?.pushViewController(confirmationViewController, animated: true)
    }
    
    // MARK: - Gestures
    
    func applyGestures() {
        configureShootGesture()
    }
    
    func configureShootGesture() {
        shootGesture = UITapGestureRecognizer(target: self, action: #selector(shootButtonTapped))
        shootGesture?.delegate = self
        controlsView.shootButton.addGestureRecognizer(shootGesture!)
    }
    
    @objc func shootButtonTapped() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        imageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
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
            imageOutput = AVCapturePhotoOutput()
            
            let canInputOutputWithDevice = captureSession.canAddInput(input) && captureSession.canAddOutput(imageOutput)
            
            if canInputOutputWithDevice {
                captureSession.addInput(input)
                captureSession.addOutput(imageOutput)
                configureLivePreview()
            }
        } catch let error {
            print("Error - Failed to connect to input device:", error)
        }
    }
    
    /**
     This method displays what the camera sees on the screen by outputting it to a UIView.
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
        }
    }
    
}

// MARK: - Layout

fileprivate extension CameraViewController {
    
    func applyLayouts() {
        layoutCamera()
        layoutControls()
    }
    
    func layoutCamera() {
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func layoutControls() {
        cameraView.addSubview(controlsView)
        controlsView.layer.zPosition = 2
        NSLayoutConstraint.activate([
            controlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            controlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            controlsView.heightAnchor.constraint(equalToConstant: 125),
            controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
}
