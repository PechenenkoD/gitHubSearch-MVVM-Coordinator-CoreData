//
//  GitHubData+CoreDataClass.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 22.06.2022.
//
//

import CoreData

@objc(Repository)
public class Repository: NSManagedObject, Decodable {

    @NSManaged var login: String
    @NSManaged var id: NSNumber
    @NSManaged var url: String
    @NSManaged var type: String
    @NSManaged var html_url: String
    @NSManaged var node_id: String
    @NSManaged var avatar_url: String
    @NSManaged var events_url: String
    @NSManaged var followers_url: String
    @NSManaged var following_url: String
    @NSManaged var gists_url: String
    @NSManaged var organizations_url: String
    @NSManaged var received_events_url: String
    @NSManaged var repos_url: String
    @NSManaged var starred_url: String
    @NSManaged var subscriptions_url: String
    
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
        self.avatar_url = try owner.decode(String.self, forKey: .avatar_url)
        self.events_url = try owner.decode(String.self, forKey: .events_url)
        self.followers_url = try owner.decode(String.self, forKey: .followers_url)
        self.following_url = try owner.decode(String.self, forKey: .following_url)
        self.gists_url = try owner.decode(String.self, forKey: .gists_url)
        self.received_events_url = try owner.decode(String.self, forKey: .received_events_url)
        self.repos_url = try owner.decode(String.self, forKey: .repos_url)
        self.starred_url = try owner.decode(String.self, forKey: .starred_url)
        self.subscriptions_url = try owner.decode(String.self, forKey: .subscriptions_url)
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
        case avatar_url
        case events_url
        case followers_url
        case following_url
        case gists_url
        case received_events_url
        case repos_url
        case starred_url
        case subscriptions_url
    }
}
