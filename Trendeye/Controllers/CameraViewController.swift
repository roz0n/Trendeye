//
//  CameraViewController.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/8/21.
//

import UIKit
import AVKit

final class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
  
  var captureSession: AVCaptureSession!
  var imageOutput: AVCapturePhotoOutput!
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  var watermarkView = AppLogoView()
  var controlsView = CameraControlsView()
  var shootGesture: UITapGestureRecognizer?
  var picker = UIImagePickerController()
  var currentImage: UIImage?
  let cameraErrorView = CameraErrorView()
  
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
    showCamera()
    applyConfigurations()
    //        SHORTCUT_PRESENT_CATEGORY()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
    dismissCamera()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  // MARK: - Basic Configurations
  
  fileprivate func applyConfigurations() {
    configureView()
    configureCaptureSession()
    
    if !cameraError {
      configureVideoPreview()
    }
  }
  
  fileprivate func configureView() {
    view.backgroundColor = K.Colors.ViewBackground
  }
  
  // MARK: - Opinionated Configurations
  
  fileprivate func configureVideoPreview() {
    /**
     NOTE: This configuration must be set within `viewDidAppear` or else the frame growth animation
     occurs over the live preview a second time when we navigate back to this view.
     */
    videoPreviewLayer.frame = cameraView.frame
    videoPreviewLayer.zPosition = 1
  }
  
  fileprivate func configurePicker() {
    /**
     NOTE: This configuration must be set within `viewDidLoad`.
     */
    picker.delegate = self
    picker.sourceType = .photoLibrary
    picker.allowsEditing = false
  }
  
  // MARK: - Capture Session Configuration
  
  fileprivate func configureCaptureSession() {
    captureSession = AVCaptureSession()
    captureSession.sessionPreset = .high
    
    guard let rearCamera = AVCaptureDevice.default(for: .video) else {
      cameraError = true
      print("Error: Unable to access back camera")
      return
    }
    
    /**
     `AVCaptureDeviceInput` attaches the input device to the session.
     */
    do {
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
      cameraError = true
      print("Error: Failed to connect to input device", error)
    }
  }
  
  /**
   This method outputs the camera onto a UIView.
   */
  fileprivate func configureLivePreview() {
    // Set the video preview layer to an AVCaptureVideoPreviewLayer with the session attached
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
  
  public func dismissCamera() {
    view.isHidden = true
    captureSession.stopRunning()
  }
  
  public func showCamera() {
    view.isHidden = false
  }
  
  // MARK: - AVSession Photo Output & Image Picker Selection
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard let imageData = photo.fileDataRepresentation() else { return }
    let image = UIImage(data: imageData)
    
    if let image = image {
      currentImage = image
      presentPhotoConfirmation(with: image)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true) { [weak self] in
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        self?.presentPhotoConfirmation(with: image)
      }
    }
  }
  
  // MARK: - Confirmation View
  
  fileprivate func presentPhotoConfirmation(with image: UIImage) {
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
  }
  
  fileprivate func configureShootGesture() {
    shootGesture = UITapGestureRecognizer(target: self, action: #selector(shootButtonTapped))
    controlsView.shootButton.addGestureRecognizer(shootGesture!)
  }
  
  fileprivate func configurePickerGesture() {
    let pickerGesture = UITapGestureRecognizer(target: self, action: #selector(pickerButtonTapped))
    controlsView.galleryButton.addGestureRecognizer(pickerGesture)
  }
  
  @objc func shootButtonTapped() {
    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    imageOutput.capturePhoto(with: settings, delegate: self)
  }
  
  @objc func pickerButtonTapped() {
    picker.modalPresentationStyle = .fullScreen
    present(picker, animated: true, completion: nil)
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
