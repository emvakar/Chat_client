//
//  WS+AddedToRoom.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct MessageDeletedPayload: Codable {
    var id: String
    init (id: String) {
        self.id = id
    }
}
