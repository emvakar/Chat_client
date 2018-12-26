//
//  CHATSignupApiResponse.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

typealias CHATRoomsAPIResponse = [CHATRoomAPIResponse]

struct CHATRoomAPIResponse: Codable {
    let id: String
    let owners: [String]
    let members: [String]
    let updatedAt, createdAt: String
    let type, name: String
}
