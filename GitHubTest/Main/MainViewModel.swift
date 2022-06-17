//
//  MainViewModel.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import Foundation

struct MainViewModel {
    var link: Observable<[MainModel]> = Observable([])
    
    func fetchData() {
        guard let url = URL(string: "https://api.github.com/repositories") else { return }
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
}
