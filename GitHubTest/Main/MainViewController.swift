//
//  ViewController.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController, ViewCoordinator {
    
    // MARK: var/let
    var viewModel: MainViewModel?
    var coordinator: Coordiantor?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    let searchBar = UISearchBar()

    // MARK: viedDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories"
        
        configureUISearchController()
        configureUITableView()
        
        viewModel?.link.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel?.fetchData(text: "text") { _, _  in }
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - configureUISearchController
    func configureUISearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
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
        viewModel?.filteringCreation(search: searchText)        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfObject(sections: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let fetchResult = viewModel?.fetchResult(indexPath: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = fetchResult!.login
        cell.detailTextLabel?.text = fetchResult!.html_url.prefix(30).appending("...")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel?.fetchResult(indexPath: indexPath)
        coordinator?.eventOccurred(with: .tapped(object: model!))
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
