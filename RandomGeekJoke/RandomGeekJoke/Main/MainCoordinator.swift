//
//  MainCoordinator.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import UIKit
 
protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func start()
}

final class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
   
    func start() {
        makeJokeViewControllerFactory()
    }
   
    init() {
        navigationController = UINavigationController()
    }
    
    private func makeJokeViewControllerFactory() {
       
        let presenter = makePresenter()
        let progressBarView = makeProgressBarViewFactory()
        
        let viewController = JokeViewController(
            presenter: presenter,
            progressBar: progressBarView)
        
        let progressBarButton = UIBarButtonItem(customView: progressBarView)
        viewController.navigationItem.rightBarButtonItem = progressBarButton
        viewController.title = "Joke of the Day"
        
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController = UINavigationController(rootViewController: viewController)
    }
    
    private func makePresenter() -> JokePresenter {
        let localStore: LocalStore
        do {
            localStore = try makeLocalStorageFactory()
        } catch {
            // log error 
            fatalError("PersistentContainer couldn't load unresolved error \(error)")
        }
        
        let remoteStore = Usecase()
        let repository = JokeRepository(
            localStore: localStore,
            remoteFetcher: remoteStore)
        
        return JokePresenter(repository: repository)
    }
    
    private func makeLocalStorageFactory() throws -> LocalStore {
        
        let localStore = try LocalJokeStorage(storeURL: storeURL())
        return localStore
    }
    
    private func storeURL() -> URL {
        
        let documentsDirectory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory
            .appendingPathComponent("\(LocalJokeStorage.modelName).sqlite")
    }
    
    private func makeProgressBarViewFactory() -> CircularProgressBarView {
        CircularProgressBarView(frame: CGRect(x:0, y: 10, width: 30, height: 30))
    }
}

