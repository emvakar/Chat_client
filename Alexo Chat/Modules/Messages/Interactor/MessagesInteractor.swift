//
//  MessagesInteractor.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import MessengerKit

class MessagesInteractor: BaseInteractor { }

extension MessagesInteractor: MessagesInteractorProtocol {

    func inviteMember(roomId: String, userId: String, completion: @escaping (NetworkError?) -> Void) {
        self.networkController.inviteUser(to: roomId, userId: userId, completion: completion)
    }

    func fetchMessages(roomId: String, completion: @escaping (CHATMessagesAPIResponse?, NetworkError?) -> Void) {
        self.networkController.getMessages(from: roomId, completion: completion)
    }

    func sendMessage(roomId: String, text: String, completion: @escaping (NetworkError?) -> Void) {
        self.networkController.sendMessage(to: roomId, text: text) { (_, error) in
            completion(error)
        }
    }

    func startTyping(roomId: String) {
        print("TYPING - START")
        // FIXME: - Send Typing start
    }

    func stopTyping(roomId: String) {
        print("TYPING - STOP")
        // FIXME: - send typing stop
    }
}
