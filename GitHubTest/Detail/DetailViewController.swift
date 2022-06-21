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
    var labelName: UILabel!
    var labelFullName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLabel()
        viewModel?.link.bind { details in
            self.labelName.text = details?.name
            self.labelFullName.text = details?.full_name
        }
    }
    
    private func setupUI() {
        title = "Detail"
        view.backgroundColor = .white
    }
    
    private func setupLabel() {
        labelName = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelName.center = CGPoint(x: 150, y: 285)
        labelName.textAlignment = .left
        labelName.text = ""
            self.view.addSubview(labelName)
        
        labelFullName = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelFullName.center = CGPoint(x: 150, y: 350)
        labelFullName.textAlignment = .left
        labelFullName.text = ""
            self.view.addSubview(labelFullName)
        
        labelName.text = viewModel?.link.value?.name
        labelFullName.text = viewModel?.link.value?.full_name
    }
}
