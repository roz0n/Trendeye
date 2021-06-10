//
//  CameraViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit

final class CameraViewController: UIViewController, UINavigationControllerDelegate {
  
  // MARK: - AVKit Properties
  
  var captureSession: AVCaptureSession!
  var imageOutput: AVCapturePhotoOutput!
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  
  var activeCaptureDevice: AVCaptureDevice! {
    didSet {
      controlsView.toggleFlashButtonState(for: activeCaptureDevice.position)
    }
  }
  
  // Devices
  var backCamera: AVCaptureDevice?
  var frontCamera: AVCaptureDevice?
  
  // MARK: - UI Properties
  
  var watermarkView = AppLogoView()
  var controlsView = CameraControlsView()
  let cameraErrorView = CameraErrorView()
  var aspectFrameView = CameraAspectFrameView(as: .rectangle)
  
  // MARK: - Other Properties
  
  var shootGesture: UITapGestureRecognizer?
  var picker = UIImagePickerController()
  var currentImage: UIImage?
  
  // MARK: - Camera UI Properties
  
  var captureDeviceError = false {
    didSet {
      applyLayouts()
      view.layoutSubviews()
    }
  }
  
  var captureDeviceErrorContainer: UIView = {
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
    toggleNavigationBar(hidden: true, animated: animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    showCameraView()
    applyConfigurations()
    
    // self.SHORTCUT_PRESENT_CATEGORY()
    // self.SHORTCUT_PRESENT_CLASSIFICATION()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    toggleNavigationBar(hidden: false, animated: animated)
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
    
    if !captureDeviceError {
      configureInitialCaptureSession()
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
  
  fileprivate func configurePicker() {
    // These configurations must be applied within `viewDidLoad`.
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
      self.captureDeviceError = true
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
      captureDeviceError = true
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
    videoPreviewLayer.frame = cameraView.frame
    videoPreviewLayer.zPosition = 1
    cameraView.layer.addSublayer(videoPreviewLayer)
    
    // Start the capture session on a background thread
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.captureSession.startRunning()
    }
  }
  
  // MARK: - Helpers
  
  func hideCameraViewAndStopSession() {
    view.isHidden = true
    captureSession.stopRunning()
  }
  
  func toggleNavigationBar(hidden: Bool, animated: Bool) {
    navigationController?.setNavigationBarHidden(hidden, animated: animated)
  }
  
  func showCameraView() {
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
    
    var image = UIImage(data: imageData)
    image = image?.scaleToScreenSize()
    image = image?.cropInRect(aspectFrameView.contentAreaView.frame)
    
    if let image = image {
      currentImage = image
      presentConfirmationView(with: image)
    }
  }
  
}

// MARK: - Gestures

fileprivate extension CameraViewController {
  
  func applyGestures() {
    configurePickerGesture()
    configureAspectGesture()
    configureShootGesture()
    configureFlipGesture()
    configureFlashGesture()
    configureFocusGesture()
  }
  
  func configureShootGesture() {
    shootGesture = UITapGestureRecognizer(target: self, action: #selector(shootButtonTapped))
    controlsView.shootButton.addGestureRecognizer(shootGesture!)
  }
  
  func configurePickerGesture() {
    let pickerGesture = UITapGestureRecognizer(target: self, action: #selector(pickerButtonTapped))
    controlsView.galleryButton.addGestureRecognizer(pickerGesture)
  }
  
  func configureFlipGesture() {
    let flipGesture = UITapGestureRecognizer(target: self, action: #selector(flipButtonTapped))
    controlsView.flipButton.addGestureRecognizer(flipGesture)
  }
  
  func configureFlashGesture() {
    let flashGesture = UITapGestureRecognizer(target: self, action: #selector(flashButtonTapped))
    controlsView.flashButton.addGestureRecognizer(flashGesture)
  }
  
  func configureAspectGesture() {
    let aspectGesture = UITapGestureRecognizer(target: self, action: #selector(aspectButtonTapped))
    controlsView.aspectFrameButton.addGestureRecognizer(aspectGesture)
  }
  
  func configureFocusGesture() {
    let focusGesture = UITapGestureRecognizer(target: self, action: #selector(cameraViewTapped(_:)))
    cameraView.addGestureRecognizer(focusGesture)
  }
  
  // MARK: -
  
  @objc func pickerButtonTapped() {
    picker.modalPresentationStyle = .fullScreen
    present(picker, animated: true, completion: nil)
  }
  
  @objc func aspectButtonTapped() {
    print("Tapped aspect button")
  }
  
  @objc func shootButtonTapped() {
    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    imageOutput.capturePhoto(with: settings, delegate: self)
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
    
    // Make sure the session has at least one input already, better safe than sorry
    guard let currentInput = captureSession.inputs.first else { return }
    
    captureSession.beginConfiguration()
    captureSession.removeInput(currentInput)
    
    do {
      let input = try AVCaptureDeviceInput(device: activeCaptureDevice)
      captureSession.addInput(input)
    } catch let error {
      captureDeviceError = true
      print("Failed to swap capture session device")
      print("\(error)")
      print("\(error.localizedDescription)")
    }
    
    captureSession.commitConfiguration()
  }
  
  @objc func flashButtonTapped() {
    do {
      defer { activeCaptureDevice.unlockForConfiguration() }
      try activeCaptureDevice.lockForConfiguration()
      
      if activeCaptureDevice.hasTorch {
        switch activeCaptureDevice.torchMode {
          case .off:
            activeCaptureDevice.torchMode = .on
          case .on:
            activeCaptureDevice.torchMode = .off
          default:
            break
        }
      }
    } catch let error {
      print("\(error)")
      print("\(error.localizedDescription)")
    }
  }
  
  @objc func cameraViewTapped(_ sender: UITapGestureRecognizer) {
    let focusPoint = sender.location(in: cameraView)
    let scaledPointX = focusPoint.x / cameraView.frame.size.width
    let scaledPointY = focusPoint.y / cameraView.frame.size.height
    
    if activeCaptureDevice.isFocusModeSupported(.autoFocus) && activeCaptureDevice.isFocusPointOfInterestSupported {
      do {
        defer {
          activeCaptureDevice.unlockForConfiguration()
        }
        try activeCaptureDevice.lockForConfiguration()
        activeCaptureDevice.focusMode = .autoFocus
        activeCaptureDevice.focusPointOfInterest = CGPoint(x: scaledPointX, y: scaledPointY)
      } catch let error {
        print("Failed to focus capture device input")
        print("\(error)")
        print("\(error.localizedDescription)")
        return
      }
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
    if !captureDeviceError {
      layoutCamera()
      layoutImageFrame()
      layoutControls()
    } else {
      layoutCaptureDeviceError()
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
  
  func layoutCaptureDeviceError() {
    let padding: CGFloat = 16
    
    view.addSubview(captureDeviceErrorContainer)
    
    captureDeviceErrorContainer.fillOther(view: view)
    captureDeviceErrorContainer.addSubview(cameraErrorView)
    
    if controlsView.isDescendant(of: view) {
      controlsView.removeFromSuperview()
    }
    
    NSLayoutConstraint.activate([
      cameraErrorView.centerYAnchor.constraint(equalTo: captureDeviceErrorContainer.centerYAnchor),
      cameraErrorView.leadingAnchor.constraint(equalTo: captureDeviceErrorContainer.leadingAnchor, constant: padding),
      cameraErrorView.trailingAnchor.constraint(equalTo: captureDeviceErrorContainer.trailingAnchor, constant: -(padding))
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
  
  func layoutImageFrame() {
    cameraView.addSubview(aspectFrameView)
    aspectFrameView.centerRectToSuperview(view)
    aspectFrameView.layer.zPosition = 2
    
    NSLayoutConstraint.activate([
      aspectFrameView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
      aspectFrameView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
      aspectFrameView.topAnchor.constraint(equalTo: cameraView.topAnchor),
      aspectFrameView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor)
    ])
  }
  
}
