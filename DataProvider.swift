//
//  DataProvider.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 24.06.2022.
//

import CoreData

let dataErrorDomain = "dataErrorDomain"
var data = [Data]()

enum DataErrorCode: NSInteger {
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

class DataProvider {
    
    private let persistentContainer: NSPersistentContainer
    private let repository: MainViewModel
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, repository: MainViewModel) {
        self.persistentContainer = persistentContainer
        self.repository = repository
    }
    
    func fetchData(completion: @escaping(Error?) -> Void) {
        repository.fetchData() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard jsonDictionary != nil else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            completion(nil)
        }
    }
    
//    func fetchsData() -> [Data] {
//        do {
//            data = try viewContext.fetch(Data.fetchRequest()) as! [Data]
//        } catch {
//            print("Error")
//        }
//        return data
//    }
//    
//    func fetchSearchedData(text: String) -> [Data] {
//        let predicate = NSPredicate(format: "url contains %@", text)
//        let request: NSFetchRequest = Data.fetchRequest()
//        request.predicate = predicate
//        
//        do {
//            data = try (viewContext.fetch(request))
//        } catch {
//            print("Error while fetching data")
//        }
//        return data
//    }
    
}
