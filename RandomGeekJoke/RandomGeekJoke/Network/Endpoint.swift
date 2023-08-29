//
//  Endpoint.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Foundation

internal protocol Endpoint {
    
    var scheme: String { get }
    
    var baseURL: String { get }
    
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
    
    var method: String { get }
}
