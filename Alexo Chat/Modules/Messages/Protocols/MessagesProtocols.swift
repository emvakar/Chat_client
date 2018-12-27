//
//  MessagesProtocols.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import MessengerKit

protocol MessagesViewProtocol: class {
    func insertItems(_ models: [MSGMessage])
    func startTyping(users: [MSGUser])
    func stopTyping()
    func setInviteButton()
}

protocol MessagesWireFrameProtocol: class { }

protocol MessagesPresenterProtocol: class {
    func viewDidLoad()
    func getUserCredentials() -> (userId: String, nickname: String)
    func sendMessage(_ message: MSGMessage)
    func typingStart()
    func inviteTapped(userId: String)
}

protocol MessagesInteractorProtocol: class {
    func fetchMessages(roomId: String, completion: @escaping(CHATMessagesAPIResponse?, NetworkError?) -> Void)
    func sendMessage(roomId: String, text: String, completion: @escaping(NetworkError?) -> Void)
    func inviteMember(roomId: String, userId: String, completion: @escaping(NetworkError?) -> Void)
    func startTyping(roomId: String)
    func stopTyping(roomId: String)
}
