//
//  TrendClassifierManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 2/21/21.
//

import UIKit
import CoreML
import Vision

enum ClassifierError: Error {
  case modelError
  case classificationError
  case handlerError
}

protocol ClassifierDelegate {
  func didFinishClassifying(_ sender: TrendClassifierManager?, results: inout [VNClassificationObservation])
  func didError(_ sender: TrendClassifierManager?, error: Error?)
}

class TrendClassifierManager {
  
  static let shared = TrendClassifierManager()
  var delegate: ClassifierDelegate?
  
  let indentifiers: [String: String] = [
    "ik-blue": "IK Blue",
    "letterspace": "Letterspace",
    "left-right-up-down": "Left Right Up & Down",
    "scanned": "Scanned",
    "staircase": "Staircase",
    "frame": "Frame",
    "stretched": "Stretched",
    "repetition": "Repetition",
    "neon-colors": "Neon Colors",
    "slash": "Slash",
    "flash": "Flash",
    "underlined": "Underlined",
    "gradients": "Gradients",
    "wiggles": "Wiggles",
    "type-on-path": "Type on Path",
    "randomized": "Randomized",
    "center-aligned": "Center Aligned",
    "text-on-cover": "Text on Cover",
    "hyphens": "Hyphens",
    "blank-cover": "Blank Cover",
    "table-of-contents": "Table of Contents",
    "slant": "Slant",
    "various-formats": "Various Formats",
    "outlined": "Outlined",
    "exposed-content": "Exposed Content",
    "3-d": "3D",
    "highlighted": "Highlighted",
    "strikethrough": "Strikethrough",
    "diagonal-pattern": "Diagonal Pattern",
    "rhombus": "Rhombus",
    "mickey-hands": "Mickey Hands",
    "ancient-statues": "Ancient Statues",
    "infinity-shapes": "Infinity Shapes",
    "stars": "Stars",
    "still-life": "Still Life",
    "diamonds": "Diamonds",
    "virtual-space-reality": "Virtual Space Reality",
  ]
  
  // TODO: Use Result type here
  func classifyImage(_ image: CIImage) {
    let configuration = MLModelConfiguration()
    let visionHandler = VNImageRequestHandler(ciImage: image)
    
    guard let mlModel = try? VNCoreMLModel(for: TrendClassifier(configuration: configuration).model) else {
      self.delegate?.didError(self, error: ClassifierError.modelError)
      return
    }
    
    let visionRequest = VNCoreMLRequest(model: mlModel) { [weak self] (request, error) in
      guard error == nil else {
        self?.delegate?.didError(self, error: error!);
        return
      }
      
      guard var results = request.results as? [VNClassificationObservation] else {
        self?.delegate?.didError(self, error: ClassifierError.classificationError)
        return
      }
      
      self?.delegate?.didFinishClassifying(self, results: &results)
    }
    
    do {
      try visionHandler.perform([visionRequest])
    } catch {
      self.delegate?.didError(self, error: ClassifierError.handlerError)
    }
  }
  
  func convertConfidenceToPercent(_ score: VNConfidence) -> Int {
    return Int((score * 100).rounded())
  }
  
}
