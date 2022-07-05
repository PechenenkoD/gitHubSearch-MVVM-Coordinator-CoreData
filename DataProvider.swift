//
//  DataProvider.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 24.06.2022.
//

import CoreData

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

class DataProvider {
    
    private let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
}
