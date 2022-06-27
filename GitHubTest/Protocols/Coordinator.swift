//
//  Coordinator.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 17.06.2022.
//

import Foundation
import UIKit

enum Event {
    case tapped (
        object: Data
    )
}

protocol Coordiantor: AnyObject {
    var navigationController: UINavigationController? { get set }
    
    func eventOccurred(with type: Event)
    func start()
}

protocol ViewCoordinator {
    var coordinator: Coordiantor? { get set }
}
