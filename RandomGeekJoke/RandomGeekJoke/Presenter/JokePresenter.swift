//
//  JokePresenter.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Foundation

protocol JokeDelegate: AnyObject {
    func present(jokes: [JokeModel])
    func present(error: Error)
}

final class JokePresenter {
    
    weak var delegate: JokeDelegate?
    private let repository: Repository
    private var jokesModel = [JokeModel]()
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func fetchJokes()  {
        repository.fetch(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .empty:
                DispatchQueue.main.async {
                    self.jokesModel.removeAll()
                    self.delegate?.present(jokes: self.jokesModel)
                }
                
            case .found(let jokes):
                DispatchQueue.main.async {
                    let models = jokes.map { JokeModel.init(joke: $0) }
                    self.jokesModel.append(contentsOf: models)
                    
                    self.delegate?.present(jokes: models)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.present(error: error)
                }
            }
        })
    }
}
