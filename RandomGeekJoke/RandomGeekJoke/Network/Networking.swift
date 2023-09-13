//
//  Networking.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Combine
import Foundation

protocol NetworkProtocol {
    func request<Output: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) -> AnyPublisher<Output, Error>
}

internal final class Networking: NetworkProtocol {
    
    func request<Output: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) -> AnyPublisher<Output, Error> {
        var component = URLComponents()
        component.scheme = endpoint.scheme
        component.host = endpoint.baseURL
        component.path = endpoint.path
        component.queryItems = endpoint.parameters
        
        guard let url = component.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .mapError { error in
                return NetworkError.custom(error.localizedDescription)
            }
            .tryMap { [self] (data, response) -> (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse, isOK(httpResponse) else {
                    throw NetworkError.invalidData
                }
                return (data, response)
            }
            .map(\.data)
            .decode(type: Output.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}


