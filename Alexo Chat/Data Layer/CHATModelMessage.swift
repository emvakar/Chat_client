//
//  CHATModels.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import DataSources
import MessageKit

class CHATModelMessage: Diffable {
    
    var diffIdentifier: String {
        return self.id
    }

    let id, roomID, text: String
    let createdAt: Date
    let updatedAt: Date
    let sender: CHATModelSender

    init(from model: CHATMessageAPIResponse) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.id = model.id
        self.roomID = model.roomID
        self.sender = CHATModelSender(from: model.sender)
        self.text = model.text
        self.updatedAt = formatter.date(from: model.updatedAt) ?? Date(timeIntervalSince1970: 0)
        self.createdAt = formatter.date(from: model.createdAt) ?? Date(timeIntervalSince1970: 0)
    }

    func convert() -> MessageModel {
        let sender = Sender(id: self.sender.id, displayName: self.sender.nickname)
        let message = MessageModel(text: self.text, sender: sender, messageId: self.id, date: self.createdAt)
        return message
    }
}
class CHATModelSender {
    let id, nickname: String
    let isAdmin: Bool
    let email: String
    let updatedAt, createdAt: Date
    
    init(from model: CHATSenderMessageAPIResponse) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.id = model.id
        self.nickname = model.nickname
        self.isAdmin = model.isAdmin
        self.email = model.email
        self.updatedAt = formatter.date(from: model.updatedAt) ?? Date(timeIntervalSince1970: 0)
        self.createdAt = formatter.date(from: model.createdAt) ?? Date(timeIntervalSince1970: 0)
    }
}
