//
//  TENetworkError.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/20/21.
//

import Foundation

enum TENetworkError: String, Error {
    case urlSessionError = "Error: URLSession request failed"
    case networkError = "Error: Server returned a non-status 200 response"
    case dataError = "Error: Malformed or nil data recieved from network response"
    case decoderError = "Error: Failed to decode response data"
    case none = "Error: Category network request handler unexpectedly returned nil"
}
