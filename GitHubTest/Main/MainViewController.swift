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

    // MARK: viedDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories"
        configureUISearchController()
        configureUITableView()
        
        viewModel?.link.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel?.dataProvider.fetchData{ (error) in }
    }

    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - configureUISearchController
    func configureUISearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        //searchController.searchResultsUpdater = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
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
        if searchText != "" {
            let predicate = NSPredicate(format: "url contains[c] %@", searchText)
            viewModel?.fetchedResultsController.fetchRequest.predicate = predicate
        } else {
            viewModel?.fetchedResultsController.fetchRequest.predicate = nil
        }
        
        do {
            try viewModel?.fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let fetchResult = viewModel?.fetchedResultsController.object(at: indexPath)
        if cell != nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text = fetchResult!.login
        cell.detailTextLabel?.text = fetchResult!.html_url.prefix(30).appending("...")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel?.fetchedResultsController.object(at: indexPath)
        coordinator?.eventOccurred(with: .tapped(object: model!))
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
