//
//  WS+AddedToRoom.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct MessagePayload: Codable {

    enum MessageType: String, Codable {
        case direct, group
    }

    var type: MessageType
    var fromUser: CHATModelUser.Payload
    var room: CHATRoomAPIResponse
    var text: String

    enum CodingKeys: String, CodingKey {
        case type
        case fromUser
        case room
        case text
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(fromUser, forKey: .fromUser)
        try container.encode(room, forKey: .room)
        try container.encode(text, forKey: .text)
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(MessageType.self, forKey: .type)
        fromUser = try container.decode(CHATModelUser.Payload.self, forKey: .fromUser)
        room = try container.decode(CHATRoomAPIResponse.self, forKey: .room)
        text = try container.decode(String.self, forKey: .text)
    }
    
    init (type: MessageType, fromUser: CHATModelUser.Payload, room: CHATRoomAPIResponse, text: String) {
        self.type = type
        self.fromUser = fromUser
        self.room = room
        self.text = text
    }
}
