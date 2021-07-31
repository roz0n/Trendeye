//
//  CameraViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit
import Vision

enum CameraCaptureModes {
  case manual
  case smart
}

final class CameraViewController: UIViewController, UINavigationControllerDelegate {
  
  // MARK: -
  
  var selectedCaptureMode: CameraCaptureModes = .manual
  var currentImage: UIImage?
  var shootGesture: UITapGestureRecognizer?
  var albumImagePicker = UIImagePickerController()
  
  // MARK: - AVKit Properties
  
  var captureSession: AVCaptureSession!
  var captureSettings = AVCapturePhotoSettings()
  var captureFlashMode: AVCaptureDevice.FlashMode = .off
  var imageOutput = AVCapturePhotoOutput()
  var videoDataOutput = AVCaptureVideoDataOutput()
  
  var backCamera: AVCaptureDevice?
  var frontCamera: AVCaptureDevice?
  
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  var activeCaptureDevice: AVCaptureDevice! {
    didSet {
      controlsView.toggleFlashButtonState(for: activeCaptureDevice.position)
      controlsView.toggleFlashButtonIcon(to: captureFlashMode)
    }
  }
  
  // MARK: - Rectangle Detection Properties
  
  var detectionFrameContainer = CameraDetectionView()
  var detectionFrameLayer = CAShapeLayer()
  
  var isDetectionFrameVisible: Bool {
    get {
      let layers = detectionFrameContainer.layer.sublayers
      guard let layers = layers else { return false }
      
      return layers.count > 0
    }
  }
  
  //  Rectangle Detection Output Properties
  var detectionBuffer: CVImageBuffer?
  var detectionObservation: VNRectangleObservation?
  
  // MARK: - Custom View Properties
  
  var watermarkView = AppLogoView()
  var controlsView = CameraControlsView()
  let cameraErrorView = CameraErrorView()
  
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
    configureViewController()
    configurePicker()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    toggleNavigationBar(hidden: true, animated: animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    displayCameraView()
    configureContainerView()
    configureCaptureDevices()

    if !captureDeviceError {
      configureCaptureSession()
      configureLivePreview()
      startCaptureSession()
    }
    
//    SHORTCUT_PRESENT_CONFIRMATION()
//    SHORTCUT_PRESENT_CLASSIFICATION()
//    SHORTCUT_PRESENT_CATEGORY()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    toggleNavigationBar(hidden: false, animated: animated)
    hideCameraViewEndSession()
  }
  
  // MARK: - Basic Configurations
  
  fileprivate func configureViewController() {
    navigationItem.backButtonTitle = ""
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  fileprivate func configureContainerView() {
    view.backgroundColor = K.Colors.ViewBackground
  }
  
  fileprivate func configureCaptureDevices() {
    // If either of these devices fail to be initialized in `selectBestDevice`, `cameraError` will be set to true
    backCamera = selectBestDevice(for: .back)
    frontCamera = selectBestDevice(for: .front)
    
    // Set a default device, we'd like to initialize with the back camera
    activeCaptureDevice = backCamera
  }
  
  fileprivate func configurePicker() {
    // These configurations must be applied within `viewDidLoad`.
    albumImagePicker.delegate = self
    albumImagePicker.sourceType = .photoLibrary
    albumImagePicker.allowsEditing = false
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
  
  fileprivate func configureCaptureSession() {
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
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    videoPreviewLayer.videoGravity = .resizeAspectFill
    videoPreviewLayer.connection?.videoOrientation = .portrait
    videoPreviewLayer.frame = cameraView.frame
    videoPreviewLayer.zPosition = 1
    cameraView.layer.addSublayer(videoPreviewLayer)
  }
  
  fileprivate func startCaptureSession() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.captureSession.startRunning()
    }
  }
  
  // MARK: - Smart Capture Methods
  
  fileprivate func convertNormalizedCoordinates(rect: CGRect) -> CGRect {
    // Convert coordinates from Vision's normalized coordinate system to that of the videoPreviewLayer
    let origin = videoPreviewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
    let size = videoPreviewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
    
    return CGRect(origin: origin, size: size.cgSize)
  }
  
  fileprivate func handleRectangleDetection(request: VNRequest, error: Error?) {
    DispatchQueue.main.async { [weak self] in
      guard let results = request.results as? [VNRectangleObservation], let firstResult = results.first else {
        self?.removeDetectionFrame()
        return
      }
      
      // TODO: Don't add these calls to an async queue, instead debounce this method call properly
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
        // Set the VNRectangleObservation we're keeping track of as this will later be used to capture the image
        self?.detectionObservation = firstResult
        // Handle creation of the visual frame
        self?.handleDetectionFramePresentation(rect: firstResult)
      }
    }
  }
  
  fileprivate func handleDetectionFramePresentation(rect: VNRectangleObservation) {
    let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.videoPreviewLayer.frame.height)
    let scale = CGAffineTransform.identity.scaledBy(x: self.videoPreviewLayer.frame.width, y: self.videoPreviewLayer.frame.height)
    let bounds = rect.boundingBox.applying(scale).applying(transform)
    
    if !isDetectionFrameVisible {
      // Detection frame layer is being added for the first time
      createNewDetectionFrame(with: bounds)
      return
    } else {
      // Detection frame layer is already present, update its bounds
      UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseOut) { [weak self] in
        self?.detectionFrameLayer.frame = bounds
      }
    }
  }
  
  fileprivate func createNewDetectionFrame(with bounds: CGRect) {
    detectionFrameLayer = CAShapeLayer()
    detectionFrameLayer.frame = bounds
    detectionFrameLayer.cornerRadius = 10
    detectionFrameLayer.opacity = 0.75
    detectionFrameLayer.borderColor = UIColor.systemBlue.withAlphaComponent(0.35).cgColor
    detectionFrameLayer.borderWidth = 5.0
    detectionFrameContainer.layer.insertSublayer(detectionFrameLayer, at: 1)
  }
  
  fileprivate func removeDetectionFrame() {
    detectionFrameLayer.removeFromSuperlayer()
  }
  
  func performPerspectiveCorrection(_ observation: VNRectangleObservation, from buffer: CVImageBuffer) -> UIImage? {
    // Credit: https://stackoverflow.com/questions/48170950/how-can-i-take-a-photo-of-a-detected-rectangle-in-apple-vision-framework
    var ciImage = CIImage(cvImageBuffer: buffer)
    
    let topLeft = observation.topLeft.scaled(to: ciImage.extent.size)
    let topRight = observation.topRight.scaled(to: ciImage.extent.size)
    let bottomLeft = observation.bottomLeft.scaled(to: ciImage.extent.size)
    let bottomRight = observation.bottomRight.scaled(to: ciImage.extent.size)
    
    ciImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
      "inputTopLeft": CIVector(cgPoint: topLeft),
      "inputTopRight": CIVector(cgPoint: topRight),
      "inputBottomLeft": CIVector(cgPoint: bottomLeft),
      "inputBottomRight": CIVector(cgPoint: bottomRight),
    ])
    
    let context = CIContext()
    let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
    
    guard let cgImage = cgImage else {
      return nil
    }
    
    return UIImage(cgImage: cgImage)
  }
  
  // MARK: - Helpers
  
  func displayCameraView() {
    view.isHidden = false
  }
  
  func hideCameraViewEndSession() {
    view.isHidden = true
    captureSession.stopRunning()
    videoDataOutput.setSampleBufferDelegate(nil, queue: nil)
  }
  
  func toggleNavigationBar(hidden: Bool, animated: Bool) {
    navigationController?.setNavigationBarHidden(hidden, animated: animated)
  }
  
  func toggleFlashMode() {
    switch captureFlashMode {
      case .on:
        captureFlashMode = .off
        controlsView.toggleFlashButtonIcon(to: .off)
      case .off:
        captureFlashMode = .on
        controlsView.toggleFlashButtonIcon(to: .on)
      default:
        break
    }
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

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // Extract frame
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    
    // Set the CVImageBuffer we're we're keeping track of as this will later be used to capture the image
    detectionBuffer = imageBuffer
    
    // Prepare Vision request
    let detectRectanglesRequest = VNDetectRectanglesRequest(completionHandler: handleRectangleDetection)
    detectRectanglesRequest.minimumAspectRatio = 0.0
    detectRectanglesRequest.maximumAspectRatio = 1.0
    detectRectanglesRequest.minimumConfidence = 0.75
    detectRectanglesRequest.maximumObservations = 1
    
    // Perform vision request
    do {
      let sequenceRequestHandler = VNSequenceRequestHandler()
      try sequenceRequestHandler.perform([detectRectanglesRequest], on: imageBuffer, orientation: .right)
    } catch {
      print(error.localizedDescription)
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

// MARK: - Gestures

fileprivate extension CameraViewController {
  
  func applyGestures() {
    configurePickerGesture()
    configureFlashGesture()
    configureShootGesture()
    configureFlipGesture()
    configureTorchGesture()
    configureFocusGesture()
  }
  
  func configureShootGesture() {
    shootGesture = UITapGestureRecognizer(target: self, action: #selector(shootButtonTapped(_:)))
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
  
  func configureTorchGesture() {
    let torchGesture = UITapGestureRecognizer(target: self, action: #selector(torchButtonTapped))
    controlsView.torchButton.addGestureRecognizer(torchGesture)
  }
  
  func configureFlashGesture() {
    let flashGesture = UITapGestureRecognizer(target: self, action: #selector(flashButtonTapped))
    controlsView.flashButton.addGestureRecognizer(flashGesture)
  }
  
  func configureFocusGesture() {
    let focusGesture = UITapGestureRecognizer(target: self, action: #selector(cameraViewTapped(_:)))
    cameraView.addGestureRecognizer(focusGesture)
  }
  
  // MARK: -
  
  @objc func pickerButtonTapped() {
    albumImagePicker.modalPresentationStyle = .fullScreen
    present(albumImagePicker, animated: true, completion: nil)
  }
  
  @objc func flashButtonTapped() {
    print("Tapped flash button")
    toggleFlashMode()
  }
  
  @objc func shootButtonTapped(_ sender: UITapGestureRecognizer) {
    switch selectedCaptureMode {
      case .smart:
        guard let observation = detectionObservation,
              let buffer = detectionBuffer,
              let image = performPerspectiveCorrection(observation, from: buffer)?.cgImage else {
                return
              }
        
        let correctedImage = UIImage(cgImage: image, scale: 1.0, orientation: .right)
        presentConfirmationView(with: correctedImage)
      case .manual:
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        settings.flashMode = captureFlashMode
        imageOutput.capturePhoto(with: settings, delegate: self)
    }
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
  
  @objc func torchButtonTapped() {
    do {
      defer {
        activeCaptureDevice.unlockForConfiguration()
      }
      
      try activeCaptureDevice.lockForConfiguration()
      
      if activeCaptureDevice.hasTorch {
        switch activeCaptureDevice.torchMode {
          case .off:
            activeCaptureDevice.torchMode = .on
            controlsView.toggleTorchButtonIcon(to: .on)
          case .on:
            activeCaptureDevice.torchMode = .off
            controlsView.toggleTorchButtonIcon(to: .off)
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
        
        if sender.state == .ended {
          let tapLocation = sender.location(in: self.view)
          drawElipseLayer(at: tapLocation)
        }
      } catch let error {
        print("Failed to focus capture device input")
        print("\(error)")
        print("\(error.localizedDescription)")
        
        return
      }
    }
  }
  
  // TODO: Move me!
  
  func drawElipseLayer(at point: CGPoint) {
    print("DRAWINGGGGG")
    print(point)
    
    let elipse = CAShapeLayer()
    let radius: CGFloat = 20
    let path = UIBezierPath(arcCenter: point, radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi) * 4, clockwise: true)
    
    elipse.path = path.cgPath
    elipse.strokeColor = K.Colors.White.cgColor
    elipse.fillColor = K.Colors.White.cgColor
    elipse.lineWidth = 5
    elipse.strokeStart = 0
    elipse.strokeEnd = 1

    view.layer.addSublayer(elipse)
  }
  
  func animateElipseLayer(with duration: TimeInterval) {
    
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
      layoutControls()
    } else {
      layoutCaptureDeviceError()
    }
    
    layoutWatermark()
    layoutCameraDetectionView()
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
  
  func layoutCameraDetectionView() {
    view.addSubview(detectionFrameContainer)
    detectionFrameContainer.translatesAutoresizingMaskIntoConstraints = false
    detectionFrameContainer.backgroundColor = .clear
    detectionFrameContainer.isUserInteractionEnabled = false
    
    NSLayoutConstraint.activate([
      detectionFrameContainer.topAnchor.constraint(equalTo: view.topAnchor),
      detectionFrameContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      detectionFrameContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      detectionFrameContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
}
