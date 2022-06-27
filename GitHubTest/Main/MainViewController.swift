//
//  ViewController.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController, ViewCoordinator {
    
    var dataProvider: DataProvider!
    lazy var fetchedResultsController: NSFetchedResultsController<Data> = {
        let fetchRequest = NSFetchRequest<Data>(entityName: "Data")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    let searchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var viewModel: MainViewModel?
    var data: Data?
    var coordinator: Coordiantor?
    var filteredData = [Data]()

    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    private var isFiltering: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub"
        configureUISearchController()
        configureUITableView()
        
        viewModel?.link.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        dataProvider.fetchData{ (error) in }
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - configureUISearchController
    func configureUISearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    // MARK: - ConfigureUITableView
    func configureUITableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Extensions
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            isFiltering = true
            filterContentForSearchText(searchText)
        } else {
            isFiltering = false
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        guard let filteredDatas = viewModel?.link.value?.filter({ (search: Data) -> Bool in
            return search.url.lowercased().contains(searchText.lowercased())
        }) else {
            return
        }
        filteredData = filteredDatas
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let fetchResult = fetchedResultsController.object(at: indexPath)
//        
//        var datas: GitHubData
//
//        if isFiltering {
//            datas = filteredData[indexPath.row]
//        } else {
//            datas = filteredData[indexPath.row]
//
//        }
        
        cell.textLabel?.text = fetchResult.url.prefix(30).appending("...")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = fetchedResultsController.object(at: indexPath)
        coordinator?.eventOccurred(with: .tapped(object: model))
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
