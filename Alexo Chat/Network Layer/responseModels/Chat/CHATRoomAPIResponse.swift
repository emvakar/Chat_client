//
//  CHATSignupApiResponse.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

typealias CHATRoomsAPIResponse = [CHATRoomAPIResponse]

struct CHATRoomAPIResponse: Codable {
    let id: String
    let owners: [String]
    let members: [String]
    let updatedAt, createdAt: String?
    let type, name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case owners
        case members
        case updatedAt
        case createdAt
        case type
        case name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(owners, forKey: .owners)
        try container.encode(members, forKey: .members)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        owners = try container.decode([String].self, forKey: .owners)
        members = try container.decode([String].self, forKey: .members)
        // FIXME: - Need to be decode dates
        updatedAt = ""//try container.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = ""//try container.decodeIfPresent(String.self, forKey: .createdAt)
        type = try container.decode(String.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        
    }
}
