//
//  CHATRoomApiRequest.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct CHATInviteToRoomApiRequest: NetworkRequest {

    var roomId: String
    var userId: String

    var path: String { return "/rooms/\(self.roomId)/\(self.userId)" }

    var method: RequestHTTPMethod {
        return .post
    }

    var params: [String: Any] {
        return [:]
    }

    var bodyParams: [String: Any] {
        return [:]
    }
}
