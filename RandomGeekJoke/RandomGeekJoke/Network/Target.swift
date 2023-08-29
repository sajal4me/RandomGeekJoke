//
//  Target.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Foundation

internal enum Target {
    case joke
}

extension Target: Endpoint {
    enum Method: String {
        case get = "GET"
    }
    
    var scheme: String {
        return "https"
    }
    
    var baseURL: String{
        return "geek-jokes.sameerkumar.website"
    }
    
    var path: String {
        switch self {
        case .joke:
            return "/api"
        }
    }
    
    var parameters: [URLQueryItem] {
        let param = [String: String]()
        return param.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
    }
    
    var method: String {
        switch self {
        case .joke:
            return Method.get.rawValue
        }
    }
}
