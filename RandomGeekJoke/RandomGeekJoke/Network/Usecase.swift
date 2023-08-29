//
//  Usecase.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Foundation

internal protocol UsecaseProtocol {
    func fetchJoke() async throws -> String
}


internal final class Usecase: UsecaseProtocol {
    private let networkProvider: NetworkProtocol
    
    internal init(networking: NetworkProtocol = Networking()) {
        self.networkProvider = networking
    }

    func fetchJoke() async throws -> String {
        
        let jokeModel: String = try await networkProvider
            .request(
                endpoint: Target
                    .joke,
                decoder: JSONDecoder()
            )
        
        return jokeModel
    }
}

