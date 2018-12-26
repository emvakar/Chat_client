//
//  CHATMessagesApiRequest.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct CHATMessageSendRoomApiRequest: NetworkRequest {

    var roomId: String
    var text: String

    var path: String { return "/messages" }

    var method: RequestHTTPMethod {
        return .post
    }

    var params: [String: Any] {
        return [:]
    }

    var bodyParams: [String: Any] {
        return ["roomId": self.roomId, "text": self.text]
    }
}
