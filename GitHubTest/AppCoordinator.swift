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
    
    func eventOccurred(with type: Event) {
        switch type {
        case .tapped(let object):
            let vc = DetailViewController()
            vc.coordinator = self
            let viewModel = DetailViewModel()
            viewModel.link.value = object
            vc.viewModel = viewModel
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func start() {
        var vc: UIViewController & ViewCoordinator = MainViewController()
        vc.coordinator = self
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    
}
