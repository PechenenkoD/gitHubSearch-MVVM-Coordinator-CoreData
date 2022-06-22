//
//  MainViewModel.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import Foundation
import CoreData

struct MainViewModel {
    var link: Observable<[MainModel]> = Observable([])

    static let api = URL(string: "https://api.github.com/repositories")
    
    public func fetchData() {
        guard let url = MainViewModel.api else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let userModels = try JSONDecoder().decode([MainModel].self, from: data)
                self.link.value = userModels
            }
            catch {
                print("Error")
            }
        }
        task.resume()
    }
    
    public func coreData() {
        let managedObject = GitHubData()
        
        managedObject.name = "test"
        
        let name = managedObject.name
        
        print("\(name))")
        
        CoreDataManger.instance.saveContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GitHubData")
        do {
            let results = try CoreDataManger.instance.context.fetch(fetchRequest)
            for result in results as! [GitHubData] {
                print("name - \(result.name)")
            }
        } catch {
            print(error)
        }
    }

}
