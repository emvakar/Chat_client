//
//  CHATRoomApiRequest.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct CHATRoomApiRequest: NetworkRequest {

    var searchRoomText: String?
    let offset: Int
    let limit: Int

    var path: String {
        if let searchRoomText = self.searchRoomText {
            return "/rooms/search/\(searchRoomText)"
        }
        return "/rooms/my"
    }

    var method: RequestHTTPMethod {
        return .get
    }

    var params: [String: Any] {
        return ["offset": self.offset, "limit": self.limit]
    }

    var bodyParams: [String: Any] {
        return [:]
    }
}
