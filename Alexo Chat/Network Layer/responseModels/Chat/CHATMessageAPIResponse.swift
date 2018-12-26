//
//  CHATSignupApiResponse.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

typealias CHATMessagesAPIResponse = [CHATMessageAPIResponse]

struct CHATMessageAPIResponse: Codable {
    let createdAt, updatedAt: String
    let id, roomID: String
    let senderID, text: String

    enum CodingKeys: String, CodingKey {
        case createdAt, id
        case roomID = "roomId"
        case updatedAt
        case senderID = "senderId"
        case text
    }
}
