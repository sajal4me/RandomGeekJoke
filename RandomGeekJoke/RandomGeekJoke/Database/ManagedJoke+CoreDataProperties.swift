//
//  ManagedJoke+CoreDataProperties.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//
//

import Foundation
import CoreData

extension ManagedJoke {
    @NSManaged public var joke: String

}

extension ManagedJoke : Identifiable {

}
