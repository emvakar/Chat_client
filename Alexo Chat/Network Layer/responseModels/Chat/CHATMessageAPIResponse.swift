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
    let text: String
    let sender: CHATSenderMessageAPIResponse

    enum CodingKeys: String, CodingKey {
        case createdAt, id
        case roomID = "roomId"
        case updatedAt
        case sender
        case text
    }
}
struct CHATSenderMessageAPIResponse: Codable {
    let id, nickname, updatedAt, createdAt, email: String
    let isAdmin: Bool
}

