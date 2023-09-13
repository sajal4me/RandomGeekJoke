//
//  Usecase.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Combine
import Foundation

internal protocol UsecaseProtocol {
    func fetchJoke() -> AnyPublisher<String, Error>
}

internal final class Usecase: UsecaseProtocol {
    private let networkProvider: NetworkProtocol
    
    internal init(networking: NetworkProtocol = Networking()) {
        self.networkProvider = networking
    }

    func fetchJoke() -> AnyPublisher<String, Error> {
        return networkProvider
            .request(
                endpoint:
                    Target.joke,
                decoder: JSONDecoder()
            )
    }
}

