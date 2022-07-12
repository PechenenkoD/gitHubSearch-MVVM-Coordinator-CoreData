//
//  ViewController.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import UIKit
import CoreData

private enum Defaults {
    static let numberOfSection = 0
    static let numberOfLineReduction = 30
    static let title = "Repositories"
    static let cellName = "cell"
}

final class RepositoryViewController: UIViewController, ViewCoordinator {

    // MARK: Properties
    var viewModel: RepositoryViewModelProtocol
    var coordinator: Coordiantor?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    let searchBar = UISearchBar()
    
    init(viewModel: RepositoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Defaults.title
        
        configureUISearchController()
        configureUITableView()

        viewModel.retrieve.bind { _ in
            self.tableView.reloadData()
        }
        
        viewModel.fetchData(text: searchBar.text!) { _, _  in }
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Methods
    func configureUISearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func configureUITableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Defaults.cellName)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

// MARK: - Extensions
extension RepositoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteringCreation(search: searchText)
    }
}

extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfObject(sections: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Defaults.cellName, for: indexPath)
        let fetchResult = viewModel.fetchResult(indexPath: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: Defaults.cellName)
        cell.textLabel?.text = fetchResult.login
        cell.detailTextLabel?.text = fetchResult.html_url.prefix(Defaults.numberOfLineReduction).appending("...")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.fetchResult(indexPath: indexPath)
        coordinator?.userButtonPressed(with: .tapped(object: model))
    }
}

extension RepositoryViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        viewModel.updateController()
    }
    
    
}
