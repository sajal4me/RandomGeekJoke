//
//  LocalJokeStorage.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import CoreData

enum RetrieveCachedFeedResult {
    case empty
    case found(joke: [String])
    case failure(Error)
}

protocol LocalStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    
    func deleteCached(joke: String, completion: @escaping DeletionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ joke: String, completion: @escaping InsertionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}


final class LocalJokeStorage: LocalStore {
    static let modelName = "RandomGeekJoke"
    static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: LocalJokeStorage.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    struct ModelNotFound: Error {
        let modelName: String
    }
    
    init(storeURL: URL) throws {
        guard let model = LocalJokeStorage.model else {
            throw ModelNotFound(modelName: LocalJokeStorage.modelName)
        }
        
        container = try NSPersistentContainer.load(
            name: LocalJokeStorage.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    func deleteCached(joke: String, completion: @escaping DeletionCompletion) {
        
        perform { context in
            ManagedJoke.delete(joke: joke, in: context, completion: completion)
        }
    }
    
    func insert(_ joke: String, completion: @escaping InsertionCompletion) {
        
        perform { context in
            do {
                let managedJoke = ManagedJoke.instance(in: context)
                managedJoke.joke = joke
                
                try context.save()
                completion(nil)
                
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                let request = NSFetchRequest<ManagedJoke>(entityName: ManagedJoke.entity().name!)
                request.returnsObjectsAsFaults = false
                let cache = try ManagedJoke.find(in: context)
                
                if !cache.isEmpty {
                    completion(.found(joke: cache.localJoke))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void)  {
        let context = self.context
        context.perform {
            action(context)
        }
    }
}

extension NSManagedObjectModel {
    convenience init?(name: String, in bundle: Bundle) {
        guard let momd = bundle.url(forResource: name, withExtension: "momd") else {
            return nil
        }
        self.init(contentsOf: momd)
    }
}

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }

        return container
    }
}
