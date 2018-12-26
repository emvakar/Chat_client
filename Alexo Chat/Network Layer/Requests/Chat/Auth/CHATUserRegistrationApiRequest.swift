//
//  CHATUserRoomListApiRequest.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct CHATUserRoomListApiRequest: NetworkRequest {

    var nickname: String
    var email: String
    var password: String
    var isAdmin: Bool

    var path: String { return "/auth/signup" }

    var method: RequestHTTPMethod {
        return .post
    }

    var params: [String: Any] {
        return [:]
    }

    var bodyParams: [String: Any] {
        return ["nickname": self.nickname, "email": self.email, "password": self.password, "isAdmin": self.isAdmin]
    }
}
