//
//  Repository.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Foundation
import CoreData

protocol Repository {
    func fetch(completion: @escaping LocalStore.RetrievalCompletion)
}

final class JokeRepository: Repository {
    private static let maxStorageAllowed = 10
    typealias JokeResult = Result<String, Error>
    
    private let localStore: LocalStore
    private let remoteFetcher: UsecaseProtocol
    
    init(localStore: LocalStore, remoteFetcher: UsecaseProtocol) {
        self.localStore = localStore
        self.remoteFetcher = remoteFetcher
    }
    
    func fetch(completion: @escaping LocalStore.RetrievalCompletion) {
        Task {
            let result = await fetch()
                        
            switch result {
            case .success(let joke):
                
                self.removeAndStore(joke: joke, completion: { [weak self] error in
                    if let error = error {
                        completion(.failure(error))
                    }
                    self?.retrieve(completion: completion)
                })
                
            case .failure:
                //  API Request fail, still looking for data in coredata to retrive previously stored jokes
                // In real app we can gracefully handle this error by showing Toast meaasage on UI
                self.retrieve(completion: completion)
            }
        }
    }
    
    private func fetch() async -> JokeResult  {
        do {
            let model: String = try await remoteFetcher.fetchJoke()
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
    
    private func removeAndStore(joke: String, completion: @escaping (Error?) -> Void) {
        
        self.retrieve { [weak self] result in
            guard let self = self else { return }

            guard case let .found(joke: data) = result, data.count >= JokeRepository.maxStorageAllowed else {
                
                self.store(joke: joke, completion: completion)
                return
            }
            
            if let first = data.first {
                self.remove(joke: first, completion: { [weak self] error in
                    self?.store(joke: joke, completion: completion)
                })
            }
        }
    }
    
    private func store(joke: String, completion: @escaping (Error?) -> Void) {
        self.localStore.insert(joke) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    private func retrieve(completion: @escaping LocalStore.RetrievalCompletion) {
        localStore.retrieve(completion: completion)
    }
    
    private func remove(joke: String, completion: @escaping LocalStore.DeletionCompletion)  {
        
        localStore.deleteCached(joke: joke, completion: completion)
    }
}

