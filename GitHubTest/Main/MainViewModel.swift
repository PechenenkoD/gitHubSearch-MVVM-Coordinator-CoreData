//
//  MainViewModel.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import CoreData
import UIKit

struct MainViewModel {
    
    private var fetchedResultsController: NSFetchedResultsController<Repository>
    private var dataProvider: DataProvider!
    var link: Observable<[Repository]> = Observable([])
    
    init() {
        self.dataProvider = DataProvider(persistentContainer: CoreDataStack.shared.persistentContainer)
        let fetchRequest = NSFetchRequest<Repository>(entityName: "Repository")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.context,
                                                    sectionNameKeyPath: nil, cacheName: nil)

        self.fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func fetchData(text: String, completion: @escaping(_ filmsDict: [Repository]?, _ error: Error?) -> ()) {
        let urlString = "https://api.github.com/repositories?q=\(text)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//
//            guard let data = data else {
//                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
//                completion(nil, error)
//                return
//            }
            guard let data = data else { return }
            
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Repository")
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
            link.value = []
        } catch {
            print(error)
        }
    }

    func fetchRequestPredicate(searchText: String) {
        if searchText != "" {
            let predicate = NSPredicate(format: "url contains[c] %@", searchText)
            fetchedResultsController.fetchRequest.predicate = predicate
        } else {
            fetchedResultsController.fetchRequest.predicate = nil
        }
    }
    
    func numberOfObject(sections: Int) -> Int {
        self.fetchedResultsController.sections?[sections].numberOfObjects ?? 0
    }

    func fetchResult(indexPath: IndexPath) -> Repository {
        self.fetchedResultsController.object(at: indexPath)
    }
    
}
