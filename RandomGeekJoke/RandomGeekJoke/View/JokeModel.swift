//
//  JokeModel.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import Foundation

struct JokeModel: Hashable {
    let id: UUID
    let joke: String
}

extension JokeModel {
    init(joke: String) {
        self.id = UUID()
        self.joke = joke
    }
}
