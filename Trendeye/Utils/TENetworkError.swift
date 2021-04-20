//
//  TENetworkError.swift
//  Trendeye
//
//  Created by Arnaldo Rozon on 4/20/21.
//

import Foundation

enum TENetworkError: String, Error {
    case urlSessionError = "URLSession error"
    case networkError = "Failed to fetch data"
    case dataError = "Malformed data recieved from network response"
    case decoderError = "Failed to decode data"
}
