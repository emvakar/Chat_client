//
//  WebsocketEventPrototype.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

enum WSEventType: String, Codable {
    case addedToRoom
    case joinedRoom
    case leftRoom
    case roomMemberAdded
    case message
    case messageDeleted
    case messageEdited
    case roomCreated
    case roomDeleted
    case typing
}

struct WSEventPrototype: Codable {
    var event: String
}

struct WSEvent<P: Codable>: Codable {
    let event: String
    let payload: P?

    init(event: String, payload: P?) {
        self.event = event
        self.payload = payload
    }
}

struct JoinEvent: Codable {
    var channel: String
}

struct LeaveEvent: Codable {
    var channel: String
}
