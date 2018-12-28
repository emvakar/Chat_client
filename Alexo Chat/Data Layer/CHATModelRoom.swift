//
//  CHATModels.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import DataSources

class CHATModelRoom: NSObject, Diffable {

    var diffIdentifier: String {
        return self.id
    }
    
    @objc let id: String
    let owners: [String]
    let members: [String]
    let updatedAt, createdAt: Date
    let type, name: String

    init(from model: CHATRoomAPIResponse) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        self.id = model.id
        self.owners = model.owners
        self.members = model.members
        self.updatedAt = formatter.date(from: model.updatedAt ?? "") ?? Date(timeIntervalSince1970: 0)
        self.createdAt = formatter.date(from: model.createdAt ?? "") ?? Date(timeIntervalSince1970: 0)
        self.type = model.type
        self.name = model.name
    }
}
