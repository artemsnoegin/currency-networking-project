//
//  NetworkServiceError.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 04.12.2025.
//

import Foundation

enum NetworkServiceError: Error {
    case network(error: Error)
    case decoding(error: Error)
    case server(message: String)
    case invalidResponse
    case invalidData
    case invalidURL
    case invalidResponseErrorMessage
}

extension NetworkServiceError: LocalizedError {
    static let undefinedErrorMessage = "NetworkService error: undefined"
    
    var errorDescription: String? {
        switch self {
        case .network(let error): return "NetworkService error: \(error.localizedDescription)"
        case .decoding(let error): return "NetworkService error: \(error.localizedDescription)"
        case .server(let message): return "NetworkService error: \(message)"
        case .invalidResponse: return "NetworkService error: invalid response"
        case .invalidData: return "NetworkService error: invalid data"
        case .invalidURL: return "NetworkService error: invalid URL"
        case .invalidResponseErrorMessage: return "NetworkService error: invalid response message"
        }
    }
    
    var userMessage: String {
        switch self {
        case .network:
            return "Internet connection issues\nPull down to restart"
        case .server:
            return "The server is temporarily unavailable\nPull down to restart"
        case .decoding, .invalidData:
            return "Something went wrong\nPull down to restart"
        case .invalidURL, .invalidResponse, .invalidResponseErrorMessage:
            return "An unexpected error occurred\nPull down to restart"
        }
    }
}
