//
//  NetworkError.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Foundation

enum NetworkError: Error, Equatable {
    case noInternet
    case pageNotFound
    case underMaintenance
    case invalidURL
    case invalidData
    case decodableFail(String)
    case dataTaskError(String)
    case custom(String)
   
    internal var message: String {
        switch self {
        case .noInternet:
            return "Please try again !."
        case .pageNotFound:
            return "Please try again !."
        case .underMaintenance, .invalidData:
            return "Please try again !."
        case .invalidURL:
            return "We are not able to create the url, seems you have put wring parameter"
        case let .decodableFail(errorMessage):
            return errorMessage
        case let .dataTaskError(errorMessage):
            return errorMessage
        case let .custom(errorMessage):
            return errorMessage
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        message
    }
}
