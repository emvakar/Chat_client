//
//  CHATModels.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import MessengerKit

class CHATModelMessage {

    let id, roomID, senderID, text: String
    let createdAt: Date
    let updatedAt: Date

    init(from model: CHATMessageAPIResponse) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.id = model.id
        self.roomID = model.roomID
        self.senderID = model.senderID
        self.text = model.text
        self.updatedAt = formatter.date(from: model.updatedAt) ?? Date(timeIntervalSince1970: 0)
        self.createdAt = formatter.date(from: model.createdAt) ?? Date(timeIntervalSince1970: 0)
    }

    func convert() -> MSGMessage {

        let user = User(id: self.senderID, displayName: self.senderID)
        let body = MSGMessageBody.text(self.text)
        let message = MSGMessage(id: self.id, body: body, user: user, sentAt: self.createdAt)

        return message
    }
}
