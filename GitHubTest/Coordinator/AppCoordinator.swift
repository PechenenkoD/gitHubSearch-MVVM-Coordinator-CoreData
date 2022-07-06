//
//  AppCoordinator.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 17.06.2022.
//

import Foundation
import UIKit

class AppCoordinator: Coordiantor {
    var navigationController: UINavigationController?
    
    func userButtonPressed(with type: Event) {
        switch type {
        case .tapped(let object):
            let vc = DetailRepositoryViewController()
            vc.coordinator = self
            let viewModel = DetailRepositoryViewModel(detail: object)
            //viewModel.link.value = object
            vc.viewModel = viewModel
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func start() {
        let vc = RepositoryViewController()
        vc.coordinator = self
        vc.viewModel = RepositoryViewModel()
        navigationController?.setViewControllers([vc], animated: false)
    }
}
