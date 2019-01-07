//
//  WS+AddedToRoom.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct TypingPayload: Codable {
    enum Action: String, Codable {
        case started, ended
    }
    var user: CHATModelUser.Payload?
    var roomId: String
    var action: Action
    
    
    enum CodingKeys: String, CodingKey {
        case user
        case roomId
        case action
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(CHATModelUser.Payload.self, forKey: .user)
        roomId = try container.decode(String.self, forKey: .roomId)
        action = try container.decode(Action.self, forKey: .action)
    }
    
}

struct OutgoingTypingPayload: Codable {
    enum Action: String, Codable {
        case started, ended
    }
    
    var roomId: String
    var action: Action
}
