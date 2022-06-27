//
//  DetailViewController.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 16.06.2022.
//

import UIKit

class DetailViewController: UIViewController, ViewCoordinator {
    
    var viewModel: DetailViewModel?
    var coordinator: Coordiantor?
    var labelLogin: UILabel!
    var labelURL: UILabel!
    var labelType: UILabel!
    var labelNodeID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLabel()
        viewModel?.link.bind { details in
            self.labelLogin.text = details?.login
            self.labelURL.text = details?.html_url
            self.labelType.text = details?.type
            self.labelNodeID.text = details?.node_id
        }
    }
    
    private func setupUI() {
        title = "Detail"
        view.backgroundColor = .white
    }
    
    private func setupLabel() {
        labelLogin = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelLogin.center = CGPoint(x: 150, y: 285)
        labelLogin.textAlignment = .left
        labelLogin.text = ""
            self.view.addSubview(labelLogin)
        
        labelURL = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelURL.center = CGPoint(x: 150, y: 350)
        labelURL.textAlignment = .left
        labelURL.text = ""
            self.view.addSubview(labelURL)
        
        labelType = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelType.center = CGPoint(x: 150, y: 415)
        labelType.textAlignment = .left
        labelType.text = ""
            self.view.addSubview(labelType)
        
        labelNodeID = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelNodeID.center = CGPoint(x: 150, y: 475)
        labelNodeID.textAlignment = .left
        labelNodeID.text = ""
            self.view.addSubview(labelNodeID)
        
        labelLogin.text = viewModel?.link.value?.login
        labelURL.text = viewModel?.link.value?.html_url
        labelType.text = viewModel?.link.value?.type
        labelNodeID.text = viewModel?.link.value?.node_id
        
    }
}
