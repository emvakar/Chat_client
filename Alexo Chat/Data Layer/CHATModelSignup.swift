//
//  CHATModels.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

class CHATModelSignup {

    let id: String
    let email: String
    let nickname: String

    init(id: String, email: String, nickname: String) {
        self.id = id
        self.email = email
        self.nickname = nickname
    }
}
