//
//  CHATMessagesApiRequest.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct CHATMessagesApiRequest: NetworkRequest {

    var roomId: String

    var path: String { return "/messages/\(self.roomId)" }

    var method: RequestHTTPMethod {
        return .get
    }

    var params: [String: Any] {
        return [:]
    }

    var bodyParams: [String: Any] {
        return [:]
    }
}
