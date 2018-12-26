//
//  CHATRoomApiRequest.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

struct CHATCreateRoomApiRequest: NetworkRequest {

    var name: String
    var shared: Bool

    var path: String { return "/rooms" }

    var method: RequestHTTPMethod {
        return .post
    }

    var params: [String: Any] {
        return [:]
    }

    var bodyParams: [String: Any] {
        return ["name": self.name, "shared": self.shared]
    }
}
