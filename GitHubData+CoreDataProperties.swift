//
//  GitHubData+CoreDataProperties.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 22.06.2022.
//
//

import Foundation
import CoreData


extension Data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Data> {
        return NSFetchRequest<Data>(entityName: "Data")
    }

    @NSManaged public var name: String?

}

