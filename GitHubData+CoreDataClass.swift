//
//  GitHubData+CoreDataClass.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 22.06.2022.
//
//

import Foundation
import CoreData

@objc(GitHubData)
public class GitHubData: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManger.instance.entityForName(entityName: "GitHubData"), insertInto: CoreDataManger.instance.context)
    }
}
