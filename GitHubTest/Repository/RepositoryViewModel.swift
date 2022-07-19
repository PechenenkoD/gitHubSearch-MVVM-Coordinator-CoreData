//
//  MainViewModel.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import UIKit
import CoreData

private enum Defaults {
    static let numberOfSection = 0
    static let entityName = "Repository"
    static let login = "login"
}

protocol RepositoryViewModelProtocol {
    var retrieve: Observable<[Repository]> { get set }
    func fetchData(text: String, completion: @escaping(_ repo: [Repository]?, _ error: Error?) -> ())
    func filteringCreation(search: String)
    func fetchRequestPredicate(searchText: String)
    func numberOfObject(sections: Int) -> Int
    func fetchResult(indexPath: IndexPath) -> Repository
    func updateController()
}

struct RepositoryViewModel: RepositoryViewModelProtocol {
    
    // MARK: Properties
    private var fetchedResultsController: NSFetchedResultsController<Repository>
    private var persistentContainer: CoreDataStack!
    var retrieve: Observable<[Repository]> = Observable([])
    
    // MARK: Initialized
    init() {
        self.persistentContainer = CoreDataStack(persistentContainer: CoreDataStack.shared.persistentContainer)
        let fetchRequest = NSFetchRequest<Repository>(entityName: Defaults.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Defaults.login, ascending:true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.context,
                                                    sectionNameKeyPath: nil, cacheName: nil)

        self.fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    //MARK: Methods
    func fetchData(text: String, completion: @escaping(_ repo: [Repository]?, _ error: Error?) -> ()) {
        let urlString = "https://api.github.com/repositories?q=\(text)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Defaults.entityName)
                let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: fetchRequest)
                try CoreDataStack.shared.persistentContainer.viewContext.execute(deleteRequest)
                
                let jsonObject = try JSONDecoder().decode([Repository].self, from: data)
                print(jsonObject)
                
                var filteredJSONObject = [Repository]()
                
                jsonObject.forEach { repo in
                    if !filteredJSONObject.contains(where: { filterRepo in
                        filterRepo.id.intValue == repo.id.intValue
                    }) {
                        filteredJSONObject.append(repo)
                    } else {
                        CoreDataStack.shared.persistentContainer.viewContext.delete(repo)
                    }
                }
                completion(filteredJSONObject, nil)
                CoreDataStack.shared.saveContext()
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }

    func filteringCreation(search: String) {
        fetchRequestPredicate(searchText: search)
        do {
            try self.fetchedResultsController.performFetch()
            retrieve.value = []
        } catch {
            print(error)
        }
    }

    func fetchRequestPredicate(searchText: String) {
        if searchText != "" {
            let predicate = NSPredicate(format: "login contains[c] %@", searchText)
            fetchedResultsController.fetchRequest.predicate = predicate
        } else {
            fetchedResultsController.fetchRequest.predicate = nil
        }
    }
    
    func numberOfObject(sections: Int) -> Int {
        self.fetchedResultsController.sections?[sections].numberOfObjects ?? Defaults.numberOfSection
    }

    func fetchResult(indexPath: IndexPath) -> Repository {
        self.fetchedResultsController.object(at: indexPath)
    }
    
    func updateController() {
        retrieve.value = []
    }
    
}
