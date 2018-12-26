//
//  MessagesPresenter.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import MessengerKit

class MessagesPresenter: BasePresenter {

    weak var view: MessagesViewProtocol?
    private var wireFrame: MessagesWireFrameProtocol
    private var interactor: MessagesInteractorProtocol
    private var accountManager: AccountManager

    private var buffer = TypingBuffer(queue: DispatchQueue.main, delay: 2)

    private let room: CHATModelRoom

    private var isTyping: Bool = false
    private var isOwner: Bool = false

    init(view: MessagesViewProtocol, wireFrame: MessagesWireFrameProtocol, interactor: MessagesInteractorProtocol, accountManager: AccountManager, room: CHATModelRoom) {
        self.view = view
        self.interactor = interactor
        self.wireFrame = wireFrame
        self.accountManager = accountManager
        self.room = room
    }
}

extension MessagesPresenter: MessagesPresenterProtocol {

    func viewDidLoad() {

        self.fetchMessages()

        self.room.owners.forEach {
            if self.accountManager.getUserId() == $0 {
                self.isOwner = true
                self.view?.setInviteButton()
                return
            }
        }
    }

    func typingStart() {

        if !isTyping {
            self.interactor.startTyping(roomId: self.room.id)
            self.isTyping = true
            let credentials = self.getUserCredentials()
            let user = User(id: credentials.userId, displayName: credentials.nickname.isEmpty ? "Some user" : credentials.nickname)
            self.view?.startTyping(users: [user])
        }

        self.buffer.typing(typing: self.isTyping) { (typing) in
            print(typing, self.isTyping)
            defer { self.isTyping = false; self.view?.stopTyping() }
            self.interactor.stopTyping(roomId: self.room.id)
        }
    }

    func fetchMessages() {
        self.interactor.fetchMessages(roomId: self.room.id) { (response, error) in
            var messages = [MSGMessage]()
            if let error = error {
                print(error) // FIXME: - обработать ошибку
            }

            if let responseModel = response {
                responseModel.forEach {
                    let model = CHATModelMessage(from: $0).convert()
                    messages.append(model)
                }
            }
            self.view?.insertItems(messages)
        }
    }

    func sendMessage(_ message: MSGMessage) {
        let messageText: String
        switch message.body {
        case .text(let text):
            messageText = text
        default:
            messageText = ""
        }
        if messageText.isEmpty { return }
        self.interactor.sendMessage(roomId: self.room.id, text: messageText) { (error) in
            if let error = error {
                print(error) // FIXME: - обработать ошибку
                return
            }
        }
    }

    func getUserCredentials() -> (userId: String, nickname: String) {
        return (self.accountManager.getUserId(), self.accountManager.getUsername())
    }

    func inviteTapped(userId: String) {
        self.interactor.inviteMember(roomId: self.room.id, userId: userId) { (error) in
            // TODO: - Обработать по нормальному
            if let error = error {
                print(error.localizedDescription) // FIXME: - обработать ошибку
            } else {
                print("invite sended")
            }
        }
    }

}
