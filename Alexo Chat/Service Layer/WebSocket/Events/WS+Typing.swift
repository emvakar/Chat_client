//
//  WS+AddedToRoom.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct TypingPayload: Codable {
    var userId: String
    var text: String
}

struct OutgoingTypingPayload: Codable {
    enum Action: String, Codable {
        case started, ended
    }
    
    var roomId: String
    var action: Action
}
