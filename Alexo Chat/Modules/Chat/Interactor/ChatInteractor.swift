//
//  ChatInteractor.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 28/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

class ChatInteractor: BaseInteractor { }

extension ChatInteractor: ChatInteractorProtocol {
    func fetchMessages(roomId: String, offset: Int, limit: Int, completion: @escaping (CHATMessagesAPIResponse?, NetworkError?) -> Void) {
        self.networkController.getMessages(from: roomId, offset: offset, limit: limit, completion: completion)
    }
    
    func sendMessage(roomId: String, text: String, completion: @escaping (NetworkError?) -> Void) {
        self.networkController.sendMessage(to: roomId, text: text) { (_, error) in
            completion(error)
        }
    }
    
    func inviteMember(roomId: String, userId: String, completion: @escaping (NetworkError?) -> Void) {
        self.networkController.inviteUser(to: roomId, userId: userId, completion: completion)
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
