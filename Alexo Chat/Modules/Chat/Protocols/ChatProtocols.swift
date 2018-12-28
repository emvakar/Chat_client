//
//  ChatProtocols.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 28/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import MessageKit

protocol ChatViewProtocol: class {
    
    func initWith(_ messages: [MessageModel])
    func insertMore(_ messages: [MessageModel])
}

protocol ChatWireFrameProtocol: class { }

protocol ChatPresenterProtocol: class {
    func fetchMessages()
    func getSender() -> Sender
    func sendMessage(_ messageText: String)
}

protocol ChatInteractorProtocol: class {
    func fetchMessages(roomId: String, offset: Int, limit: Int, completion: @escaping(CHATMessagesAPIResponse?, NetworkError?) -> Void)
    func sendMessage(roomId: String, text: String, completion: @escaping(NetworkError?) -> Void)
    func inviteMember(roomId: String, userId: String, completion: @escaping(NetworkError?) -> Void)
    func startTyping(roomId: String)
    func stopTyping(roomId: String)
}
