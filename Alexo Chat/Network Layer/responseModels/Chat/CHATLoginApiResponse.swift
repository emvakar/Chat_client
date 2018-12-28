//
//  CHATSignupApiResponse.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct CHATLoginApiResponse: Codable {
    var id: String
    var token: String
    var nickname: String
    var isAdmin: Bool
}
