//
//  NetworkProvider+Chat.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

// MARK: - User Methods
extension NetworkRequestProvider {

    func inviteUser(to roomId: String, userId: String, completion: @escaping (NetworkError?) -> Void) {
        let request = CHATInviteToRoomApiRequest(roomId: roomId, userId: userId)

        self.runRequest(request, progressResult: nil) { (_, _, error) in
            completion(error)
        }
    }
}
