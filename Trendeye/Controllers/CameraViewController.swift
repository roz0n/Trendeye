//
//  CameraViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit

final class CameraViewController: UIViewController, UINavigationControllerDelegate {
  
  // MARK: - AVKit Members
  
  var captureSession: AVCaptureSession!
  var imageOutput: AVCapturePhotoOutput!
  var activeCaptureDevice: AVCaptureDevice!
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  
  // Devices
  var backCamera: AVCaptureDevice?
  var frontCamera: AVCaptureDevice?
  
  // MARK: - UI Members
  
  var watermarkView = AppLogoView()
  var controlsView = CameraControlsView()
  let cameraErrorView = CameraErrorView()

  // MARK: - Other Members
  
  var shootGesture: UITapGestureRecognizer?
  var picker = UIImagePickerController()
  var currentImage: UIImage?
  
  // MARK: - Camera UI Members
  
  var cameraError = false {
    didSet {
      applyLayouts()
      view.layoutSubviews()
    }
  }
  
  var cameraErrorContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var cameraView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    applyGestures()
    applyAnimations()
    applyLayouts()
    configurePicker()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showCameraView()
    applyConfigurations()
    
    //    self.SHORTCUT_PRESENT_CATEGORY()
    //    self.SHORTCUT_PRESENT_CLASSIFICATION()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
    hideCameraViewAndStopSession()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  // MARK: - Basic Configurations
  
  fileprivate func applyConfigurations() {
    // Apply container view styling
    configureView()
    // Set back and front devices
    configureDevices()
    
    if !cameraError {
      configureInitialCaptureSession()
      configureVideoPreview()
    }
  }
  
  fileprivate func configureView() {
    view.backgroundColor = K.Colors.ViewBackground
  }
  
  fileprivate func configureDevices() {
    // If either of these devices fail to be initialized in `selectBestDevice`, `cameraError` will be set to true
    backCamera = selectBestDevice(for: .back)
    frontCamera = selectBestDevice(for: .front)
    
    // Set a default device, we'd like to initialize with the back camera
    activeCaptureDevice = backCamera
  }
  
  // MARK: - Opinionated Configurations
  
  fileprivate func configureVideoPreview() {
    /**
     This configuration must be applied within `viewDidAppear` or else the frame growth animation
     occurs over the live preview a second time when we navigate back to this view.
     */
    videoPreviewLayer.frame = cameraView.frame
    videoPreviewLayer.zPosition = 1
  }
  
  fileprivate func configurePicker() {
    /**
     These configurations must be applied within `viewDidLoad`.
     */
    picker.delegate = self
    picker.sourceType = .photoLibrary
    picker.allowsEditing = false
  }
  
  // MARK: - Capture Session Configuration
  
  fileprivate func selectBestDevice(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let discoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: [
        .builtInTrueDepthCamera,
        .builtInDualCamera,
        .builtInWideAngleCamera],
      mediaType: .video,
      position: .unspecified)
    
    guard !discoverySession.devices.isEmpty else {
      self.cameraError = true
      print("Unable to obtain any capture devices")
      return nil
    }
    
    return discoverySession.devices.first { device in device.position == position }
  }
  
  fileprivate func configureInitialCaptureSession() {
    // Initialize the capture session with a quality preset
    captureSession = AVCaptureSession()
    captureSession.sessionPreset = .high
        
    do {
      // Attach the capture device (front or back camera) to the session
      // The value of `activeCaptureDevice` is set within `configureDevices`
      let input = try AVCaptureDeviceInput(device: activeCaptureDevice)
      imageOutput = AVCapturePhotoOutput()
            
      if captureSession.canAddInput(input) && captureSession.canAddOutput(imageOutput) {
        captureSession.addInput(input)
        captureSession.addOutput(imageOutput)
        configureLivePreview()
      }
    } catch let error {
      cameraError = true
      print("Failed to connect to input device")
      print("\(error)")
      print("\(error.localizedDescription)")
    }
  }
  
  fileprivate func configureLivePreview() {
    // This method displays the device output on a UIView
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    videoPreviewLayer.videoGravity = .resizeAspectFill
    videoPreviewLayer.connection?.videoOrientation = .portrait
    cameraView.layer.addSublayer(videoPreviewLayer)
    
    // Start the capture session on a background thread
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.captureSession.startRunning()
    }
  }
  
  // MARK: - Camera Helpers
  
  public func hideCameraViewAndStopSession() {
    view.isHidden = true
    captureSession.stopRunning()
  }
  
  public func showCameraView() {
    view.isHidden = false
  }
  
  // MARK: - Confirmation View
  
  fileprivate func presentConfirmationView(with image: UIImage) {
    let confirmationViewController = ConfirmationViewController()
    let acceptButton = confirmationViewController.controlsView.acceptButton
    let denyButton = confirmationViewController.controlsView.denyButton
    
    acceptButton?.addTarget(self, action: #selector(handleAcceptTap), for: .touchUpInside)
    denyButton?.addTarget(self, action: #selector(handleDenyTap), for: .touchUpInside)
    
    confirmationViewController.selectedImage = image
    confirmationViewController.navigationItem.title = "Confirm Photo"
    confirmationViewController.modalPresentationStyle = .overFullScreen
    
    currentImage = image
    videoPreviewLayer.isHidden = true
    captureSession.stopRunning()
    
    present(confirmationViewController, animated: true, completion: nil)
  }
  
  @objc func handleAcceptTap() {
    dismiss(animated: false) { [weak self] in
      let classificationViewController = ClassificationViewController(with: (self?.currentImage)!)
      classificationViewController.navigationItem.hidesBackButton = true
      classificationViewController.title = "Trend Analysis"
      self?.navigationController?.pushViewController(classificationViewController, animated: true)
    }
  }
  
  @objc func handleDenyTap() {
    dismiss(animated: false) { [weak self] in
      self?.currentImage = nil
      self?.videoPreviewLayer.isHidden = false
      self?.captureSession.startRunning()
    }
  }
  
  // MARK: - Gestures
  
  fileprivate func applyGestures() {
    configureShootGesture()
    configurePickerGesture()
    configureFlipGesture()
    configureFlashGesture()
  }
  
  fileprivate func configureShootGesture() {
    shootGesture = UITapGestureRecognizer(target: self, action: #selector(shootButtonTapped))
    controlsView.shootButton.addGestureRecognizer(shootGesture!)
  }
  
  fileprivate func configurePickerGesture() {
    let pickerGesture = UITapGestureRecognizer(target: self, action: #selector(pickerButtonTapped))
    controlsView.galleryButton.addGestureRecognizer(pickerGesture)
  }
  
  fileprivate func configureFlipGesture() {
    let flipGesture = UITapGestureRecognizer(target: self, action: #selector(flipButtonTapped))
    controlsView.flipButton.addGestureRecognizer(flipGesture)
  }
  
  fileprivate func configureFlashGesture() {
    let flashGesture = UITapGestureRecognizer(target: self, action: #selector(flashButtonTapped))
    controlsView.flashButton.addGestureRecognizer(flashGesture)
  }
  
  @objc func shootButtonTapped() {
    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    imageOutput.capturePhoto(with: settings, delegate: self)
  }
  
  @objc func pickerButtonTapped() {
    picker.modalPresentationStyle = .fullScreen
    present(picker, animated: true, completion: nil)
  }
  
  @objc func flipButtonTapped() {
    // Set new capture device
    switch activeCaptureDevice.position {
      case .front:
        activeCaptureDevice = backCamera
      case .back:
        activeCaptureDevice = frontCamera
      default:
        break
    }
    
    // Make sure the session has at least one input already, this might be a lil extra, but better safe than sorry
    guard let currentInput = captureSession.inputs.first else { return }

    captureSession.beginConfiguration()
    captureSession.removeInput(currentInput)
    
    do {
      let input = try AVCaptureDeviceInput(device: activeCaptureDevice)
      captureSession.addInput(input)
    } catch let error {
      cameraError = true
      print("Failed to swap capture session device")
      print("\(error)")
      print("\(error.localizedDescription)")
    }
    
    captureSession.commitConfiguration()
  }
  
  @objc func flashButtonTapped() {
    guard let device = activeCaptureDevice else { return }
    
    do {
      defer {
        device.unlockForConfiguration()
      }
      
      try device.lockForConfiguration()
      
      if device.hasTorch {
        switch device.torchMode {
          case .off:
            device.torchMode = .on
          case .on:
            device.torchMode = .off
          case .auto:
            device.torchMode = .off
          default:
            break
        }
      } else {
        return
      }
    } catch let error {
      print("\(error)")
      print("\(error.localizedDescription)")
    }
  }
  
}

// MARK: - UIImagePickerControllerDelegate

extension CameraViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true) { [weak self] in
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        self?.presentConfirmationView(with: image)
      }
    }
  }
  
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard let imageData = photo.fileDataRepresentation() else { return }
    let image = UIImage(data: imageData)
    
    if let image = image {
      currentImage = image
      presentConfirmationView(with: image)
    }
  }
  
}

// MARK: - Animations

fileprivate extension CameraViewController {
  
  func applyAnimations() {
    animateWatermark()
  }
  
  func animateWatermark() {
    watermarkView.transform = CGAffineTransform(translationX: 0, y: -125)
    watermarkView.layer.opacity = 0
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) { [weak self] in
      self?.view.layoutIfNeeded()
      self?.watermarkView.transform = .identity
      self?.watermarkView.layer.opacity = 0.35
    }
  }
  
}

// MARK: - Layout

fileprivate extension CameraViewController {
  
  func applyLayouts() {
    if !cameraError {
      layoutCamera()
      layoutControls()
    } else {
      layoutCameraError()
    }
    layoutWatermark()
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
  
  func layoutCameraError() {
    let padding: CGFloat = 16
    
    view.addSubview(cameraErrorContainer)
    cameraErrorContainer.fillOther(view: view)
    cameraErrorContainer.addSubview(cameraErrorView)
    
    if controlsView.isDescendant(of: view) {
      controlsView.removeFromSuperview()
    }
    
    NSLayoutConstraint.activate([
      cameraErrorView.centerYAnchor.constraint(equalTo: cameraErrorContainer.centerYAnchor),
      cameraErrorView.leadingAnchor.constraint(equalTo: cameraErrorContainer.leadingAnchor, constant: padding),
      cameraErrorView.trailingAnchor.constraint(equalTo: cameraErrorContainer.trailingAnchor, constant: -(padding))
    ])
  }
  
  func layoutWatermark() {
    let watermarkHeight: CGFloat = 25
    
    view.addSubview(watermarkView)
    NSLayoutConstraint.activate([
      watermarkView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: watermarkHeight),
      watermarkView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      watermarkView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      watermarkView.heightAnchor.constraint(equalToConstant: watermarkHeight)
    ])
  }
  
  func layoutControls() {
    let controlsHeight: CGFloat = 125
    let controlsPadding: CGFloat = 12
    
    cameraView.addSubview(controlsView)
    controlsView.layer.zPosition = 2
    NSLayoutConstraint.activate([
      controlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      controlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      controlsView.heightAnchor.constraint(equalToConstant: controlsHeight),
      controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(controlsPadding))
    ])
  }
  
}
