//
//  Networking.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) async throws -> T
}

internal final class Networking: NetworkProtocol {
    
    func request<T: Decodable>(endpoint: Endpoint, decoder: JSONDecoder) async throws -> T {
        var component = URLComponents()
        component.scheme = endpoint.scheme
        component.host = endpoint.baseURL
        component.path = endpoint.path
        component.queryItems = endpoint.parameters
        
        guard let url = component.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        let session = URLSession(configuration: .default)
        
        do  {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, isOK(httpResponse) else {
                throw NetworkError.invalidData
            }
            
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            throw NetworkError.decodableFail(error.localizedDescription)
        }
    }
    
    private func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}


