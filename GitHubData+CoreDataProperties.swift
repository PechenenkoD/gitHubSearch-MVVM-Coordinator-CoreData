//
//  GitHubData+CoreDataProperties.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 22.06.2022.
//
//

import Foundation
import CoreData


extension Repository {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repository> {
        return NSFetchRequest<Repository>(entityName: "Repository")
    }
}

