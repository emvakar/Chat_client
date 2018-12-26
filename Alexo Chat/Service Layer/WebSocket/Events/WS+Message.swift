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
    var fromUser: User.Payload
    var room: CHATRoomAPIResponse
    var text: String

    init (type: MessageType, fromUser: User.Payload, room: CHATRoomAPIResponse, text: String) {
        self.type = type
        self.fromUser = fromUser
        self.room = room
        self.text = text
    }
}
