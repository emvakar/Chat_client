//
//  ChatPresenter.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 28/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import MessageKit

class ChatPresenter: BasePresenter {

    weak var view: ChatViewProtocol?
    private var wireFrame: ChatWireFrameProtocol
    private var interactor: ChatInteractorProtocol
    private var accountManager: AccountManager
    private let room: CHATModelRoom
    private var offset: Int = 0
    private var limit: Int = 20

    init(view: ChatViewProtocol, wireFrame: ChatWireFrameProtocol, interactor: ChatInteractorProtocol, accountManager: AccountManager, room: CHATModelRoom) {
        self.view = view
        self.interactor = interactor
        self.wireFrame = wireFrame
        self.accountManager = accountManager
        self.room = room
    }
}

extension ChatPresenter: ChatPresenterProtocol {
    func getSender() -> Sender {
        return Sender(id: self.accountManager.getUserId(), displayName: self.accountManager.getUsername())
    }

    func fetchMessages() {
        self.interactor.fetchMessages(roomId: self.room.id, offset: self.offset, limit: self.limit) { (apiModels, error) in

            var messages = [MessageModel]()
            if let error = error {
                print(error) // FIXME: - обработать ошибку
            }

            if let apiModels = apiModels?.sorted(by: { $0.createdAt < $1.createdAt }) {
                apiModels.forEach {
                    let model = CHATModelMessage(from: $0).convert()
                    messages.append(model)
                }
            }
            if self.offset > 0 {
                self.view?.insertMore(messages)
            } else {
                self.view?.initWith(messages)
            }
            if !(messages.count < self.limit) {
                self.offset += self.limit
            }
        }
    }
    func sendMessage(_ messageText: String) {
        self.interactor.sendMessage(roomId: self.room.id, text: messageText) { (error) in
            if error != nil {
                print("handle Error")
            }
        }
    }
}
