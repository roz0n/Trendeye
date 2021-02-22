//
//  TEClassifierManager.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 2/21/21.
//

import UIKit
import CoreML
import Vision

// TODO: Use this

enum TEClassifierError: Error {
    case modelError
    case imageError
    case processError
}

protocol TEClassifierDelegate {
    func didFinishProcessing(_: TEClassifierManager, results: [VNClassificationObservation])
    func didError(_: TEClassifierManager, error: Error?)
}

class TEClassifierManager {
    
    var delegate: TEClassifierDelegate?
    
    func processImage(_ image: CIImage) {
        let configuration = MLModelConfiguration()
        
        guard let model = try? VNCoreMLModel(for: TrendClassifier(configuration: configuration).model) else {
            // Failure loading CoreML model
            self.delegate?.didError(self, error: nil)
            return
        }
        
        let visionReq = VNCoreMLRequest(model: model) { [weak self] (request, error) in
            guard error == nil else {
                self?.delegate?.didError(self!, error: error!);
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation] else {
                // Model failed to process image
                self?.delegate?.didError(self!, error: nil)
                return
            }
            
            self?.delegate?.didFinishProcessing(self!, results: results)
        }
        
        let visionHandler = VNImageRequestHandler(ciImage: image)
        
        do {
            try visionHandler.perform([visionReq])
        } catch {
            // Failed to proccess
            self.delegate?.didError(self, error: nil)
        }
    }
    
}
