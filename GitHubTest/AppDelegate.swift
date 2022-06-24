//
//  AppDelegate.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 14.06.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coreDataStack = CoreDataStack.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = AppCoordinator()
        let navVC = UINavigationController()
        window.rootViewController = navVC
        coordinator.navigationController = navVC
        window.makeKeyAndVisible()
        self.window = window
        coordinator.start()

        return true
    }
}
