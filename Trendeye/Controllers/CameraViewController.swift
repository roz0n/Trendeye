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
  
  // MARK: - General Properties
  
  var selectedCaptureMode: CameraCaptureModes = .manual
  var currentImage: UIImage?
  var shootGesture: UITapGestureRecognizer?
  var albumImagePicker = UIImagePickerController()
  
  // MARK: - AVKit Properties
  
  var captureSession: AVCaptureSession!
  var captureSettings = AVCapturePhotoSettings()
  var captureFlashMode: AVCaptureDevice.FlashMode = .off
  var captureActiveZoom: CGFloat = 1.0
  let captureMinZoom: CGFloat = 1.0
  let captureMaxZoom: CGFloat = 3.0
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
  var detectionBuffer: CVImageBuffer?
  var detectionObservation: VNRectangleObservation?
  
  var isDetectionFrameVisible: Bool {
    get {
      let layers = detectionFrameContainer.layer.sublayers
      guard let layers = layers else { return false }
      
      return layers.count > 0
    }
  }
  
  // MARK: - Views
  
  let watermarkView = AppLogoView()
  let controlsView = CameraControlsView()
  let cameraErrorView = CameraErrorView()
  let welcomeModalDefaultsKey = "showWelcomeModal"
  
  let welcomeModalView: InfoModalViewController = {
    let view = InfoModalViewController(
      iconSymbol: K.Icons.Eyes,
      titleText: CameraViewStrings.welcomeModalTitle,
      bodyText: CameraViewStrings.welcomeModalBody,
      buttonText: CameraViewStrings.welcomeButtonText, dismissHandler: nil)
    view.modalPresentationStyle = .formSheet
    view.modalTransitionStyle = .crossDissolve
    return view
  }()
  
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
    
    configureWelcomeView()
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
    requestDeviceAccess()
    
    if !captureDeviceError {
      configureCaptureDevices()
      configureCaptureSession()
      configureLivePreview()
      startCaptureSession()
      presentWelcomeModal()
    }
    
    // SHORTCUT_PRESENT_CONFIRMATION()
    // SHORTCUT_PRESENT_CLASSIFICATION()
    // SHORTCUT_PRESENT_CATEGORY()
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
    view.backgroundColor = K.Colors.Background
  }
  
  fileprivate func configureWelcomeView() {
    welcomeModalView.dismissHandler = setWelcomeModalVisibility
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
  
  fileprivate func requestDeviceAccess() {
    let cameraUsageStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    if cameraUsageStatus != .authorized {
      AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        DispatchQueue.main.async {
          if granted {
            self?.captureDeviceError = false
          } else {
            self?.captureDeviceError = true
            print("User did not grant camera access")
          }
        }
      }
    }
  }
  
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
      } else {
        captureDeviceError = true
      }
    } catch let error {
      captureDeviceError = true
      print("Failed to connect to input device")
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
  
  func presentWelcomeModal() {
    let shouldShowModal = TEDefaultsManager.shared.get(key: welcomeModalDefaultsKey, as: Bool())
    
    if shouldShowModal == true || shouldShowModal == nil {
      present(welcomeModalView, animated: true, completion: nil)
    }
  }
  
  func setWelcomeModalVisibility() {
    TEDefaultsManager.shared.set(key: welcomeModalDefaultsKey, value: false)
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
  
  func drawFocusShape(at point: CGPoint) {
    let elipse = CAShapeLayer()
    let radius: CGFloat = 24
    let path = UIBezierPath(arcCenter: point, radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi) * 4, clockwise: true)
    
    elipse.path = path.cgPath
    elipse.strokeColor = K.Colors.White.cgColor
    elipse.fillColor = UIColor.clear.cgColor
    elipse.lineWidth = 2
    
    // All values to represent the initial state as this will be animated
    elipse.opacity = 1
    elipse.strokeStart = 0
    elipse.strokeEnd = 0
    
    view.layer.addSublayer(elipse)
    animateFocusShape(elipse, for: 0.30)
  }
  
  // Return zoom value between the minimum and maximum zoom values
  func getZoomValue(_ factor: CGFloat, device: AVCaptureDevice) -> CGFloat {
    // Credit: https://stackoverflow.com/a/42928452
    return min(min(max(factor, captureMinZoom), captureMaxZoom), device.activeFormat.videoMaxZoomFactor)
  }
  
  // MARK: - Confirmation View
  
  fileprivate func presentConfirmationView(with image: UIImage) {
    let confirmationViewController = ConfirmationViewController()
    let acceptButton = confirmationViewController.controlsView.acceptButton
    let denyButton = confirmationViewController.controlsView.denyButton
    
    acceptButton?.addTarget(self, action: #selector(handleAcceptTap), for: .touchUpInside)
    denyButton?.addTarget(self, action: #selector(handleDenyTap), for: .touchUpInside)
    
    confirmationViewController.selectedImage = image
    confirmationViewController.navigationItem.title = CameraViewStrings.conformationViewTitle
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
      classificationViewController.title = CameraViewStrings.classificationViewTitle
      
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
      print("Error performing vision request")
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
    configurePinchGesture()
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
  
  func configurePinchGesture() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(cameraViewPinched(_:)))
    view.addGestureRecognizer(pinchGesture)
  }
  
  // MARK: -
  
  @objc func pickerButtonTapped() {
    albumImagePicker.modalPresentationStyle = .fullScreen
    present(albumImagePicker, animated: true, completion: nil)
  }
  
  @objc func flashButtonTapped() {
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
      print("Error toggling torch")
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
          drawFocusShape(at: tapLocation)
        }
      } catch let error {
        print("Failed to focus capture device input")
        print("\(error.localizedDescription)")
        
        return
      }
    }
  }
  
  @objc func cameraViewPinched(_ pinch: UIPinchGestureRecognizer) {
    // Credit: https://stackoverflow.com/a/42928452
    guard let device = self.activeCaptureDevice else { return }
    
    func updateZoomFactor(scale factor: CGFloat) {
      do {
        try device.lockForConfiguration()
        defer { device.unlockForConfiguration() }
        device.videoZoomFactor = factor
      } catch {
        print("Error updating zoom factor: \(error.localizedDescription)")
      }
    }
    
    let newScaleFactor = getZoomValue(pinch.scale * captureActiveZoom, device: device)
    
    switch pinch.state {
      case .began:
        fallthrough
      case .changed:
        updateZoomFactor(scale: newScaleFactor)
      case .ended:
        captureActiveZoom = getZoomValue(newScaleFactor, device: device)
        updateZoomFactor(scale: captureActiveZoom)
      default:
        break
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
  
  func animateFocusShape(_ layer: CAShapeLayer, for duration: TimeInterval) {
    // Use CATransaction to initiate an atomic operation and add a completion handling closure
    CATransaction.begin()
    
    CATransaction.setCompletionBlock {
      layer.removeFromSuperlayer()
    }
    
    // Create and configure stroke animation
    let strokeAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
    strokeAnimation.duration = duration // stagger the stroke animation a bit
    strokeAnimation.fromValue = 0
    strokeAnimation.toValue = 1
    strokeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    
    // Create and configure opacity animation
    let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.opacity))
    opacityAnimation.duration = duration
    opacityAnimation.fromValue = 1
    opacityAnimation.toValue = 0
    opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    
    // Set final state
    layer.strokeEnd = 1
    layer.opacity = 0
    
    // Add animations
    layer.add(strokeAnimation, forKey: "stroke")
    layer.add(opacityAnimation, forKey: "opacity")
    
    // Commit the transaction
    CATransaction.commit()
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
