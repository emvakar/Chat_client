//
//  WS+AddedToRoom.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct RoomMemberAddedPayload: Codable {

    var roomId: String
    var member: User.Payload

    init (roomId: String, member: User.Payload) {
        self.roomId = roomId
        self.member = member
    }
}
