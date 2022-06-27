//
//  GitHubData+CoreDataClass.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 22.06.2022.
//
//

import Foundation
import CoreData

@objc(Data)
public class Data: NSManagedObject, Decodable {

    @NSManaged var login: String
    @NSManaged var id: NSNumber
    @NSManaged var url: String
    @NSManaged var type: String
    @NSManaged var html_url: String
    @NSManaged var node_id: String

    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataStack.shared.persistentContainer.viewContext)
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        let owner = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .owner)
        self.login = try owner.decode(String.self, forKey: .login)
        self.id = try owner.decode(Int.self, forKey: .id) as NSNumber
        self.url = try owner.decode(String.self, forKey: .url)
        self.type = try owner.decode(String.self, forKey: .type)
        self.html_url = try owner.decode(String.self, forKey: .html_url)
        self.node_id = try owner.decode(String.self, forKey: .node_id)
    }
    
    enum ContainerKeys: String, CodingKey {
        case owner
    }
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case url
        case type
        case html_url
        case node_id
    }
}
