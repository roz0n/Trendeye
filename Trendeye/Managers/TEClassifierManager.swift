//
//  TEClassifierManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 2/21/21.
//

import UIKit
import CoreML
import Vision

enum TEClassifierError: Error {
    case modelError
    case classificationError
    case handlerError
}

protocol TEClassifierDelegate {
    func didFinishClassifying(_ sender: TEClassifierManager?, results: [VNClassificationObservation])
    func didError(_ sender: TEClassifierManager?, error: Error?)
}

class TEClassifierManager {
    
    var delegate: TEClassifierDelegate?
    
    func classifyImage(_ image: CIImage) {
        let configuration = MLModelConfiguration()
        let visionHandler = VNImageRequestHandler(ciImage: image)
        
        guard let mlModel = try? VNCoreMLModel(for: TrendClassifier(configuration: configuration).model) else {
            self.delegate?.didError(self, error: TEClassifierError.modelError)
            return
        }
        
        let visionRequest = VNCoreMLRequest(model: mlModel) { [weak self] (request, error) in
            guard error == nil else {
                self?.delegate?.didError(self, error: error!);
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation] else {
                self?.delegate?.didError(self, error: TEClassifierError.classificationError)
                return
            }
            
            self?.delegate?.didFinishClassifying(self, results: results)
        }
        
        do {
            try visionHandler.perform([visionRequest])
        } catch {
            self.delegate?.didError(self, error: TEClassifierError.handlerError)
        }
    }
    
}
