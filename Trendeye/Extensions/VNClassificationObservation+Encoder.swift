//
//  VNClassificationObservation+Encoder.swift
//  VNClassificationObservation+Encoder
//
//  Created by Arnaldo Rozon on 8/7/21.
//

// Credit: https://heartbeat.fritz.ai/deploying-core-ml-models-using-vapor-c562a70b1371

import Vision

@available(OSX 10.13, *)
extension VNClassificationObservation: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case label
    case score
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(confidence as Float, forKey: .score)
    try container.encode(identifier, forKey: .label)
  }
  
}
