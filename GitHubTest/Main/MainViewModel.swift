//
//  MainViewModel.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import Foundation
import CoreData

struct MainViewModel {
    
    private init() {}
    static let shared = MainViewModel()
    
    var link: Observable<[Data]> = Observable([])

    static let api = URL(string: "https://api.github.com/repositories")
    
    public func fetchData(completion: @escaping(_ filmsDict: [Data]?, _ error: Error?) -> ()) {
        guard let url = MainViewModel.api else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
                let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: fetchRequest)
                try CoreDataStack.shared.persistentContainer.viewContext.execute(deleteRequest)
                
                let jsonObject = try JSONDecoder().decode([Data].self, from: data)
                print(jsonObject)
                completion(jsonObject, nil)
                CoreDataStack.shared.saveContext()
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
