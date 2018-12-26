//
//  CHATModels.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import MessengerKit

struct User: MSGUser {

    let id: String
    let displayName: String
    var avatar: UIImage?
    var isSender: Bool = false

    init(id: String, displayName: String) {
        self.id = id
        self.displayName = displayName
        self.avatar = LetterImageGenerator.imageWith(name: id)
        self.isSender = (UserDefaults.standard.string(forKey: DefaultsKeys.user_id) == id)
    }

    struct Payload: Codable {
        var id: String?
        var email, nickname: String
    }
}
