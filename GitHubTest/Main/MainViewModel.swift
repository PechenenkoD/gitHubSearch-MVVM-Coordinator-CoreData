//
//  MainViewModel.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import Foundation

struct MainViewModel {
    var user: Observable<[TableViewCellViewModel]> = Observable([])
    var viewModel: MainModel?
    
    func fetchData() {
        guard let url = URL(string: "https://api.github.com/repositories") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let userModels = try JSONDecoder().decode([MainModel].self, from: data)
                self.user.value = userModels.compactMap({
                    TableViewCellViewModel(html_url: $0.html_url)
                })
            }
            catch {
                
            }
        }
        task.resume()
    }
}

struct TableViewCellViewModel {
    let html_url: String
}
