//
//  ViewController.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var viewModel = MainViewModel()
    var data: MainModel?
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub"
        configureUI()
        configureUISearchController()
        configureUITableView()
        
        viewModel.user.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.fetchData()
        
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - ConfigureUI
    func configureUI() {
        searchBar.sizeToFit()
        searchBar.delegate = self
    }
    
    // MARK: - configureUISearchController
    func configureUISearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Start editing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("End editing")
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.user.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.user.value?[indexPath.row].html_url
        return cell
    }

}

