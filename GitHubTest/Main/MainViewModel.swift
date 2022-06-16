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










//class MainViewModel {
    
//    private var sourceURL = URL(string: "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json")!
//    var mainModel: MainModel?
//
//    func getData( completed: @escaping () -> () ) {
//        URLSession.shared.dataTask(with: sourceURL) { [weak self] (data, response, error) in
//            if let data = data {
//                let jsonDecoder = JSONDecoder()
//                let decodes = try! jsonDecoder.decode(MainModel.self, from: data)
//                self?.mainModel = decodes
//                print(decodes)
//                completed()
//            }
//        }.resume()
//    }
    
//        func getData( completed: @escaping () -> () ) {
//            let url = URL(string: "https://api.github.com/repositories")!
//                URLSession.shared.dataTask(with: url) { (data, response, error) in
//                    if error == nil {
//                        do {
//                            self.mainModel = try JSONDecoder().decode(MainModel.self, from: data!)
//                            DispatchQueue.main.async {
//                                completed()
//                            }
//                        } catch {
//                            print("error")
//                        }
//                    }
//            }.resume()
//        }
//https://quiz-68112-default-rtdb.firebaseio.com/quiz.json
    
//}
