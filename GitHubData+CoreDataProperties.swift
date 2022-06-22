//
//  GitHubData+CoreDataProperties.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 22.06.2022.
//
//

import Foundation
import CoreData


extension GitHubData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GitHubData> {
        return NSFetchRequest<GitHubData>(entityName: "GitHubData")
    }

    @NSManaged public var name: String?

}

extension GitHubData : Identifiable {

}
