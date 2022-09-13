//
//  DetailViewController.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 16.06.2022.
//

import UIKit
import CoreData

private enum Defaults {
    static let numberOfSection = 0
    static let numberOfLineReduction = 30
    static let title = "Repositories"
    static let cellName = "cellDetail"
}

class DetailRepositoryViewController: UIViewController, ViewCoordinator {
    
    var coordinator: Coordiantor?
    var viewModel: DetailRepositoryViewModel?
    var viewMainModel: RepositoryViewModel?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUITableView()
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureUITableView() {
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "DetailRepositoryCell", bundle: nil), forCellReuseIdentifier: Defaults.cellName)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupUI() {
        title = "Detail"
        view.backgroundColor = .white
    }

}

extension DetailRepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailRepositoryCell = tableView.dequeueReusableCell(withIdentifier: Defaults.cellName, for: indexPath) as! DetailRepositoryCell
        var detail = ""
        
        if indexPath.row == 0 {
            detail = viewModel?.detail.login ?? ""
        } else if indexPath.row == 1 {
            detail = viewModel?.detail.url ?? ""
        } else if indexPath.row == 2 {
            detail = viewModel?.detail.gists_url ?? ""
        } else if indexPath.row == 3 {
            detail = viewModel?.detail.avatar_url ?? ""
        } else if indexPath.row == 4 {
            detail = viewModel?.detail.events_url ?? ""
        } else if indexPath.row == 5 {
            detail = viewModel?.detail.followers_url ?? ""
        } else if indexPath.row == 6 {
            detail = viewModel?.detail.following_url ?? ""
        } else if indexPath.row == 7 {
            detail = viewModel?.detail.html_url ?? ""
        } else if indexPath.row == 8 {
            detail = viewModel?.detail.node_id ?? ""
        } else if indexPath.row == 9 {
            detail = viewModel?.detail.organizations_url ?? ""
        } else {
            print("No value")
        }
        
        cell.configureCell(detail)
        
        return cell
    }
}
