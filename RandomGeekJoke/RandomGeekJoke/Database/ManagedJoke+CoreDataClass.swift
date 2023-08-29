//
//  ManagedJoke+CoreDataClass.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//
//

import CoreData

@objc(ManagedJoke)
class ManagedJoke: NSManagedObject {

    func localJoke(_ managedJoke: [ManagedJoke]) -> [String] {
        return managedJoke.compactMap { $0.joke }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedJoke> {
        return NSFetchRequest<ManagedJoke>(entityName: entity().name!)
    }
    
    static func instance(in context: NSManagedObjectContext) -> ManagedJoke {
        return ManagedJoke(context: context)
    }
    
    static func find(in context: NSManagedObjectContext) throws -> [ManagedJoke] {
        let request = NSFetchRequest<ManagedJoke>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    @nonobjc static func delete(joke: String, in context: NSManagedObjectContext, completion: @escaping LocalStore.DeletionCompletion) {
        
        let request = NSFetchRequest<ManagedJoke>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "joke == %@", joke)
        do {
            try context.fetch(request).map(context.delete).forEach(context.save)
            completion(nil)
        } catch {
            context.rollback()
            completion(error)
        }
    }
}

extension Array where Element == ManagedJoke {
    
    var localJoke: [String] {
        return self.compactMap { $0.joke }
    }
}
