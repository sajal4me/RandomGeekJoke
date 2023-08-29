//
//  JokePresenter.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import UIKit

protocol JokeDelegate: AnyObject {
    func present(jokes: [JokeModel])
    func present(error: Error)
}

typealias JokePresenterDelegate = JokeDelegate & UIViewController

final class JokePresenter {
    
    weak var delegate: JokePresenterDelegate?
    private let repository: Repository
    private var jokesModel = [JokeModel]()
    
    init(repository: Repository) {
        self.repository = repository
    }
   
    func fetchJokes()  {
        Task { [weak self] in
            guard let self = self else { return }
            
            await repository.fetch(completion: { result in
                switch result {
                case .empty:
                    break
                case .found(let jokes):
                    let models = jokes.map { JokeModel.init(joke: $0) }
                    self.jokesModel.append(contentsOf: models)
                    
                    DispatchQueue.main.async {
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
}
