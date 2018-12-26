//
//  WS+AddedToRoom.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct MessageEditedPayload: Codable {
    var id: String
    var text: String
    init (id: String, text: String) {
        self.id = id
        self.text = text
    }
}
